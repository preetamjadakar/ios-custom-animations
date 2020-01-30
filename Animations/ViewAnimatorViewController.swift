//
//  ViewAnimatorViewController.swift
//  Animations
//
//  Created by admin on 27/01/20.
//  Copyright © 2020 preetamjadakar. All rights reserved.
//

import UIKit

private enum State {
    case closed
    case open
}

extension State {
    var opposite: State {
        switch self {
        case .open: return .closed
        case .closed: return .open
        }
    }
}

class ViewAnimatorViewController: UIViewController {
    
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewTapped(recognizer:)))
        return recognizer
    }()
    private lazy var placeholderTapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(placeholderPopupViewTapped(recognizer:)))
        return recognizer
    }()
    private lazy var panRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(panGestureRecognizer(gesture:)))
        return recognizer
    }()
   
    // MARK: - Constants
    private let popupOffset: CGFloat = 440
    private let animationDuration:TimeInterval = 2
    
    private lazy var popupView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMinYCorner]
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 10
        return view
    }()
    var popupViewBottomConstraint: NSLayoutConstraint!
    var runningAnimators = [UIViewPropertyAnimator]()
    /// The progress of each animator. This array is parallel to the `runningAnimators` array.
    private var animationProgress = [CGFloat]()
    
    
    private lazy var reviewsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "reviews")
        return imageView
    }()
    private lazy var closedTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Reviews"
        label.font = UIFont.init(name: "Avenir", size: 15)
        label.textColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var openTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Reviews"
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.heavy)
        label.textColor = .black
        label.textAlignment = .center
        label.alpha = 0
        label.transform = CGAffineTransform(scaleX: 0.65, y: 0.65).concatenating(CGAffineTransform(translationX: 0, y: -15))
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        layout()
        popupView.addGestureRecognizer(tapRecognizer)
        popupView.addGestureRecognizer(panRecognizer)
    }
    
    private var bottomConstraint = NSLayoutConstraint()
    
    private func layout() {
        popupView.translatesAutoresizingMaskIntoConstraints = false
        let placeholderView = UIView(frame: CGRect(x:0, y:0, width:0, height:0))
        view.addSubview(placeholderView)
        popupView.addGestureRecognizer(placeholderTapRecognizer)
        popupView.addGestureRecognizer(tapRecognizer)
        view.addSubview(popupView)
        popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomConstraint = popupView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 440)
        bottomConstraint.isActive = true
        popupView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        reviewsImageView.translatesAutoresizingMaskIntoConstraints = false
        popupView.addSubview(reviewsImageView)
        reviewsImageView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor).isActive = true
        reviewsImageView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor).isActive = true
        reviewsImageView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor).isActive = true
        reviewsImageView.heightAnchor.constraint(equalToConstant: 428).isActive = true
        
        closedTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        popupView.addSubview(closedTitleLabel)
        closedTitleLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor).isActive = true
        closedTitleLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor).isActive = true
        closedTitleLabel.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 20).isActive = true
        
        openTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        popupView.addSubview(openTitleLabel)
        openTitleLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor).isActive = true
        openTitleLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor).isActive = true
        openTitleLabel.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 30).isActive = true
        
    }
    
    private var currentState: State = .closed
    
    
    fileprivate func animateTransitionIfNeeded() {
        let state = currentState.opposite
        let transitionAnimator = UIViewPropertyAnimator(duration: animationDuration, dampingRatio: 1, animations: {
            switch state {
            case .open:
                self.bottomConstraint.constant = 0
                self.popupView.layer.cornerRadius = 20
                self.closedTitleLabel.transform = CGAffineTransform(scaleX: 1.6, y: 1.6).concatenating(CGAffineTransform(translationX: 0, y: 15))
                self.openTitleLabel.transform = .identity
                self.openTitleLabel.alpha = 1
                self.closedTitleLabel.alpha = 0
            case .closed:
                self.bottomConstraint.constant = 440
                self.popupView.layer.cornerRadius = 0
                self.closedTitleLabel.transform = .identity
                self.openTitleLabel.transform = CGAffineTransform(scaleX: 0.65, y: 0.65).concatenating(CGAffineTransform(translationX: 0, y: -15))
                self.openTitleLabel.alpha = 0
                self.closedTitleLabel.alpha = 1
            }
            self.view.layoutIfNeeded()
            
            self.popupView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        })
        transitionAnimator.addCompletion{ position in
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current: ()
            @unknown default:
                ()
            }
            switch self.currentState {
            case .open:
                self.bottomConstraint.constant = 0
                self.popupView.layer.cornerRadius = 20
            case .closed:
                self.bottomConstraint.constant = 440
                self.popupView.layer.cornerRadius = 0
            }
            // remove all running animators
            self.runningAnimators.removeAll()
            
        }
        transitionAnimator.startAnimation()
        
        let inTitleAnimator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeIn, animations: {
            switch state {
            case .open:
                self.openTitleLabel.alpha = 1
            case .closed:
                self.closedTitleLabel.alpha = 1
            }
        })
        
        inTitleAnimator.scrubsLinearly = false
        inTitleAnimator.startAnimation()
        
        let outTitleAnimator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeIn, animations: {
            switch state {
            case .open:
                self.openTitleLabel.alpha = 1
            case .closed:
                self.closedTitleLabel.alpha = 1
            }
        })
        outTitleAnimator.scrubsLinearly = false
        outTitleAnimator.startAnimation()
        
        runningAnimators.removeAll()
        runningAnimators.append(transitionAnimator)
        runningAnimators.append(inTitleAnimator)
        runningAnimators.append(outTitleAnimator)
    }
    
    @objc private func popupViewTapped(recognizer: UITapGestureRecognizer) {
        animateTransitionIfNeeded()
    }
    @objc private func placeholderPopupViewTapped(recognizer: UITapGestureRecognizer) {
        //
    }
    
    // MARK: - PAN Gesture
    @objc func panGestureRecognizer(gesture:UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            animateTransitionIfNeeded()
            runningAnimators.forEach { $0.pauseAnimation() }
            // keep track of each animator's progress
            animationProgress = runningAnimators.map { $0.fractionComplete }
            
        case .changed:
            let translation = gesture.translation(in: popupView)
            var fraction = -translation.y / popupOffset
            if currentState == .open { fraction *= -1 }
            if runningAnimators.first?.isReversed ?? false { fraction *= -1 }
            // apply the new fraction
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = fraction + animationProgress[index]
            }
        case .ended:
            // variable setup
            let yVelocity = gesture.velocity(in: popupView).y
            let shouldClose = yVelocity > 0
            
            // if there is no motion, continue all animations and exit early
            if yVelocity == 0 {
                runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
                break
            }
            
            // reverse the animations based on their current state and pan motion
            switch currentState {
            case .open:
                if !shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            case .closed:
                if shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if !shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            }
            // continue all animations
            runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
        default:
            ()
        }
    }
}
