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
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        //        let minLabel = UILabel()
        //        minLabel.text = "min."
        //        let secLabel = UILabel()
        //        secLabel.text = "sec."
        //        timePicker.setPickerLabels(labels: [0 : minLabel, 1: secLabel], containedView: self)
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

extension UIPickerView {
    
    func setPickerLabels(labels: [Int:UILabel], containedView: UIView) { // [component number:label]
        
        let fontSize:CGFloat = 20
        let labelWidth:CGFloat = containedView.bounds.width / CGFloat(self.numberOfComponents)
        let x:CGFloat = self.frame.origin.x
        let y:CGFloat = (self.frame.size.height / 2) - (fontSize / 2)
        
        for i in 0...self.numberOfComponents {
            
            if let label = labels[i] {
                
                if self.subviews.contains(label) {
                    label.removeFromSuperview()
                }
                
                label.frame = CGRect(x: x + labelWidth * CGFloat(i), y: y, width: labelWidth, height: fontSize)
                label.font = UIFont.boldSystemFont(ofSize: fontSize)
                label.backgroundColor = .clear
                label.textAlignment = NSTextAlignment.center
                
                self.addSubview(label)
            }
        }
    }
}
