//
//  GradientViewController.swift
//  Animations
//
//  Created by admin on 09/03/20.
//  Copyright © 2020 Nihilent. All rights reserved.
//

import UIKit

class GradientViewController: UIViewController {
     
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
            
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = blurView.frame
            gradientLayer.colors = [UIColor.red.cgColor, UIColor.cyan.cgColor]
            gradientLayer.locations = [0.3, 0.6]
            blurView.layer.addSublayer(gradientLayer)
        }
        
        @objc func sliderAction(slide:UISlider) {
            animator.fractionComplete = CGFloat(slide.value)
        }
    }
