//
//  KeyframeViewController.swift
//  Animations
//
//  Created by admin on 11/03/20.
//  Copyright © 2020 Nihilent. All rights reserved.
//

import UIKit

class KeyframeViewController: UIViewController {
    
    var animator = UIViewPropertyAnimator(duration:2, curve: .linear, animations:nil)
    var imageView = UIImageView(image:#imageLiteral(resourceName: "backImage"))
    var blurView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    var circleLayer: CAShapeLayer!
    var circlePath: UIBezierPath!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        imageView.frame = view.frame
        imageView.contentMode = .scaleAspectFill
        view.addSubview(blurView)
        blurView.frame = view.frame
        blurView.alpha = 0.5
        blurView.layer.cornerRadius = blurView.frame.width / 2.0
        blurView.layer.borderWidth = 100
        blurView.layer.borderColor = UIColor.white.cgColor
        blurView.clipsToBounds = true
//        blurView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        blurView.frame = CGRect.init(x: blurView.frame.origin.x, y: blurView.frame.origin.y + (blurView.frame.height - blurView.frame.width)/2, width: blurView.frame.width, height: blurView.frame.width)

//        blurView.layer.masksToBounds = true
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
        
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = blurView.frame
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.cyan.cgColor]
//        gradientLayer.locations = [0.3, 0.5]
        blurView.layer.addSublayer(gradientLayer)
        
        //add circle
        circlePath = UIBezierPath(arcCenter: CGPoint.init(x: blurView.frame.midX, y: blurView.frame.width/2), radius: blurView.frame.width/2, startAngle: CGFloat(-Double.pi/2), endAngle: CGFloat(3/2 * Double.pi), clockwise: true)
        circleLayer = CAShapeLayer()
        circleLayer.frame = blurView.bounds
//        let point = blurView.center
        circleLayer.lineWidth = 4
        circleLayer.fillColor = UIColor.red.cgColor
        circleLayer.strokeColor = UIColor.white.cgColor
        circleLayer.path = circlePath.cgPath
        blurView.layer.addSublayer(circleLayer)
        blurView.transform = CGAffineTransform(scaleX:0.7, y:0.7)
        perform(#selector(animation), with:nil, afterDelay: 2)

    }
    
    @objc func sliderAction(slide:UISlider) {
        animator.fractionComplete = CGFloat(slide.value)
    }
    
    @objc fileprivate func animation() {
//        let animation = CAKeyframeAnimation(keyPath: "position")
//        animation.values = [CGPoint(x:0, y:0), CGPoint(x:10, y:10), CGPoint(x:20, y:20), CGPoint(x:10, y:10), CGPoint(x:0, y:0)]
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [0.7, 0.5, 0.3, 0.5, 0.45, 0.7]
        animation.keyTimes = [0, 0.2, 0.4, 0.5, 0.6, 0.8, 1]
        animation.duration = 1.5
        animation.repeatCount = .infinity
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        blurView.layer.add(animation, forKey: animation.keyPath!)
        
        let cornerRadiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
        cornerRadiusAnimation.fromValue = 0
        cornerRadiusAnimation.toValue = blurView.frame.width / 2.0
        cornerRadiusAnimation.duration = 1.5
        cornerRadiusAnimation.repeatCount = .infinity
        cornerRadiusAnimation.fillMode = .forwards
        cornerRadiusAnimation.isRemovedOnCompletion = false
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [animation, cornerRadiusAnimation]
        
        blurView.layer.add(animationGroup, forKey: cornerRadiusAnimation.keyPath!)
    }
}
