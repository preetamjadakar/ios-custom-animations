//
//  TransformViewController.swift
//  Animations
//
//  Created by admin on 16/01/20.
//  Copyright © 2020 preetamjadakar. All rights reserved.
//
/*
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
 */
import UIKit

class TransformViewController: UIViewController {
    
    @IBOutlet weak var someView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func style2Action(_ sender:Any) {
        rotate360Recursively()
    }
    
    func rotate360Recursively() {
//        Timer.scheduledTimer(withTimeInterval:1, repeats:true){_ in
//            UIView.animate(withDuration:0.5, delay:0, options:.curveLinear, animations:{[unowned self] in
//                self.someView.transform = self.someView.transform.rotated(by:.pi)
//            })
//            UIView.animate(withDuration:0.5, delay:0.5, options:.curveLinear, animations:{[unowned self] in
//                self.someView.transform = self.someView.transform.rotated(by:.pi)
//            })
//        }
//        Timer.scheduledTimer(withTimeInterval:1, repeats:true){(timer) in
//        }
        //        let rotationAnimation = CABasicAnimation(keyPath:"transform.rotation")
        //        rotationAnimation.fromValue = 0
        //        rotationAnimation.toValue = Double.pi
        //        rotationAnimation.duration = 1
        //        rotationAnimation.repeatCount = .infinity
        //        rotationAnimation.isCumulative = true
        //        someView.layer.add(rotationAnimation, forKey:"someKey")
//        UIView.animate(withDuration:3, animations:{[unowned self] in
////            self.someView.transform = CGAffineTransform(translationX: 100, y: 100)
//            print(self.iconView.frame)
//            print(self.iconView.center)
//            self.iconView.transform = CGAffineTransform(translationX:23, y:23)
//
//            }, completion:{ [unowned self] (_ ) in
//                print(self.iconView.frame)
//                print(self.iconView.center)
//        })
               let animation = CABasicAnimation(keyPath: "transform.rotation")
               animation.toValue = CGFloat.pi
               animation.isCumulative = true
               animation.duration = 3
               animation.repeatCount = Float.infinity
                someView.layer.add(animation, forKey:animation.keyPath)
    }

    @IBOutlet weak var iconView: UIImageView!
    
    @IBAction func pushView(_ sender:Any) {
        iconView.layer.removeAllAnimations()
    }
}
