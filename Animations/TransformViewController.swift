//
//  TransformViewController.swift
//  Animations
//
//  Created by admin on 16/01/20.
//  Copyright © 2020 preetamjadakar. All rights reserved.
//

import UIKit

class TransformViewController: UIViewController {
    
    @IBOutlet weak var someView: UIView!
    
    var isAnimating = false
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
        }, completion:nil)
    }
    
    @IBAction func style2Action(_ sender: Any) {
        animateMyView()
    }
    
    fileprivate func style3Animation(_ sender: Any) {
        if !isAnimating {return}
        UIView.animate(withDuration: 1, delay: 0, options:[.curveLinear], animations: { [weak self] in
            if let exist = self {
                exist.someView.transform = CGAffineTransform(rotationAngle: .pi)
            }
            }, completion:nil)
        UIView.animate(withDuration: 1, delay: 0, options:[.curveLinear], animations: { [weak self] in
            if let exist = self {
                exist.someView.transform = exist.someView.transform.rotated(by: .pi)
            }
            }, completion:{finished in
                self.style3Animation(sender)
        })
    }
    
    @IBAction func style3Action(_ sender: Any) {
        if isAnimating { return }
        isAnimating = true
        style3Animation(sender)
    }
    @IBAction func pushView(_ sender: Any) {
        isAnimating = false
    }
}
