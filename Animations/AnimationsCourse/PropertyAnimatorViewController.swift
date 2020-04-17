//
//  PropertyAnimatorViewController.swift
//  Animations
//
//  Created by admin on 08/03/20.
//  Copyright © 2020 Nihilent. All rights reserved.
//

import UIKit

class PropertyAnimatorViewController: UIViewController {

//    var animator: UIViewPropertyAnimator!
//    var widthAnchor: NSLayoutConstraint!
    var centerView = UIView()

    var animator = UIViewPropertyAnimator(duration:2, curve: .linear, animations:nil)
    var imageView = UIImageView(image:#imageLiteral(resourceName: "backImage"))
    var blurView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(imageView)
        imageView.frame = view.frame
        imageView.contentMode = .scaleAspectFill
        view.addSubview(blurView)
        blurView.frame = view.frame
        blurView.alpha = 0.5
        animator.addAnimations {
            self.blurView.alpha = 1
            self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
        }
        

        let slider = UISlider()
        slider.addTarget(self, action: #selector(sliderAction(slide:)), for: .allEvents)
        view.addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        slider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        slider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        view.addSubview(centerView)
        centerView.translatesAutoresizingMaskIntoConstraints = false

        centerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        widthAnchor = centerView.widthAnchor.constraint(equalToConstant: 200)
//        widthAnchor.isActive = true
        centerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        centerView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        centerView.backgroundColor = .red

        perform(#selector(animate), with: nil, afterDelay:2)
    }
    
    @objc func sliderAction(slide:UISlider) {
//        widthAnchor.constant = 100 + CGFloat(100 * slide.value)
        animator.fractionComplete = CGFloat(slide.value)
//        animator = UIViewPropertyAnimator(duration:2, dampingRatio:0.9 ,animations:{
//            self.centerView.backgroundColor = .blue
//            self.view.layoutIfNeeded()
//        })
//
//        animator.startAnimation()
    }

    @objc fileprivate func animate() {
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: [.curveLinear], animations: {
            var transform = CGAffineTransform.identity
            transform = transform.rotated(by: 3/2 * .pi)
            transform = transform.scaledBy(x:2, y:2)
            self.centerView.transform = transform
        }, completion:{ finish in
            self.centerView.transform = CGAffineTransform.identity
        })
    }
}
