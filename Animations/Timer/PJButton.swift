//
//  PJButton.swift
//  Animations
//
//  Created by admin on 21/02/20.
//  Copyright © 2020 Nihilent. All rights reserved.
//

import UIKit

class PJButton: UIButton {

    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                layer.borderColor = tintColor.cgColor
            } else {
                layer.borderColor = UIColor.lightGray.cgColor
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    func setUp() {
        layer.cornerRadius = 4
        layer.borderWidth = 1.0
        layer.borderColor = tintColor.cgColor
        titleLabel?.font = fontStyle2
    }
}
