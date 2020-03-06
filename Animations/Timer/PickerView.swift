//
//  PickerView.swift
//  Animations
//
//  Created by admin on 20/02/20.
//  Copyright © 2020 Nihilent. All rights reserved.
//

import UIKit

protocol PickerViewDelegate {
    func didSelect(min: Int, sec:Int)
}
class PickerView: UIView {
    
    @IBOutlet weak var timePicker: UIPickerView!
    
    @IBOutlet weak var doneButton: PJButton!
    var delegate: PickerViewDelegate?
    var presentationPoint = CGPoint()
    class func instanceFromNib() -> PickerView {
        return UINib(nibName: "PickerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PickerView
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setPickerLabels()
        setupInitialScale()
    }
    
    func setupInitialScale() {
        transform = CGAffineTransform(scaleX: 0, y: 0)
        center = presentationPoint
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        animatePickerView(show: false)
        delegate?.didSelect(min: timePicker.selectedRow(inComponent: 0), sec: timePicker.selectedRow(inComponent: 1))
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        animatePickerView(show: false)
    }
    
    func setTimePicker(for min:Int, sec: Int) {
        doneButton.isEnabled = !(min == 0 && sec == 0)
        timePicker.selectRow(min, inComponent: 0, animated: true)
        timePicker.selectRow(sec, inComponent: 1, animated: true)
    }
    
    func animatePickerView(show: Bool) {
        if show {
            self.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {[weak self] in
                guard let selfObj = self else { return }
                selfObj.transform = .identity
                selfObj.center = selfObj.superview!.center
                }, completion: nil)
            
        } else {
            //hide
            UIView.animate(withDuration: 0.3, animations: {[weak self] in
                guard let selfObj = self else { return }
                selfObj.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                selfObj.center = selfObj.presentationPoint
                }, completion: {(finished) in
                    self.isHidden = true
            })
        }
    }
    
    func setPickerLabels() { // [component number:label]
        let minLabel = UILabel()
        
        minLabel.text = "min."
        let secLabel = UILabel()
        secLabel.text = "sec."
        
        let labels = [0:minLabel, 1:secLabel]
        let fontSize:CGFloat = 20
        let labelWidth:CGFloat = timePicker.bounds.width / CGFloat(timePicker.numberOfComponents)
        let x:CGFloat = timePicker.frame.origin.x + 4
        let y:CGFloat = (timePicker.frame.size.height / 2) - (fontSize / 2)
        
        for i in 0...timePicker.numberOfComponents {
            
            if let label = labels[i] {
                
                if timePicker.subviews.contains(label) {
                    label.removeFromSuperview()
                }
                
                label.frame = CGRect(x: x + labelWidth * CGFloat(i), y: y, width: labelWidth, height: fontSize)
                label.font = fontStyle1
                label.backgroundColor = .clear
                label.textAlignment = .right
                
                timePicker.addSubview(label)
            }
        }
    }
}


extension PickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        pickerLabel.text = "\(row)"
        pickerLabel.font = fontStyle3
        pickerLabel.textAlignment = .center
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let min = pickerView.selectedRow(inComponent: 0)
        let sec = pickerView.selectedRow(inComponent: 1)
        doneButton.isEnabled = !(min == 0 && sec == 0)
    }
}
