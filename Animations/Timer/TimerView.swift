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

    var minutesHandAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    let progressiveStrokeAnimation = CABasicAnimation(keyPath: "strokeStart")

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // Drawing code
        // Take shorter of both sides
        if rect.size.width > rect.size.height {
            circlePath = UIBezierPath(arcCenter: CGPoint(x: rect.size.width / 2, y: rect.size.height / 2), radius: rect.size.height / 2 - 3, startAngle: CGFloat(Double.pi / 2), endAngle: -CGFloat(3/2 *  Double.pi), clockwise: false)
            //TODO: adjust radius as per width
        } else {
            circlePath = UIBezierPath(arcCenter: CGPoint(x: rect.size.width / 2, y: rect.size.height / 2), radius: rect.size.width / 2 - 3, startAngle: CGFloat(Double.pi / 2), endAngle: -CGFloat(3/2 *  Double.pi), clockwise: false)
        }
        
        shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        // Set fill color to clear
        shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        // Set the border color to black
        shapeLayer.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        // Set width of border
        shapeLayer.lineWidth = clockLineWidth
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
        let layerWidthFat: CGFloat = minutesHandLineWidth
        let midXFat = rect.midX - layerWidthFat / 2.0
        instanceLayerFat.frame = CGRect(x: midXFat, y: 0.0, width: layerWidthFat, height: 20)
        instanceLayerFat.backgroundColor = UIColor.black.cgColor
        replicatorLayerFat.addSublayer(instanceLayerFat)
        
        // Create and draw hour hand layer
        minutesHandLayer = CALayer()
        minutesHandLayer.backgroundColor = minutesHandColor.cgColor
        // Puts the center of the rectangle in the center of the clock
        minutesHandLayer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        // Positions the hand in the middle of the clock
        minutesHandLayer.position = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        
        // Set size of minutes hands
        if rect.size.width > rect.size.height {
            minutesHandLayer.bounds = CGRect(x: 0, y: 0, width: minutesHandLineWidth, height: (rect.size.height / 2) + 3.5 )
        } else {
            minutesHandLayer.bounds = CGRect(x: 0, y: 0, width: minutesHandLineWidth, height: (rect.size.width / 2) + 3.5)
        }
        
        //add progressive shape layer
        addProgressiveLayer()
        // Add hour hand layers to as sublayers
        circleLayer.addSublayer(minutesHandLayer)
        addTipLayer(rect: rect)
        self.layer.addSublayer(circleLayer)

        minutesHandLayer.transform = CATransform3DMakeRotation(.pi, 0, 0, 1)
    }
    
    func startTimer(withValue:CGFloat) {
        // Create animation for minutes hand
        let minuteAngle = CGFloat(withValue/60 * (360 / 60))

        let fromValue = (minuteAngle + 180) * CGFloat(Double.pi / 180)
        let toValue =  (0 + 180) * CGFloat(Double.pi / 180)
        minutesHandAnimation.duration = CFTimeInterval(withValue)
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
        progressiveShapeLayer.add(progressiveStrokeAnimation, forKey: progressiveStrokeAnimation.keyPath)
    }
    
    func stopAnimation() {
        minutesHandLayer.removeAnimation(forKey: minutesHandAnimation.keyPath!)
        minutesHandLayer.transform = CATransform3DMakeRotation(.pi, 0, 0, 1)
        
        progressiveShapeLayer.path = nil
        progressiveShapeLayer.removeAnimation(forKey: progressiveStrokeAnimation.keyPath!)
    }
    
    func setHoursHand(with value: CGFloat) {
        let fromAngle = (CGFloat(value/60 * (360 / 60)) + 180) * CGFloat(Double.pi / 180)
        minutesHandLayer.transform = CATransform3DMakeRotation(fromAngle, 0, 0, 1)
        
        let minuteAngle = CGFloat(value/60 * (360 / 60))

        setProgressiveLayerPath(angle: minuteAngle)
    }
    
    func pauseTimer() {
        minutesHandLayer.transform = minutesHandLayer.presentation()!.transform
        minutesHandLayer.removeAnimation(forKey: minutesHandAnimation.keyPath!)
        progressiveShapeLayer.removeAnimation(forKey: progressiveStrokeAnimation.keyPath!)
    }
    
    func addTipLayer(rect: CGRect) {
        // Create and draw hour hand layer
        let tipLength = 20
        minutesHandLayer.layoutIfNeeded()
        let tipLayer = CALayer()
        tipLayer.backgroundColor = minutesHandColor.cgColor
        tipLayer.cornerRadius = CGFloat(tipLength / 2)
        // Puts the center of the rectangle in the center of the clock
        tipLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        // Positions the hand in the middle of the clock
        tipLayer.position = CGPoint(x: minutesHandLineWidth/2, y: minutesHandLayer.bounds.height - CGFloat(tipLength / 2) + minutesHandLineWidth/2) // 8/2 = 4 is width of the circle line
            tipLayer.bounds = CGRect(x: 0, y: 0, width: tipLength, height: tipLength )
        minutesHandLayer.addSublayer(tipLayer)
    }
    
    func addProgressiveLayer() {
        progressiveShapeLayer = CAShapeLayer()
        // Set fill color to clear
        progressiveShapeLayer.fillColor = clearColor.cgColor
        // Set the border color to black
        progressiveShapeLayer.strokeColor = progressiveLayerColor.cgColor
        // Set width of border
        progressiveShapeLayer.lineWidth = clockLineWidth
        self.layer.addSublayer(progressiveShapeLayer)
    }
    
    func setProgressiveLayerPath(angle: CGFloat) {
        let progressiveStart = CGFloat((angle - 90) * .pi / 180)
        let progressivePath = UIBezierPath(arcCenter: CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2), radius: self.bounds.size.width / 2 - 3, startAngle: progressiveStart, endAngle: -CGFloat(Double.pi/2), clockwise: false)
        progressiveShapeLayer.path = progressivePath.cgPath
    }
}