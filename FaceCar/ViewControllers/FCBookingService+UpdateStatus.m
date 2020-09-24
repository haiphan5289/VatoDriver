//
//  FCBookingService+UpdateStatus.m
//  FC
//
//  Created by Dung Vu on 10/16/19.
//  Copyright © 2019 Vato. All rights reserved.
//

#import "FCBookingService+UpdateStatus.h"
#import "FCBookingService+BookStatus.h"
#import "TripTrackingManager.h"
#import "TripListenNewTripManager.h"
#if DEV
#import "Driver_DEV-Swift.h"
#else
#import "VATO_Driver-Swift.h"
#endif
#import "BookViewController.h"
@import FirebaseAnalytics;
@interface FCBookingService (Checking)
@property (strong, nonatomic) TripTrackingManager *tripTracking;
@property (strong, nonatomic) RACSubject *updateCommand;
@end

@implementation FCBookingService (UpdateStatus)
- (void) updateBookStatus: (NSInteger) status
                 complete: (void (^) (BOOL success)) complete {
    [self updateBookStatus:status
                      book:self.book
                  complete:complete];
}

- (void) updateBookStatus: (NSInteger) status
                     book: (FCBooking*) book
                 complete: (void (^) (BOOL success)) complete {
    // Nếu trạng thái đã tồn tại rồi -> BỎ QUA
    if ([self isExistStatus:status]) {
        if (complete) { complete(YES); }
        return;
    }
    
    // Nếu trạng thái ghi vào không phải là NEW BOOK và currentData bị null (nghĩa là book đã bị xoá) -> BỎ QUA
    if (!book.command) {
        if (book.info.tripType == BookTypeDigital) {
            if (status != BookStatusStarted) {
                if (complete) { complete(YES); }
                return;
            }
        }
        else {
            if (status != BookStatusClientCreateBook) {
                if (complete) { complete(YES); }
                return;
            }
        }
    }
    
    // Tài xế chấp nhận -> nếu khách đã huỷ trước đó -> BỎ QUA
    if (status == BookStatusDriverAccepted) {
        if ([self isClientCanceled:book]) {
            if (complete) { complete(YES); }
            return;
        }
    }
    
    // Tài xế hết thơi gian nhận chuyến -> nếu đã vào chuyến đi thành công || khách đã huỷ -> BỎ QUA
    if (status == BookStatusDriverMissing) {
        if ([self isInTrip:book] || [self isFinishedTrip:book]) {
            if (complete) { complete(YES); }
            return;
        }
    }
    
    // Nếu khách huỷ trong khi book -> kiểm tra nếu đã vào chuyến rồi -> BỎ QUA
    if (status == BookStatusClientTimeout || status == BookStatusClientCancelInBook) {
        if ([self isTripStarted:book] || [self isInTrip:book]) {
            if (complete) { complete(YES); }
            return;
        }
    }
    
    // Nếu khách huỷ trong chuyến đi -> kiểm tra nếu đã bắt đầu rồi hoặc đã kết thúc rồi -> BỎ QUA
    if (status == BookStatusClientCancelIntrip) {
        if ([self isTripStarted:book] || [self isFinishedTrip:book]) {
            if (complete) { complete(YES); }
            return;
        }
    }
    
    // Nếu tài xế báo đang bận xử lý một booking khác -> kiểm tra xem book này đã ở trạng thái kết thúc rồi -> BỎ QUA
    if (status == BookStatusDriverBusyInAnotherTrip) {
        if ([self isFinishedTrip:book] || [self isInTrip:book]) {
            if (complete) { complete(YES); }
            return;
        }
    }
    
    if (status == BookStatusDriverCancelIntrip) {
        if ([self isTripStarted:book] || [self isFinishedTrip:book]) {
            if (complete) { complete(YES); }
            return;
        }
    }
    // Cập nhật status mới
    [self processUpdateStatus:status book:book];
    if (complete) { complete(YES); }
}

