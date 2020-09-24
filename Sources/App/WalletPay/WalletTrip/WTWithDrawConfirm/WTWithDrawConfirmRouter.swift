//  File name   : WTWithDrawConfirmRouter.swift
//
//  Author      : MacbookPro
//  Created date: 5/24/20
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2020 Vato. All rights reserved.
//  --------------------------------------------------------------

import RIBs

protocol WTWithDrawConfirmInteractable: Interactable, WTWithDrawSuccessListener {
    var router: WTWithDrawConfirmRouting? { get set }
    var listener: WTWithDrawConfirmListener? { get set }
}

protocol WTWithDrawConfirmViewControllable: ViewControllable {
    // todo: Declare methods the router invokes to manipulate the view hierarchy.
}

final class WTWithDrawConfirmRouter: ViewableRouter<WTWithDrawConfirmInteractable, WTWithDrawConfirmViewControllable> {
    /// Class's constructor.

    init(interactor: WTWithDrawConfirmInteractable, viewController: WTWithDrawConfirmViewControllable, wtWithDrawSuccessBuildable: WTWithDrawSuccessBuildable) {
        self.wtWithDrawSuccessBuildable = wtWithDrawSuccessBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }

    // MARK: Class's public methods
    override func didLoad() {
        super.didLoad()
    }
    
    /// Class's private properties.
    private let wtWithDrawSuccessBuildable: WTWithDrawSuccessBuildable
}
// MARK: WTWithDrawConfirmRouting's members
extension WTWithDrawConfirmRouter: WTWithDrawConfirmRouting {
    func showAlertError(messageError: String) {
        AlertVC.showMessageAlert(for: self.viewController.uiviewController, title: "Thông báo ", message: messageError, actionButton1: "Đóng", actionButton2: nil)
    }
    
    func goToSuccess(_ info: (TopupCellModel?, Int?)) {
        let route = wtWithDrawSuccessBuildable.build(withListener: interactor, info: info)
        let segue = RibsRouting(use: route, transitionType: .push , needRemoveCurrent: false )
        perform(with: segue, completion: nil)
    }
    
    func goToWDSuccess(_ info: BankTransactionInfo) {
        let route = wtWithDrawSuccessBuildable.build(withListener: interactor, bankInfo: info)
        let segue = RibsRouting(use: route, transitionType: .push , needRemoveCurrent: false )
        perform(with: segue, completion: nil)
    }

}

// MARK: Class's private methods
private extension WTWithDrawConfirmRouter {
}
