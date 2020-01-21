//
//  AnimateWithDurationViewController.swift
//  Animations
//
//  Created by admin on 07/01/20.
//  Copyright © 2020 Nihilent. All rights reserved.
//

import UIKit

class AnimateWithDurationViewController: UIViewController {

        var centerView: UIView!
        
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
