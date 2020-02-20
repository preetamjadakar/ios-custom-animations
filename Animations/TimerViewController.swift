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
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var timerView: TimerView!
    var isRunning: Bool = false
    var timerState: TimerState = .reset
    var timer: Timer?
    var timerValueInSeconds = 0 {
        didSet {
            if timerValueInSeconds == 0 {
                startPauseButton.isEnabled = false
                resetButton.isEnabled = false
            } else {
                startPauseButton.isEnabled = true
                resetButton.isEnabled = true
            }
        }
    }
    
    var pickerView: PickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        startPauseButton.isEnabled = false
        resetButton.isEnabled = false

        pickerView = PickerView.instanceFromNib()
        pickerView.center = view.center
        pickerView.delegate = self
        pickerView.isHidden = true
        view.addSubview(pickerView)
    }
    
    @IBAction func startOrPauseAnimationAction(_ sender: Any) {
        switch timerState {
        case .reset, .resumed, .paused:
            timerState = .running
            guard timerValueInSeconds > 0 else {
                return
            }
            startPauseButton.setTitle("Pause", for: .normal)
            
            timerView.startTimer(withValue: CGFloat(timerValueInSeconds))
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimerFire(timer:)), userInfo: nil, repeats: true)
            guard let mainLoopTimer = self.timer else { fatalError("Failed to create timer") }
            RunLoop.current.add(mainLoopTimer, forMode: RunLoop.Mode.common)
        case .running:
            timerState = .paused
            startPauseButton.setTitle("Resume", for: .normal)
            timerView.pauseTimer()
            isRunning = !isRunning
            stopCountDown()
        }
        /*  if isRunning {
         startPauseButton.setTitle("Resume", for: .normal)
         timerView.pauseTimer()
         isRunning = !isRunning
         stopCountDown()
         } else {
         isRunning = !isRunning
         guard timerValueInSeconds > 0 else {
         return
         }
         startPauseButton.setTitle("Pause", for: .normal)
         
         timerView.startTimer(withValue: timerValueInSeconds)
         self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimerFire(timer:)), userInfo: nil, repeats: true)
         guard let mainLoopTimer = self.timer else { fatalError("Failed to create timer") }
         RunLoop.current.add(mainLoopTimer, forMode: RunLoop.Mode.common)
         }
         */
    }
    
    @IBAction func resetTimerAction(_ sender: Any) {
        startPauseButton.setTitle("Start", for: .normal)
        
        isRunning = false
        timerState = .reset
        
        timerValueInSeconds = 0
        startPauseButton.isEnabled = false
        
        setTimerLabelValue(with: timerValueInSeconds / 60, sec: timerValueInSeconds % 60)
        
        stopCountDown()
        timerView.stopAnimation()
    }
    
    @objc private func onTimerFire(timer:Timer!) {
        timerValueInSeconds -= 1
        
        setTimerLabelValue(with: timerValueInSeconds / 60, sec: timerValueInSeconds % 60)
        
        if timerValueInSeconds <= 0 {
            resetTimerAction(resetButton as Any)
        }
    }
    
    private func stopCountDown() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @IBAction func timerValueLabelTapped(_ sender: Any) {
        guard timerState == .reset else {
            return
        }
        pickerView.isHidden = false
        guard let timeComponents = timerValueLabel.text?.components(separatedBy: " : ") else { return }
        pickerView.setTimePicker(for: Int(timeComponents[0]) ?? 0, sec: Int(timeComponents[1])  ?? 0)
    }
    
    private func setTimerLabelValue(with min:Int, sec:Int) {
        timerValueLabel.text = "\(String(format: "%02d", min)) : \(String(format: "%02d", sec))"
    }
}

extension TimerViewController: PickerViewDelegate {
    func didSelect(min: Int, sec: Int) {
        timerValueInSeconds = min * 60 + sec
        startPauseButton.isEnabled = timerValueInSeconds > 0
        setTimerLabelValue(with: min, sec: sec)
//        timerView.setHoursHand(with: sec)
        timerView.setHoursHand(with: CGFloat(timerValueInSeconds))
    }
}
