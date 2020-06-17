//
//  PJTimerView.swift
//  Animations
//
//  Created by admin on 23/02/20.
//  Copyright © 2020 preetamjadakar. All rights reserved.
//

import UIKit

enum TimerState:String {
    case reset, running, paused
}

@IBDesignable
class PJTimerView: UIView {
    // MARK: - Properties
    var circlePath: UIBezierPath!

    var shapeLayer: CAShapeLayer!
    var replicatorLayer: CAReplicatorLayer!
    var instanceLayer: CALayer!
    
    var progressivePath: UIBezierPath!
    var progressiveShapeLayer: CAShapeLayer!
    
    var minuteHandLayer: CALayer!
    var tipLayer:CALayer!

    var minuteHandAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    let progressiveStrokeAnimation = CABasicAnimation(keyPath: "strokeEnd")

    var timerDuration = CGFloat()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    // MARK: - Drawing
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        // Take shorter of both sides
        if rect.size.width > rect.size.height {
            circlePath = UIBezierPath(arcCenter: CGPoint(x: rect.size.width / 2, y: rect.size.height / 2), radius: rect.size.height / 2 - clockRectMargin, startAngle: -(.pi / 2), endAngle: (3/2 * .pi), clockwise: true)
        } else {
            circlePath = UIBezierPath(arcCenter: CGPoint(x: rect.size.width / 2, y: rect.size.height / 2), radius: rect.size.width / 2 - clockRectMargin, startAngle: -(.pi / 2), endAngle: (3/2 * .pi), clockwise: true)
        }
        
        shapeLayer.path = circlePath.cgPath
        
        //Draw replicator layer
        // Offset to put both replicator layers into the vertical center
        let offsetY = (rect.size.height - rect.size.width) / 2
        
        if rect.size.width > rect.size.height {
            replicatorLayer.frame = rect
        } else {
            replicatorLayer.frame =  CGRect(x: rect.minX, y: offsetY, width: rect.width, height: rect.width)
        }
        // replicator
        let layerWidthFat: CGFloat = replicatorLineWidth
        let midXFat = rect.midX - layerWidthFat / 2.0
        instanceLayer.frame = CGRect(x: midXFat, y: 0.0, width: layerWidthFat, height: 20)

        // Draw minute hand layer
        // Positions the minute hand in the middle of the clock
        minuteHandLayer.position = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        
        // Set size of minute hands
        if rect.size.width > rect.size.height {
            minuteHandLayer.bounds = CGRect(x: 0, y: 0, width: minuteHandLineWidth, height: (rect.size.height / 2) + clockRectMargin)
        } else {
            minuteHandLayer.bounds = CGRect(x: 0, y: 0, width: minuteHandLineWidth, height: (rect.size.width / 2) + clockRectMargin)
        }
        
        // Positions the tip at the end of minute hand
        tipLayer.position = CGPoint(x: minuteHandLineWidth/2, y: minuteHandLayer.bounds.height - CGFloat(minuteHandRoundedTipLength / 2) + clockLineWidth/2)
        // set bounds for the tip
        tipLayer.bounds = CGRect(x: 0, y: 0, width: minuteHandRoundedTipLength, height: minuteHandRoundedTipLength )

