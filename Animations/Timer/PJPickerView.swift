//
//  PJPickerView.swift
//  Animations
//
//  Created by Preetam Jadakar on 23/02/20.
//  Copyright © 2020 preetamjadakar. All rights reserved.
//

import UIKit

protocol PJPickerViewDelegate {
    func didSelect(min: Int, sec:Int)
}

class PJPickerView: UIView {
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var timePicker: UIPickerView!
    
    @IBOutlet weak var doneButton: PJButton!
    var delegate: PJPickerViewDelegate?
    var presentationPoint = CGPoint()
    class func instanceFromNib() -> PJPickerView {
        return UINib(nibName: "PJPickerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PJPickerView
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setPickerLabels()
        setupInitialScale()
        pickerContainerView.layer.cornerRadius = 5
    }
    
    func setupInitialScale() {
        transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        center = presentationPoint
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        showPickerView(false)
        delegate?.didSelect(min: timePicker.selectedRow(inComponent: 0), sec: timePicker.selectedRow(inComponent: 1))
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        showPickerView(false)
    }
    
    func setTimePicker(for min:Int, sec: Int) {
        doneButton.isEnabled = !(min == 0 && sec == 0)
        timePicker.selectRow(min, inComponent: 0, animated: true)
        timePicker.selectRow(sec, inComponent: 1, animated: true)
    }
    
    func showPickerView(_ show: Bool) {
        if show {
            self.center = self.presentationPoint
            self.isHidden = false
            UIView.animate(withDuration: 0.3, animations: { [unowned self] in
                self.transform = .identity
                self.center = self.superview!.center
                }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.3, animations: {[unowned self] in
                self.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                self.center = self.presentationPoint
                }, completion: { [unowned self] (finished) in
                    self.isHidden = true
            })
        }
    }
    
    /// Adds "min." and "sec." titles just after respective components to indicate the values.
    func setPickerLabels() {
        let minLabel = UILabel()
        minLabel.text = NSLocalizedString("label_min", comment: "")
        let secLabel = UILabel()
        secLabel.text = NSLocalizedString("label_sec", comment: "")
        
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
                label.textColor = .white
                timePicker.addSubview(label)
            }
        }
    }
}


extension PJPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = .white
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
