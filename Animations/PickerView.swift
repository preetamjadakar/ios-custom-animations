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
    
    var delegate: PickerViewDelegate?
    class func instanceFromNib() -> PickerView {
        return UINib(nibName: "PickerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PickerView
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setPickerLabels()
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        self.isHidden = true
        delegate?.didSelect(min: timePicker.selectedRow(inComponent: 0), sec: timePicker.selectedRow(inComponent: 1))
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.isHidden = true
    }
    
    func setTimePicker(for min:Int, sec: Int) {
        timePicker.selectRow(min, inComponent: 0, animated: true)
        timePicker.selectRow(sec, inComponent: 1, animated: true)
    }
    
    
    func setPickerLabels() { // [component number:label]
        let minLabel = UILabel()
        
        minLabel.text = "min."
        let secLabel = UILabel()
        secLabel.text = "sec."
        
        let labels = [0:minLabel, 1:secLabel]
        let fontSize:CGFloat = 20
        let labelWidth:CGFloat = timePicker.bounds.width / CGFloat(timePicker.numberOfComponents)
        let x:CGFloat = timePicker.frame.origin.x
        let y:CGFloat = (timePicker.frame.size.height / 2) - (fontSize / 2)
        
        for i in 0...timePicker.numberOfComponents {
            
            if let label = labels[i] {
                
                if timePicker.subviews.contains(label) {
                    label.removeFromSuperview()
                }
                
                label.frame = CGRect(x: x + labelWidth * CGFloat(i) - 10, y: y, width: labelWidth, height: fontSize)
                label.font = UIFont.boldSystemFont(ofSize: fontSize)
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
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
}
