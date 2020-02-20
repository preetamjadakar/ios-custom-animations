//
//  TimerView.swift
//  Animations
//
//  Created by admin on 19/02/20.
//  Copyright © 2020 Nihilent. All rights reserved.
//

import UIKit

class TimerView: UIView {
    var shapeLayer: CAShapeLayer!
    var circlePath: UIBezierPath!
    
    var circleLayer: CALayer!
    var hourHandLayer: CALayer!
    
    var secondsHandAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    
    let transitionAnimator = UIViewPropertyAnimator()
    override func draw(_ rect: CGRect) {
        // Drawing code
        // Take shorter of both sides
        if rect.size.width > rect.size.height {
            circlePath = UIBezierPath(arcCenter: CGPoint(x: rect.size.width / 2, y: rect.size.height / 2), radius: rect.size.height / 2, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        } else {
            circlePath = UIBezierPath(arcCenter: CGPoint(x: rect.size.width / 2, y: rect.size.height / 2), radius: rect.size.width / 2, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        }
        
        
        shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        // Set fill color to clear
        shapeLayer.fillColor = UIColor.clear.cgColor
        // Set the border color to black
        shapeLayer.strokeColor = UIColor.black.cgColor
        // Set width of border
        shapeLayer.lineWidth = 8.0
        
        self.layer.addSublayer(shapeLayer)
        
        // Instantiate circleLayer and put it into the main rect
        circleLayer = CALayer()
        circleLayer.frame = rect
        self.layer.addSublayer(circleLayer)
        
        // Create replicatorLayer to make a complete circle consisting of 12 parts
        let replicatorLayerFat = CAReplicatorLayer()
        
        // Offset to put both replicator layers into the vertical center
        let offsetY = (rect.size.height - rect.size.width) / 2
        
        if rect.size.width > rect.size.height {
            replicatorLayerFat.frame = rect
        } else {
            replicatorLayerFat.frame =  CGRect(x: rect.minX, y: offsetY, width: rect.width, height: rect.width)
        }
        
        
        replicatorLayerFat.instanceCount = 12
        
        // 12 instances (360deg / 12) -> angle for each part
        let angleFat = Float(Double.pi * 2.0) / 12
        
        // Add correct angle for each part to replicatorLayer
        replicatorLayerFat.instanceTransform = CATransform3DMakeRotation(CGFloat(angleFat), 0.0, 0.0, 1.0)
        self.layer.addSublayer(replicatorLayerFat)
        
        // Create layer that will be replicated 12 times to form a complete circle
        let instanceLayerFat = CALayer()
        let layerWidthFat: CGFloat = 6.0
        let midXFat = rect.midX - layerWidthFat / 2.0
        instanceLayerFat.frame = CGRect(x: midXFat, y: 0.0, width: layerWidthFat, height: 20)
        instanceLayerFat.backgroundColor = UIColor.black.cgColor
        replicatorLayerFat.addSublayer(instanceLayerFat)
        
        // Create and draw hour hand layer
        hourHandLayer = CALayer()
        hourHandLayer.backgroundColor = UIColor.black.cgColor
        // Puts the center of the rectangle in the center of the clock
        hourHandLayer.anchorPoint = CGPoint(x: 0.5, y: 0.2)
        // Positions the hand in the middle of the clock
        hourHandLayer.position = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        
        // Set size of all hands
        if rect.size.width > rect.size.height {
            hourHandLayer.bounds = CGRect(x: 0, y: 0, width: 8, height: (rect.size.height / 2) + 0.5 )
        } else {
            hourHandLayer.bounds = CGRect(x: 0, y: 0, width: 8, height: (rect.size.width / 2) + 0.5)
        }
        
        // Add hour hand layers to as sublayers
        circleLayer.addSublayer(hourHandLayer)
        
        
        // Get current hours, minutes and seconds
        let date = Date()
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        
        // Calculate the angles for the each hand
        let hourAngle = CGFloat(0 * (360 / 12)) + CGFloat(0) * (1.0 / 60) * (360 / 12)
        let minuteAngle = CGFloat(minutes * (360 / 60))
        let secondsAngle = CGFloat(seconds * (360 / 60))
        
        hourHandLayer.transform = CATransform3DMakeRotation(.pi, 0, 0, 1)
        
        
        // Transform the hands according to the calculated angles
        //               hourHandLayer.transform = CATransform3DMakeRotation(hourAngle / CGFloat(180 * Double.pi), 0, 0, 1)
        //               minuteHandLayer.transform = CATransform3DMakeRotation(minuteAngle / CGFloat(180 * Double.pi), 0, 0, 1)
        //               secondHandLayer.transform = CATransform3DMakeRotation(secondsAngle / CGFloat(180 * Double.pi), 0, 0, 1)
        
        
        
        //        // Create animation for minutes hand
        //        let minutesHandAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        //        // Runs forever
        //        minutesHandAnimation.repeatCount = Float.infinity
        //        // One animation (360deg) takes 60 minutes (1 hour)
        //        minutesHandAnimation.duration = 60 * 60
        //        minutesHandAnimation.isRemovedOnCompletion = false
        //        minutesHandAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        //        // From start angle (according to calculated angle from time) plus 360deg which equals 1 rotation
        //        minutesHandAnimation.fromValue = (minuteAngle + 180) * CGFloat(Double.pi / 180)
        //        minutesHandAnimation.byValue = 2 * Double.pi
        //        minuteHandLayer.add(minutesHandAnimation, forKey: "minutesHandAnimation")
        //
        //        // Create animation for hours hand
        //        let hoursHandAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        //        // Runs forever
        //        hoursHandAnimation.repeatCount = Float.infinity
        //        // One animation (360deg) takes 12 hours
        //        hoursHandAnimation.duration = CFTimeInterval(60 * 60 * 12);
        //        hoursHandAnimation.isRemovedOnCompletion = false
        //        hoursHandAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        //        // From start angle (according to calculated angle from time) plus 360deg which equals 1 rotation
        //        hoursHandAnimation.fromValue = (hourAngle + 180)  * CGFloat(Double.pi / 180)
        //        hoursHandAnimation.byValue = 2 * Double.pi
        //        hourHandLayer.add(hoursHandAnimation, forKey: "hoursHandAnimation")
    }
    
    func startTimer(withValue:Int) {
        // Create animation for seconds hand
        // default repeat of  0
        //                secondsHandAnimation.repeatCount = 0
        // One animation (360deg) takes 60 seconds
        
        
        secondsHandAnimation.duration = CFTimeInterval(withValue)
        secondsHandAnimation.isRemovedOnCompletion = false
        secondsHandAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        // From start angle (according to calculated angle from time) plus 360deg which equals 1 rotation
        secondsHandAnimation.fromValue = (CGFloat(withValue * (360 / 60)) + 180) * CGFloat(Double.pi / 180)
        secondsHandAnimation.toValue = (CGFloat(0 * (360 / 60)) + 180) * CGFloat(Double.pi / 180)
        
        secondsHandAnimation.byValue = 2 * Double.pi
        //        secondsHandAnimation
        hourHandLayer.add(secondsHandAnimation, forKey: secondsHandAnimation.keyPath)
    }
    
    func stopAnimation() {
        hourHandLayer.removeAnimation(forKey: secondsHandAnimation.keyPath!)
        hourHandLayer.transform = CATransform3DMakeRotation(.pi, 0, 0, 1)
    }
    
    func setHoursHand(with value: Int) {
        let fromAngle = (CGFloat(value * (360 / 60)) + 180) * CGFloat(Double.pi / 180)
        hourHandLayer.transform = CATransform3DMakeRotation(fromAngle, 0, 0, 1)
    }
    func pauseTimer() {
        hourHandLayer.transform = hourHandLayer.presentation()!.transform
        hourHandLayer.removeAnimation(forKey: secondsHandAnimation.keyPath!)
    }
}
