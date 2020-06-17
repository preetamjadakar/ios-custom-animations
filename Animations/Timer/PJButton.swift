//
//  PJButton.swift
//  Animations
//
//  Created by admin on 23/02/20.
//  Copyright © 2020 preetamjadakar. All rights reserved.
//

import UIKit

class LocalizableButton: UIButton {
    override func awakeFromNib() {
        if let value = self.titleLabel?.text {
            setTitle(value.localized, for: .normal)
        }
    }
}

class PJButton: LocalizableButton {
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                layer.borderColor = progressiveLayerColor.cgColor
                setTitleColor(progressiveLayerColor, for: .normal)
            } else {
                layer.borderColor = lightGrayColor.cgColor
                setTitleColor(lightGrayColor, for: .normal)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }

    func setUp() {
        addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        layer.cornerRadius = 4
        layer.borderWidth = 1.0
        layer.borderColor = progressiveLayerColor.cgColor
        setTitleColor(progressiveLayerColor, for: .normal)
        titleLabel?.font = isIPAD ? fontStyle3 : fontStyle2
    }
    
    @objc func buttonClicked (_ sender:UIButton) {
        //animation to express click event
        UIView.animate(withDuration: 0.3, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        }) { (finished) in
            sender.transform = .identity
        }
    }
}
