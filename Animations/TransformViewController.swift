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
        UIView.animate(withDuration: 5, delay: 0, options:[.curveLinear], animations: {
            self.someView.transform = self.someView.transform.rotated(by: .pi)
        }, completion:{ (a:Bool) in
            print("after transform")
            print("frame: \(self.someView.frame)")
            print("bounds: \(self.someView.bounds)")
            self.animateMyView()
        })
    }
    
    @IBAction func style1Action(_ sender: Any) {
        UIView.animate(withDuration: 5, delay: 0, options:[.curveLinear], animations: {
            self.someView.transform = CGAffineTransform(rotationAngle: .pi)
        }, completion:{ (a:Bool) in
        })
    }
    
    @IBAction func style2Action(_ sender: Any) {
        animateMyView()
    }
    
}
