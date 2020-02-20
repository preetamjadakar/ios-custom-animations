//
//  TimerViewController.swift
//  Animations
//
//  Created by admin on 19/02/20.
//  Copyright © 2020 Nihilent. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    @IBOutlet weak var timerValueLabel: UILabel!
    @IBOutlet weak var timerView: TimerView!
    var isRunning: Bool = false
    var timer: Timer?
    var timerValueInSeconds = 0
    
    var pickerView: PickerView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pickerView = PickerView.instanceFromNib()
        pickerView.center = view.center
        pickerView.delegate = self
        pickerView.isHidden = true
        view.addSubview(pickerView)
    }
    
    @IBAction func startOrPauseAnimationAction(_ sender: Any) {
        if isRunning {
            timerView.pauseTimer()
            isRunning = !isRunning
            timer?.invalidate()
        } else {
            isRunning = !isRunning
            guard timerValueInSeconds > 0 else {
                return
            }
            timerView.startTimer(withValue: timerValueInSeconds)
            
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimerFire(timer:)), userInfo: nil, repeats: true)
            guard let mainLoopTimer = self.timer else { fatalError("Failed to create timer") }
            RunLoop.current.add(mainLoopTimer, forMode: RunLoop.Mode.common)
        }
    }
    
    @IBAction func resetTimerAction(_ sender: Any) {
        timerValueInSeconds = 0
        timerValueLabel.text = "\(timerValueInSeconds/60) : \(timerValueInSeconds%60)"
        stopCountDown()
        timerView.stopAnimation()
    }
    
    @objc private func onTimerFire(timer:Timer!) {
        timerValueInSeconds -= 1
        timerValueLabel.text = "\(timerValueInSeconds/60) : \(timerValueInSeconds%60)"
        if timerValueInSeconds <= 0 {
            stopCountDown()
        }
    }
    private func stopCountDown() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @IBAction func timerValueLabelTapped(_ sender: Any) {
        pickerView.isHidden = false
        guard let timeComponents = timerValueLabel.text?.components(separatedBy: " : ") else { return }
        pickerView.setTimePicker(for: Int(timeComponents[0]) ?? 0, sec: Int(timeComponents[1])  ?? 0)
    }
}

extension TimerViewController: PickerViewDelegate {
    func didSelect(min: Int, sec: Int) {
        timerValueInSeconds = min * 60 + sec
        timerValueLabel.text = "\(min) : \(sec)"
    }
}
