//
//  TransitionsViewController.swift
//  Animations
//
//  Created by admin on 07/01/20.
//  Copyright © 2020 Nihilent. All rights reserved.
//

import UIKit

class TransitionsViewController: UIViewController {

    var greenView:UIView!
    var redView:UIView!
    var containerView: UIView!
    
    var redViewHidden = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addTransitionButton()
        addViews()
    }
  
    func addTransitionButton() {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Transition", for:.normal)
        button.addTarget(self, action: #selector(transitionAction), for: .touchUpInside)
        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant:150).isActive = true
        button.heightAnchor.constraint(equalToConstant:50).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
    }
 
    func addViews() {
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .yellow
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
        containerView.widthAnchor.constraint(equalToConstant: 200),
        containerView.heightAnchor.constraint(equalToConstant: 200),
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        greenView = UIView()
        greenView.translatesAutoresizingMaskIntoConstraints = false
        greenView.backgroundColor = .green
        containerView.addSubview(greenView)
        
        greenView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        greenView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        greenView.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        greenView.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        
        //redView
        redView = UIView()
        redView.backgroundColor = .red
        redView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(redView)
//        redView.constraints = greenView.constraints //is this possible?
        NSLayoutConstraint.activate([
            redView.widthAnchor.constraint(equalToConstant: 200),
            redView.heightAnchor.constraint(equalToConstant: 200),
            redView.leadingAnchor.constraint(equalTo: greenView.leadingAnchor, constant:0),
            redView.topAnchor.constraint(equalTo: greenView.topAnchor, constant:0)
        ])
    }
    
    
    @objc func transitionAction() {
        animateUsingTransition()
    }
    
    func animateUsingTransition() {
        let viewToAnimate = (redViewHidden ? greenView : redView)!
        let viewToHide = (redViewHidden ? redView : greenView)!
        
//        UIView.transition(with: viewToAnimate, duration: 0.5, options: [.transitionCurlUp, .showHideTransitionViews], animations: {
//            self.redViewHidden = !self.redViewHidden
//        }) { (finish) in
//            self.view.bringSubviewToFront(viewToHide)
//        }
        
        UIView.transition(from: viewToAnimate, to: viewToHide, duration: 0.5, options: [.transitionCurlUp, .showHideTransitionViews]) { (finish) in
                        self.redViewHidden = !self.redViewHidden

        }
    }
}
