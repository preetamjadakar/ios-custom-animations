//
//  ViewController.swift
//  Animations
//
//  Created by admin on 06/01/20.
//  Copyright © 2020 preetamjadakar. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "iOS Animations"
    }

    @IBAction func animateWithDurationAction(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let animationVC = storyboard.instantiateViewController(withIdentifier: "animatewithduration") as! AnimateWithDurationViewController
        animationVC.title = (sender as! UIButton).titleLabel?.text
        self.navigationController?.pushViewController(animationVC, animated: true)
    }
    
    @IBAction func transitionsAction(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let transitionVC = storyboard.instantiateViewController(withIdentifier: "transitions") as! TransitionsViewController
        transitionVC.title = (sender as! UIButton).titleLabel?.text
        
        self.navigationController?.pushViewController(transitionVC, animated:true)
    }
    
    @IBAction func transformButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let transitionVC = storyboard.instantiateViewController(withIdentifier: "transforms") as! TransformViewController
        transitionVC.title = (sender as! UIButton).titleLabel?.text
        
        self.navigationController?.pushViewController(transitionVC, animated:true)
    }
    
    @IBAction func animatorButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let transitionVC = storyboard.instantiateViewController(withIdentifier: "animator") as! ViewAnimatorViewController
        transitionVC.title = (sender as! UIButton).titleLabel?.text
        self.navigationController?.pushViewController(transitionVC, animated:true)
    }
    @IBAction func imageViewAnimation(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "AnimationCourseStoryboard", bundle: nil)
              let transitionVC = storyboard.instantiateViewController(withIdentifier: "imageViewAnimation") as! ImageViewAnimationController
              transitionVC.title = (sender as! UIButton).titleLabel?.text
              self.navigationController?.pushViewController(transitionVC, animated:true)
    }
}

