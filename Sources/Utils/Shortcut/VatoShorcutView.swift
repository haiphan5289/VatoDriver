//  File name   : VatoShorcutView.swift
//
//  Author      : Dung Vu
//  Created date: 2/19/20
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2020 Vato. All rights reserved.
//  --------------------------------------------------------------

import UIKit
import SnapKit
import FwiCore

@objcMembers
final class VatoShorcutView: UIControl {
    /// Class's public properties.
    private let imageView: UIImageView
    /// Class's private properties.
    init(named: String) {
        imageView = UIImageView(image: UIImage(named: named))
        super.init(frame: .zero)
        visualize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func visualize() {
        backgroundColor = .clear
        imageView >>> self >>> {
            $0.contentMode = .scaleAspectFit
            $0.isUserInteractionEnabled = false
            $0.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        
        let list = UIImage.loadListImage(from: "ic_vato_list_animate")
        imageView.animationImages = list
        imageView.animationDuration = 1.5
        imageView.animationRepeatCount = 0
        imageView.startAnimating()
    }
}




