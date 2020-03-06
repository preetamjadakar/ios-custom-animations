//
//  AnimateWithDurationViewController.swift
//  Animations
//
//  Created by admin on 07/01/20.
//  Copyright © 2020 preetamjadakar. All rights reserved.
//
/*
 import UIKit
 
 class AnimateWithDurationViewController: UIViewController {
 
 weak var centerView: UIView!
 
 override func viewDidLoad() {
 super.viewDidLoad()
 // Do any additional setup after loading the view.
 centerView = addViewAtCenter()
 addRadius(toView: centerView)
 }
 
 override func viewDidAppear(_ animated: Bool) {
 super.viewDidAppear(animated)
 }
 
 @IBAction func style1Action(_ sender: Any) {
 animateStyle1(centerView: centerView)
 }
 
 @IBAction func style2Action(_ sender: Any) {
 }
 
 //Add View
 func addViewAtCenter() -> UIView {
 let centerView = UIView()
 centerView.translatesAutoresizingMaskIntoConstraints = false
 view.addSubview(centerView)
 
 centerView.backgroundColor = .red
 centerView.widthAnchor.constraint(equalToConstant: 50).isActive = true
 centerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
 centerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
 centerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
 return centerView
 }
 
 func addRadius(toView:UIView) {
 toView.layoutIfNeeded() //important to get latest frame/bound values
 toView.layer.masksToBounds = false
 toView.layer.cornerRadius = toView.frame.width/2
 toView.layer.shadowColor = UIColor.black.cgColor
 toView.layer.shadowOffset = CGSize.init(width: 2, height: 1)
 toView.layer.shadowRadius = 3
 toView.layer.shadowOpacity = 0.5 // [0-1] opposite of transparent
 //add border
 //            toView.layer.borderColor = UIColor.green.cgColor
 //            toView.layer.borderWidth = 2
 }
 
 func animateStyle1(centerView:UIView) {
 let offsetValue = self.view.frame.width-150
 UIView.animate(withDuration: 2, animations: {
 centerView.frame = centerView.frame.offsetBy(dx:offsetValue , dy: 0)
 }, completion:{ (finished) in
 UIView.animate(withDuration: 3, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: [.curveEaseIn], animations: {
 centerView.frame = centerView.frame.offsetBy(dx: -offsetValue, dy: 0)
 }, completion: nil)
 })
 //            UIView.animate(withDuration: 2, delay: 0, options: [.repeat, .autoreverse] ,animations: {
 //               centerView.frame = centerView.frame.offsetBy(dx:offsetValue , dy: 0)
 //           } ,completion:nil)
 }
 }
 */

import UIKit

class AnimateWithDurationViewController: UIViewController {
    
    weak var centerView:UIView!
    var originalFrame:CGRect!
    override func loadView() {
        super.loadView()
        addCenterView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addCornerRadius()
    }
    
    func addCenterView() {
        let centerViewTemp = UIView(frame: .zero)
        centerViewTemp.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(centerViewTemp)
        centerViewTemp.backgroundColor = .red
        NSLayoutConstraint.activate([
            centerViewTemp.widthAnchor.constraint(equalToConstant: 100),
                centerViewTemp.heightAnchor.constraint(equalToConstant: 100),
                centerViewTemp.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 0),
            centerViewTemp.centerYAnchor.constraint(equalTo:view.centerYAnchor)
        ])
        
        
        centerView = centerViewTemp
    }
    func addCornerRadius() {
        view.layoutIfNeeded()
        centerView.layer.cornerRadius = centerView.frame.width/2
        centerView.layer.borderWidth = 2.0
        centerView.layer.borderColor = UIColor.black.cgColor
        centerView.layer.shadowColor = UIColor.black.cgColor
        centerView.layer.shadowOpacity = 0.5
            centerView.layer.shadowOffset = CGSize(width:3, height:3)
    }

        @IBAction func style1Action(_ sender:Any) {
            view.layoutIfNeeded()
            originalFrame = self.centerView.frame

            UIView.animate(withDuration:1, delay:0, usingSpringWithDamping:1, initialSpringVelocity:1, options: [.curveLinear, .autoreverse, .repeat], animations: { [unowned self] in
               self.centerView.frame = self.centerView.frame.offsetBy(dx:300, dy:0)
           })
    }
    @IBAction func style2Action(sender: Any) {
        centerView.frame = originalFrame
        centerView.layer.removeAllAnimations()
    }


}

