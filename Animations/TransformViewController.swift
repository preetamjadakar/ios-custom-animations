//
//  TransformViewController.swift
//  Animations
//
//  Created by admin on 16/01/20.
//  Copyright © 2020 Nihilent. All rights reserved.
//

import UIKit

class TransformViewController: UIViewController {
    
    @IBOutlet weak var someView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    fileprivate func animateMyView() {
        print("frame: \(someView.frame)")
        print("bounds: \(someView.bounds)")
        UIView.animate(withDuration: 5, delay: 0, options:[.curveLinear], animations: { [weak self] in
            if let exist = self {
                exist.someView.transform = exist.someView.transform.rotated(by: .pi)
            }
            }, completion:{ [weak self] (a:Bool)  in
                if let exist = self {
                    print("after transform")
                    print("frame: \(exist.someView.frame)")
                    print("bounds: \(exist.someView.bounds)")
                    exist.animateMyView()
                }
        })
    }
    
    @IBAction func style1Action(_ sender: Any) {
        UIView.animate(withDuration: 5, delay: 0, options:[.curveLinear], animations: { [weak self] in
            if let exist = self {
            exist.someView.transform = CGAffineTransform(rotationAngle: .pi)
            }
        }, completion:{ (a:Bool) in
        })
    }
    
    @IBAction func style2Action(_ sender: Any) {
        animateMyView()
    }
    
    @IBAction func pushView(_ sender: Any) {
        someView.layer.removeAllAnimations()
        view.layer.removeAllAnimations()
        view.layoutIfNeeded()
    }
}
