//
//  TimerView.swift
//  Animations
//
//  Created by admin on 19/02/20.
//  Copyright © 2020 Nihilent. All rights reserved.
//

import UIKit

enum TimerState {
    case reset, running, paused, resumed
}
class TimerView: UIView {
    var shapeLayer: CAShapeLayer!
    var progressiveShapeLayer: CAShapeLayer!

    var circlePath: UIBezierPath!
    
    var circleLayer: CALayer!
    var minutesHandLayer: CALayer!
    
    var secondsHandAnimation = CABasicAnimation(keyPath: "transform.rotation.z")

    var minutesHandAnimation = CABasicAnimation(keyPath: "transform.rotation.z")

    let progressiveStrokeAnimation = CABasicAnimation(keyPath: "strokeStart")

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // Drawing code
        // Take shorter of both sides
        if rect.size.width > rect.size.height {
            circlePath = UIBezierPath(arcCenter: CGPoint(x: rect.size.width / 2, y: rect.size.height / 2), radius: rect.size.height / 2 - 3, startAngle: CGFloat(Double.pi / 2), endAngle: -CGFloat(3/2 *  Double.pi), clockwise: false)
        } else {
            circlePath = UIBezierPath(arcCenter: CGPoint(x: rect.size.width / 2, y: rect.size.height / 2), radius: rect.size.width / 2 - 3, startAngle: CGFloat(Double.pi / 2), endAngle: -CGFloat(3/2 *  Double.pi), clockwise: false)
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
        minutesHandLayer = CALayer()
        minutesHandLayer.backgroundColor = UIColor.black.cgColor
        // Puts the center of the rectangle in the center of the clock
        minutesHandLayer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        // Positions the hand in the middle of the clock
        minutesHandLayer.position = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        
        // Set size of minutes hands
        if rect.size.width > rect.size.height {
            minutesHandLayer.bounds = CGRect(x: 0, y: 0, width: 8, height: (rect.size.height / 2) + 3.5 )
        } else {
            minutesHandLayer.bounds = CGRect(x: 0, y: 0, width: 8, height: (rect.size.width / 2) + 3.5)
        }
        
        //add progressive shape layer
        addProgressiveLayer()
        // Add hour hand layers to as sublayers
        circleLayer.addSublayer(minutesHandLayer)
        addTipLayer(rect: rect)
        self.layer.addSublayer(circleLayer)

        
        // Get current hours, minutes and seconds
        let date = Date()
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        
        // Calculate the angles for the each hand
        let hourAngle = CGFloat(hours * (360 / 12)) + CGFloat(0) * (1.0 / 60) * (360 / 12)
        let minuteAngle = CGFloat(minutes * (360 / 60))
        let secondsAngle = CGFloat(seconds * (360 / 60))
        
        minutesHandLayer.transform = CATransform3DMakeRotation(.pi, 0, 0, 1)
        
        
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
    
    func startTimer(withValue:CGFloat) {
        // Create animation for seconds hand
        // default repeat of  0
        //                secondsHandAnimation.repeatCount = 0
        // One animation (360deg) takes 60 seconds
        
        let minuteAngle = CGFloat(withValue/60 * (360 / 60))

        let fromValue = (minuteAngle + 180) * CGFloat(Double.pi / 180)
        let toValue =  (0 + 180) * CGFloat(Double.pi / 180)
        minutesHandAnimation.duration = CFTimeInterval(withValue)
        minutesHandAnimation.isRemovedOnCompletion = false
        minutesHandAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        // From start angle (according to calculated angle from time) plus 360deg which equals 1 rotation
        minutesHandAnimation.fromValue = fromValue
        minutesHandAnimation.toValue = toValue
        
        minutesHandAnimation.byValue = 2 * Double.pi
        //        secondsHandAnimation
        minutesHandLayer.add(minutesHandAnimation, forKey: minutesHandAnimation.keyPath)
        
        setProgressiveLayerPath(angle: minuteAngle)
        
        progressiveStrokeAnimation.fromValue = 0
        progressiveStrokeAnimation.toValue = 1

        progressiveStrokeAnimation.duration = CFTimeInterval(withValue)
        progressiveStrokeAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear) // animation curve is Ease Out
        progressiveStrokeAnimation.fillMode = CAMediaTimingFillMode.both // keep to value after finishing
        progressiveStrokeAnimation.isRemovedOnCompletion = false
        progressiveShapeLayer.add(progressiveStrokeAnimation, forKey: progressiveStrokeAnimation.keyPath)
        
    }
    
    func stopAnimation() {
        //        minutesHandLayer.removeAnimation(forKey: secondsHandAnimation.keyPath!)
        minutesHandLayer.removeAnimation(forKey: minutesHandAnimation.keyPath!)
        minutesHandLayer.transform = CATransform3DMakeRotation(.pi, 0, 0, 1)
        
        progressiveShapeLayer.path = nil
        progressiveShapeLayer.removeAnimation(forKey: progressiveStrokeAnimation.keyPath!)

    }
    
    func setHoursHand(with value: CGFloat) {
//        let fromAngle = (CGFloat(value * (360 / 60)) + 180) * CGFloat(Double.pi / 180)
        let fromAngle = (CGFloat(value/60 * (360 / 60)) + 180) * CGFloat(Double.pi / 180)
        minutesHandLayer.transform = CATransform3DMakeRotation(fromAngle, 0, 0, 1)
        
        let minuteAngle = CGFloat(value/60 * (360 / 60))

        setProgressiveLayerPath(angle: minuteAngle)
    }
    func pauseTimer() {
        minutesHandLayer.transform = minutesHandLayer.presentation()!.transform
//        minutesHandLayer.removeAnimation(forKey: secondsHandAnimation.keyPath!)
        minutesHandLayer.removeAnimation(forKey: minutesHandAnimation.keyPath!)
        progressiveShapeLayer.removeAnimation(forKey: progressiveStrokeAnimation.keyPath!)
    }
    
    func addTipLayer(rect: CGRect) {
        // Create and draw hour hand layer
        let tipLength = 20
        minutesHandLayer.layoutIfNeeded()
        let tipLayer = CALayer()
        tipLayer.backgroundColor = UIColor.red.cgColor
        tipLayer.cornerRadius = CGFloat(tipLength / 2)
        // Puts the center of the rectangle in the center of the clock
        tipLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        // Positions the hand in the middle of the clock
        tipLayer.position = CGPoint(x: 4, y: minutesHandLayer.bounds.height - CGFloat(tipLength / 2) + 4) // 8/2 = 4 is width of the circle line
            tipLayer.bounds = CGRect(x: 0, y: 0, width: tipLength, height: tipLength )
        minutesHandLayer.addSublayer(tipLayer)
    }
    func addProgressiveLayer() {
         progressiveShapeLayer = CAShapeLayer()
//               progressiveShapeLayer.path = circlePath.cgPath
               
               // Set fill color to clear
               progressiveShapeLayer.fillColor = UIColor.clear.cgColor
               // Set the border color to black
               progressiveShapeLayer.strokeColor = UIColor.green.cgColor
               // Set width of border
               progressiveShapeLayer.lineWidth = 8.0
               
        self.layer.addSublayer(progressiveShapeLayer)
    }
    
    func setProgressiveLayerPath(angle: CGFloat) {
        let progressiveStart = CGFloat((angle - 90) * .pi / 180)
        let progressivePath = UIBezierPath(arcCenter: CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2), radius: self.bounds.size.width / 2 - 3, startAngle: progressiveStart, endAngle: -CGFloat(Double.pi/2), clockwise: false)
        progressiveShapeLayer.path = progressivePath.cgPath

    }
}
