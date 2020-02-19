//
//  SecondsCountDownView.swift
//  NedBankApp
//
//  Created by Daniel Chroń on 04/07/2017.
//  Copyright © 2017 NedBank. All rights reserved.
//

import UIKit

@IBDesignable
class SecondsCountDownView: UIView {
    
    @IBInspectable var strokeColor: UIColor = .red {
        didSet {
            self.progressLayer.strokeColor = strokeColor.cgColor
        }
    }
    
    @IBInspectable var fillColor: UIColor = .clear {
        didSet {
            self.fillLayer.strokeColor = fillColor.cgColor
        }
    }
    
    @IBInspectable var lineWidth : CGFloat = 1 {
        didSet {
            self.progressLayer.lineWidth = lineWidth
            self.fillLayer.lineWidth = lineWidth
        }
    }
    
    @IBInspectable var fontSize : CGFloat = 28 {
        didSet {
            textLabel.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
    
    @IBInspectable var fontColor: UIColor = .black {
        didSet {
            textLabel.textColor = fontColor
        }
    }
    
    @IBInspectable var totalSeconds : Int = 60
    @IBInspectable var updateAnimationTime : Int = 1
    
    var progress : Int = 0 {
        didSet {
            textLabel.text = remainingTimeString
            updateAnimation()
        }
    }
    
    var remainingTime : Int { return abs(totalSeconds - progress) }
    var progressString : String { return "\(progress)"}
    var remainingTimeString : String { return "\(remainingTime)"}
    
    var textLabel = UILabel()
    var progressLayer = CAShapeLayer()
    var fillLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Setup methods
    func setupView() {
        
        let centerPoint = CGPoint (x: bounds.midX, y: bounds.midY)
        let circleRadius : CGFloat = bounds.width / 2 * 0.85
        
        let circlePath = UIBezierPath(arcCenter:CGPoint(x:200, y:200), radius:100, startAngle:-.pi/2, endAngle:1.5 * .pi, clockwise:true)
        
//        fillLayer.path = circlePath.cgPath
//        fillLayer.strokeColor = fillColor.cgColor
//        fillLayer.fillColor = UIColor.clear.cgColor
//        fillLayer.lineWidth = lineWidth
//
//        fillLayer.strokeStart = 0
//        fillLayer.strokeEnd = 0
//
//        layer.addSublayer(fillLayer)
        
        progressLayer.path = circlePath.cgPath
        progressLayer.strokeColor = strokeColor.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = lineWidth
        
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = 0
        
        layer.addSublayer(progressLayer)
        
        setupLabel()
    }
    
    func setupLabel() {
        textLabel.font = UIFont.systemFont(ofSize: fontSize)
        textLabel.textColor = fontColor
        textLabel.text = remainingTimeString
        
        addSubview(textLabel)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    // MARK: - Animations
    func updateAnimation() {
//        progressLayer.strokeEnd = 0
//        let animation = CABasicAnimation(keyPath: "strokeStart")
////        animation.fromValue = 1 - Double(progress) / Double(totalSeconds)
////        animation.toValue = 1 - Double(progress + 1) / Double(totalSeconds)
//        animation.fromValue = 0
//        animation.toValue = CGFloat(progress)/60
//        animation.duration = 5
//        animation.repeatCount = .infinity
//        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear) // animation curve is Ease Out
////        animation.fillMode = CAMediaTimingFillMode.forwards // keep to value after finishing
////        animation.isRemovedOnCompletion = false
//        progressLayer.strokeEnd = CGFloat(progress)/60
//        progressLayer.add(animation, forKey: animation.keyPath)
        
//        let path = UIBezierPath()
//        path.move(to: CGPoint(x: 10, y: 130))
//        path.addCurve(to: CGPoint(x: 210, y: 200), controlPoint1: CGPoint(x: 50, y: -100), controlPoint2: CGPoint(x: 100, y: 350))
//        let path = UIBezierPath(arcCenter:CGPoint(x:200, y:200), radius:50, startAngle:-.pi/2, endAngle:1.5 * .pi, clockwise:true)
////        let path = UIBezierPath.init(ovalIn: CGRect.init(x: 0, y: 0, width: 200, height: 200))
//// let path = UIBezierPath.init(roundedRect: CGRect(x: 0,y: 0,width: 200,height: 200), cornerRadius: 10)
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
//        shapeLayer.strokeColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1).cgColor
//        shapeLayer.lineWidth = 5
//        shapeLayer.path = path.cgPath
//        shapeLayer.strokeStart = 0.8
//        layer.addSublayer(shapeLayer)
//        let startAnimation = CABasicAnimation(keyPath: "strokeStart")
//        startAnimation.fromValue = 0
//        startAnimation.toValue = 1
//        startAnimation.duration = 2
//
//        let endAnimation = CABasicAnimation(keyPath: "strokeEnd")
//        endAnimation.fromValue = 0
//        endAnimation.toValue = 1.0
//        endAnimation.duration = 1.5
//        let widthAnimation = CABasicAnimation(keyPath: "lineWidth")
//        widthAnimation.fromValue = 0
//        widthAnimation.toValue = 5
//        widthAnimation.duration = 1.5
//
//        let animation = CAAnimationGroup()
//        animation.animations = [startAnimation, endAnimation, widthAnimation]
//        animation.duration = 2
//        animation.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
//        animation.repeatDuration = .infinity
//        shapeLayer.add(animation, forKey: "MyAnimation")
        
        layoutIfNeeded()
//        let path = UIBezierPath(arcCenter: CGPoint(x:bounds.midX,y:bounds.midY), radius: 20, startAngle: -.pi/2, endAngle: 3 * .pi/2, clockwise: true)
        let path = UIBezierPath(roundedRect:CGRect(x:0, y:0, width:frame.width, height:frame.height), cornerRadius:30)
        let shapeLayer = CAShapeLayer()
        self.layer.maskedCorners = [.layerMaxXMaxYCorner]
        self.layer.cornerRadius = 30
        shapeLayer.lineWidth = 3
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = 1
        shapeLayer.path = path.cgPath
        shapeLayer.backgroundColor = UIColor.yellow.cgColor
        self.layer.addSublayer(shapeLayer)
        self.backgroundColor = .green
        
        let endStrokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
//        endStrokeAnimation.repeatCount = .infinity
        endStrokeAnimation.fromValue = 0
        endStrokeAnimation.toValue = 1
        endStrokeAnimation.duration = 1

//        shapeLayer.add(endStrokeAnimation, forKey: endStrokeAnimation.keyPath)
        
        let startStrokeAnimation = CABasicAnimation(keyPath:"strokeStart")
        startStrokeAnimation.fromValue = 0
        startStrokeAnimation.toValue = 1
        startStrokeAnimation.duration = 2
        
        let lineWidthAnimation = CABasicAnimation(keyPath:"lineWidth")
        lineWidthAnimation.fromValue = 1
        lineWidthAnimation.toValue = 3
        lineWidthAnimation.duration = 2
        
//        startStrokeAnimation.repeatCount = .infinity
        
        let totalAnimations = CAAnimationGroup()
        totalAnimations.animations = [ startStrokeAnimation,lineWidthAnimation,endStrokeAnimation]
        totalAnimations.duration = 2
        totalAnimations.repeatCount = .infinity
        totalAnimations.timingFunction = CAMediaTimingFunction(name:.easeInEaseOut)

        shapeLayer.add(totalAnimations, forKey:"somePath")
    }
    
}
