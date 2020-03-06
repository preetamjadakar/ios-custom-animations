//
//  ClientViewController.swift
//  Animations
//
//  Created by admin on 03/02/20.
//  Copyright © 2020 Nihilent. All rights reserved.
//

import UIKit

class ClientViewController: UIViewController {
    @IBOutlet weak var secondsCountView: SecondsCountDownView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBOutlet weak var sky: UIView!
    @IBOutlet weak var sun: UIImageView!
    @IBAction func style1Action(_ sender: Any) {
        secondsCountView.progress = 60
    }
    @IBAction func style2Action(_ sender: Any) {
        secondsCountView.progress = 30
    }
    @IBAction func style3Action(_ sender: Any) {
        sky.backgroundColor = .yellow
        let path = UIBezierPath()
        path.move(to:CGPoint(x:sky.bounds.maxX, y:sky.bounds.maxY))
        path.addQuadCurve(to: CGPoint(x:0,y:sky.bounds.maxY), controlPoint:CGPoint(x:sky.bounds.midX, y:0))
        
        let animation = CAKeyframeAnimation(keyPath:"position")
        animation.path = path.cgPath
        animation.duration = 2
        sun.layer.add(animation, forKey:animation.keyPath)
        sun.center = CGPoint(x:0, y:sky.bounds.maxY)
    }
    
}
