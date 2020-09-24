//
//  BannerHelpert.swift
//  FC
//
//  Created by vato. on 3/2/20.
//  Copyright © 2020 Vato. All rights reserved.
//

import Foundation

@objcMembers
final class BannerHelper: NSObject {
    private struct Config {
        static let kPrefixImageViewFooter = "driver_bg_footer_top_main"
        static let kTagImageViewFooter = 4582
        static let kTimeImageDuration = 5 // senconds
    }
    
    static func loadFooterBanner() -> UIImageView? {
        var bottomInsets: CGFloat = 60
        var listsImage = ThemeManager.instance.loadListPDF(by: Config.kPrefixImageViewFooter)
        if listsImage.isEmpty, let image = ThemeManager.instance.loadPDFImage(name: Config.kPrefixImageViewFooter) {
            listsImage.append(image)
        }
        
        if !listsImage.isEmpty {
            bottomInsets += 20
        }
        
        guard !listsImage.isEmpty else { return nil }
        let imageView = UIImageView(frame: .zero)
        
        let animate = listsImage.count > 1
        if animate {
            imageView.tag = Config.kTagImageViewFooter
            imageView.animationImages = listsImage
            imageView.animationDuration = TimeInterval(Config.kTimeImageDuration * listsImage.count)
            imageView.animationRepeatCount = 0
        } else {
            imageView.image = listsImage.first
        }
        
        guard animate else { return imageView }
        imageView.startAnimating()
        
        return imageView
    }
}
