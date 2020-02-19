//
//  TransitionsViewController.swift
//  Animations
//
//  Created by admin on 07/01/20.
//  Copyright © 2020 preetamjadakar. All rights reserved.
//
/*
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
        UIView.transition(from: viewToAnimate, to: viewToHide, duration: 0.5, options: [.transitionCurlUp, .showHideTransitionViews]) { (finish) in
                        self.redViewHidden = !self.redViewHidden

        }
    }
}
*/


import UIKit

class TransitionsViewController: UIViewController {
    
    weak var redView:UIView!
    weak var blackView:UIView!
    weak var containerView:UIView!

    weak var actionButton:UIButton!
    var redViewHidden = true
    override func loadView() {
        super.loadView()
        let tempContainerView = UIView()
        tempContainerView.backgroundColor = .green
             tempContainerView.translatesAutoresizingMaskIntoConstraints = false
             view.addSubview(tempContainerView)
             tempContainerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
             tempContainerView.widthAnchor.constraint(equalToConstant: 200).isActive = true
             tempContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
             tempContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
             containerView = tempContainerView
        
        let tempRedView = UIView()
        tempRedView.backgroundColor = .red
        tempRedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(tempRedView)
        tempRedView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        tempRedView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        tempRedView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        tempRedView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        redView = tempRedView
        
        let tempBlackView = UIView()
             tempBlackView.backgroundColor = .black
             tempBlackView.translatesAutoresizingMaskIntoConstraints = false
             containerView.addSubview(tempBlackView)
             tempBlackView.heightAnchor.constraint(equalToConstant: 200).isActive = true
             tempBlackView.widthAnchor.constraint(equalToConstant: 200).isActive = true
             tempBlackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
             tempBlackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
             blackView = tempBlackView
        
        let tempActionButton = UIButton(type:.system)
        tempActionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tempActionButton)
        tempActionButton.setTitle("Transform", for:.normal)
        tempActionButton.addTarget(self, action:#selector(transformAction(_ :)), for:.touchUpInside)
        tempActionButton.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        tempActionButton.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor, constant: -100).isActive = true
        
        actionButton = tempActionButton
        print(#function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @objc func transformAction(_ sender: UIButton) {
//        UIView.transition(with: redView, duration: 2, options: .transitionFlipFromRight, animations: nil, completion: nil)
        let viewToShow = redViewHidden ? blackView! : redView!
        let viewToHide = redViewHidden ? redView! : blackView!
//        UIView.transition(from: viewToShow!, to: viewToHide!, duration: 1, options: [.transitionCrossDissolve, .showHideTransitionViews], completion: { finished in
//            self.redViewHidden = !self.redViewHidden
//        })
//        let alert = UIAlertController.init(title: "title", message: "some message", preferredStyle: .alert)
//        alert.addAction(UIAlertAction.init(title: "okay", style: .default, handler: { (action) in
//
//        }))
//        self.present(alert, animated: true, completion: nil)
//        UIView.transition(with: blackView, duration:1, options:.transitionFlipFromRight, animations: nil, completion: nil)
//        UIView.transition(from:viewToHide, to: viewToShow, duration:1, options:[.transitionFlipFromRight, .showHideTransitionViews], completion:{ [unowned self] (finished) in
//                    self.redViewHidden = !self.redViewHidden
//                })
        
//        let viewToShow = redViewHidden ? blackView! : redView!
//        let viewToHide = redViewHidden ? redView! : blackView!

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            UIView.transition(from:viewToHide, to: viewToShow, duration:1, options:[.transitionFlipFromRight, .showHideTransitionViews], completion:{ [unowned self] (finished) in
            self.redViewHidden = !self.redViewHidden
            })
        })
    }
}
