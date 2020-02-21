//
//  PJButton.swift
//  Animations
//
//  Created by admin on 21/02/20.
//  Copyright © 2020 Nihilent. All rights reserved.
//

import UIKit

class PJButton: UIButton {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    func setUp() {
        layer.cornerRadius = 10
        layer.borderColor = UIColor.blue.cgColor
        layer.borderWidth = 1.0
    }
}
