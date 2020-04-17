//
//  ImageViewAnimationController.swift
//  Animations
//
//  Created by admin on 06/03/20.
//  Copyright © 2020 Nihilent. All rights reserved.
//

import UIKit

class ImageViewAnimationController: UIViewController {

    let imageView: UIImageView = {
        let iv = UIImageView()
//        iv.backgroundColor = .gray
        iv.isUserInteractionEnabled = true
        iv.image = UIImage(named:"tile00")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    let animationImages:[UIImage] = {
        var images = [UIImage]()
        for i in 0...28 {
            images.append(UIImage(named: "tile0\(i)")!)
        }
        return images
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(sender:))))

        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }

    @objc func imageViewTapped(sender:UITapGestureRecognizer) {
        print("ass")
        imageView.animationImages = animationImages
        
        imageView.animationDuration = 1 // default time is 30fps (number images * 1/30th seconds)
        imageView.animationRepeatCount = 1
        imageView.startAnimating()
    }
}
