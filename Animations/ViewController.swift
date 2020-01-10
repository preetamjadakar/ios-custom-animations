//
//  ViewController.swift
//  Animations
//
//  Created by admin on 06/01/20.
//  Copyright © 2020 Nihilent. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "iOS Animations"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
}