- (void) processUpdateStatus: (NSInteger) status
                        book: (FCBooking*) book
{
    
    // status
    FCBookCommand* stt = [[FCBookCommand alloc] init];
    stt.status = status;
    stt.time = [self getCurrentTimeStamp];
    NSString *tripId = book.info.tripId ?: @"";
    [FIRAnalytics logEventWithName:@"driver_update_command_trip"
                        parameters:@{@"book_id": tripId,
                                     @"command": @(status).stringValue }];
    @weakify(self);
    void(^removeTrip)(void) = ^{
        [TripListenNewTripManager setDataTripNotify:book.info.tripId json:@{} completion:^(NSError * _Nullable error) {
            if (error) {
                NSAssert(NO, [error localizedDescription]);
            }
        }];
    };
    
    void(^BlockSuccess)(void) = ^{
        @strongify(self);
        [FIRAnalytics logEventWithName:@"driver_update_command_success"
                            parameters:@{@"book_id": tripId,
                                         @"command": @(status).stringValue }];
        [self.updateCommand sendNext:stt];
        if (status == 14) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                removeTrip();
            });
        }
    };
    
    
    
    // New flow: Update api -> agree, cancel, ignore
    BOOL(^CheckCallApi)(NSInteger) = ^BOOL(NSInteger s) {
        return s == BookStatusDriverAccepted || s == BookStatusDriverCancelInBook || s == BookStatusDriverMissing;
    };
    BOOL callAPI = CheckCallApi(status);
    void(^BlockError)(NSError *) = ^(NSError *error){
        @strongify(self);
        NSString *message = error.localizedDescription ?: @"";
        [FIRAnalytics logEventWithName:@"driver_update_command_fail"
                            parameters:@{@"book_id": tripId,
                                         @"command": @(status).stringValue,
                                         @"reason": message }];
        if (callAPI) {
            [IndicatorUtils dissmiss];
            [self processFinishedTrip:book];
            removeTrip();
            [[self class] updateDriverStatus:DRIVER_READY funcName:[NSString stringWithFormat:@"%s line: %d",__FUNCTION__, __LINE__]];
            
            UIViewController *(^TopControllerVC)(void) = ^UIViewController *{
                UIViewController *rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
                UIViewController *resultVC = [UIApplication topViewControllerWithController:rootVC];
                return resultVC;
            };
            
            void(^showAlert)(void) = ^{
                UIViewController *topVC = TopControllerVC();
                if (!topVC) {
                    return;
                }
                [UIAlertController showInViewController:topVC
                                              withTitle:@"Thông báo"
                                                message:[error localizedDescription]
                                         preferredStyle:UIAlertControllerStyleAlert
                                      cancelButtonTitle:@"OK"
                                 destructiveButtonTitle:nil
                                      otherButtonTitles:@[]
                     popoverPresentationControllerBlock:nil tapBlock:nil];
            };
            
            BookViewController *bookVC = [BookViewController castFrom:TopControllerVC()];
            if (bookVC) {
                [bookVC dismissViewControllerAnimated:YES completion:showAlert];
            } else {
                showAlert();
            }
        } else {
            if (status != BookStatusDriverAccepted) {
                [self.updateCommand sendNext:stt];
            }
        }
    };
    
    if (callAPI) {
        NSString *token = [[FirebaseTokenHelper instance] token];
        NSString *tripId = book.info.tripId ?: @"";
        NSString *path = [NSString stringWithFormat:@"trip/%@/confirmations", tripId];
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params addEntriesFromDictionary:@{@"status" : @(status)}];
        CLLocation *location = [[VatoLocationManager shared] location];
        CLLocationCoordinate2D coordinate = location.coordinate;
        NSDictionary *l = @{@"location": @{ @"lat": @(coordinate.latitude),
                                            @"lon": @(coordinate.longitude)} };
        [params addEntriesFromDictionary:l];
        Boolean isAutoAcceptTrip = [[AutoReceiveTripManager shared] flagAutoReceiveTripManager];
        NSDictionary *isAutoAccept = @{@"isAutoAcceptTrip": @(isAutoAcceptTrip)};
        [params addEntriesFromDictionary:isAutoAccept];
        [[RequesterObjc instance] requestWithToken:token path:path method:@"POST" header:nil params:params trackProgress:NO handler:^(NSDictionary<NSString *,id> * _Nullable r, NSError * _Nullable e) {
            if (e) {
                BlockError(e);
                return;
            }
            NSError *err;
            FCResponse *res = [[FCResponse alloc] initWithDictionary:r ?: @{} error:&err];
            if (err) {
                BlockError(err);
                return;
            }
            
            if (res.status != 200) {
                err = [[NSError alloc] initWithDomain:NSURLErrorDomain code:NSURLErrorUnknown userInfo:@{NSLocalizedDescriptionKey: res.message ?: @""}];
                BlockError(err);
                return;
            }
            
            BlockSuccess();
        }];
        return;
    }
    
    
    // Old flow
    NSMutableDictionary* data = [[NSMutableDictionary alloc] initWithDictionary:[stt toDictionary]];
    NSString *key = [NSString stringWithFormat:@"D-%ld", (long)status];
    NSString *path = [NSString stringWithFormat:@"command/%@",key];
    // tracking
    NSDictionary* dictTracking = [self trackingBookInfo:stt book:book];
    NSString *pathTracking = [NSString stringWithFormat:@"%@/%ld", kBookTracking, (long)stt.status];
    [[[self.tripTracking updateMutipleValue:@{path: data,
                                              @"": @{@"last_command": key},
                                              pathTracking: dictTracking}
                                     update:YES] timeout:TIME_OUT_UPDATE_STATUS onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        BlockSuccess();
    } error:^(NSError *error) {
        BlockError(error);
    }];
}
@end