        //set the minute hand as per timer duration
        setMinuteHand(with: timerDuration)
    }
    
    private func configure() {
            // Setup the shapeLayer to make a complete circle depicting clock outline
            configureClockCircle()
    
            // Setup the replicatorLayer to make a complete circle consisting of 12 parts
            configureHoursReplicatorLayer()
    
            // Setup the progressiveShapeLayer to indicate progress
            configureProgressiveLayer()
    
            // Setup minute hand
            configureMinuteHandLayer()
    }
    
    fileprivate func configureClockCircle() {
        shapeLayer = CAShapeLayer()
        // Set fill color to clear
        shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        // Set the border color to black
        shapeLayer.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        // Set width of border
        shapeLayer.lineWidth = clockLineWidth
        
        layer.addSublayer(shapeLayer)
    }
    
    fileprivate func configureHoursReplicatorLayer() {
        replicatorLayer = CAReplicatorLayer()
        replicatorLayer.instanceCount = 12
        
        // 12 instances (360deg / 12) -> angle for each part
        let angleFat = Float(.pi * 2.0) / 12
        
        // Add correct angle for each part to replicatorLayer
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(CGFloat(angleFat), 0.0, 0.0, 1.0)
        layer.addSublayer(replicatorLayer)
        
        // Create layer that will be replicated 12 times to form a complete circle
        instanceLayer = CALayer()
        instanceLayer.backgroundColor = UIColor.black.cgColor
        replicatorLayer.addSublayer(instanceLayer)
    }
    
    fileprivate func configureProgressiveLayer() {
        progressiveShapeLayer = CAShapeLayer()
        // Set fill color to clear
        progressiveShapeLayer.fillColor = clearColor.cgColor
        progressiveShapeLayer.strokeColor = progressiveLayerColor.cgColor
        // Set width of progress layer same as clock layer
        progressiveShapeLayer.lineWidth = clockLineWidth
        layer.addSublayer(progressiveShapeLayer)
    }

    fileprivate func configureMinuteHandLayer() {
        // Add hour hand layer to as sublayers
        minuteHandLayer = CALayer()
        minuteHandLayer.backgroundColor = minuteHandColor.cgColor
        // Puts the center of the rectangle in the center of the clock
        minuteHandLayer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        
        // Draw rounded tip for a minute hand
        minuteHandLayer.layoutIfNeeded()
        tipLayer = CALayer()
        tipLayer.backgroundColor = minuteHandColor.cgColor
        tipLayer.cornerRadius = CGFloat(minuteHandRoundedTipLength / 2)
        // Puts the center of the tip in the center of minute hand
        tipLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        minuteHandLayer.addSublayer(tipLayer)
        layer.addSublayer(minuteHandLayer)
        
        //set original/initial position at 12 o'clock
        minuteHandLayer.transform = CATransform3DMakeRotation(.pi, 0, 0, 1)
    }
    
    func startTimer(withValue:CGFloat) {
        timerDuration = withValue
        // Create animation for minute hand
        // From start angle (according to calculated angle from time) by converting seconds into minute
        let minuteAngle = CGFloat(withValue/60 * (360 / 60))
        
        // minute hand starts from top(current time angle + 180deg), convert to radians
        let fromValue = (minuteAngle + 180) * (.pi / 180)
        // minute hand starts from top(ZERO seconds angle + 180deg), convert to radians
        let toValue =  (0 + 180) * CGFloat(Double.pi / 180)
        
        //animation duration will be timer value in seconds
        minuteHandAnimation.duration = CFTimeInterval(withValue)
        //timing function must be linear
        minuteHandAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        minuteHandAnimation.fromValue = fromValue
        minuteHandAnimation.toValue = toValue
        
        minuteHandAnimation.byValue = CGFloat(2 * Double.pi)
        minuteHandLayer.add(minuteHandAnimation, forKey: minuteHandAnimation.keyPath)
        
        setProgressiveLayerPath(angle: minuteAngle)
        
        progressiveStrokeAnimation.fromValue = 1
        progressiveStrokeAnimation.toValue = 0
        
        progressiveStrokeAnimation.duration = CFTimeInterval(withValue)
        progressiveStrokeAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        progressiveShapeLayer.add(progressiveStrokeAnimation, forKey: progressiveStrokeAnimation.keyPath)
    }
    
    func stopAnimation() {
        minuteHandLayer.removeAnimation(forKey: minuteHandAnimation.keyPath!)
        minuteHandLayer.transform = CATransform3DMakeRotation(.pi, 0, 0, 1)
        
        progressiveShapeLayer.path = nil
        progressiveShapeLayer.removeAnimation(forKey: progressiveStrokeAnimation.keyPath!)
    }
    
    func setMinuteHand(with value: CGFloat) {
        timerDuration = value
        let fromAngle = (CGFloat(value/60 * (360 / 60)) + 180) * CGFloat(Double.pi / 180)
        minuteHandLayer.transform = CATransform3DMakeRotation(fromAngle, 0, 0, 1)
        
        let minuteAngle = CGFloat(value/60 * (360 / 60))
        setProgressiveLayerPath(angle: minuteAngle)
    }
    
    func setProgressiveLayerPath(angle: CGFloat) {
        // Bezier path starts at 15 minute, to start from 0 minute, minus 90deg and convert to radians
        self.layoutIfNeeded()
        let progressiveEndAngle = (angle - 90) * (.pi / 180)
        // Take shorter of both sides
        if bounds.size.width > bounds.size.height {
             progressivePath = UIBezierPath(arcCenter: CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2), radius: bounds.size.height / 2 - clockRectMargin, startAngle: -(.pi/2), endAngle: progressiveEndAngle, clockwise: true)
        } else {
             progressivePath = UIBezierPath(arcCenter: CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2), radius: bounds.size.width / 2 - clockRectMargin, startAngle: -(.pi/2), endAngle: progressiveEndAngle, clockwise: true)
        }
        progressiveShapeLayer.path = progressivePath.cgPath
    }
    
    func pauseTimer() {
        //set current transform and remove animation
        minuteHandLayer.transform = minuteHandLayer.presentation()!.transform
        minuteHandLayer.removeAnimation(forKey: minuteHandAnimation.keyPath!)
        //remove animation
        progressiveShapeLayer.removeAnimation(forKey: progressiveStrokeAnimation.keyPath!)
    }
}
