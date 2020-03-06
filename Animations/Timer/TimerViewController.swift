//
//  TimerViewController.swift
//  Animations
//
//  Created by admin on 19/02/20.
//  Copyright © 2020 Nihilent. All rights reserved.
//

import UIKit
import UserNotifications

class TimerViewController: UIViewController, UNUserNotificationCenterDelegate {
    
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
    var gradientLayer: CAGradientLayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        startPauseButton.isEnabled = false
        resetButton.isEnabled = false

        pickerView = PickerView.instanceFromNib()
        pickerView.presentationPoint = timerValueLabel.center
        pickerView.delegate = self
        pickerView.isHidden = true
        view.addSubview(pickerView)
        
        //request for local notification

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {
            (granted, error) in
            if granted {
                print("yes")
            } else {
                print("No")
            }
        }
        UNUserNotificationCenter.current().delegate = self
        createGradientLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        createGradientLayer()
    }
    @IBAction func startOrPauseAnimationAction(_ sender: Any) {
        switch timerState {
        case .reset, .resumed, .paused:
            timerState = .running
            guard timerValueInSeconds > 0 else {
                return
            }
            startPauseButton.setTitle("Pause", for: .normal)
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

            timerView.startTimer(withValue: CGFloat(timerValueInSeconds))
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimerFire(timer:)), userInfo: nil, repeats: true)
            guard let mainLoopTimer = self.timer else { fatalError("Failed to create timer") }
            RunLoop.current.add(mainLoopTimer, forMode: RunLoop.Mode.common)
            //trigger timer
            triggerLocalNotification()
        case .running:
            timerState = .paused
            startPauseButton.setTitle("Resume", for: .normal)
            timerView.pauseTimer()
            isRunning = !isRunning
            stopCountDown()
                //cancel existing local notifications
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }
    
    @objc private func onTimerFire(timer:Timer!) {
        timerValueInSeconds -= 1
        
        setTimerLabelValue(with: timerValueInSeconds / 60, sec: timerValueInSeconds % 60)
        
        if timerValueInSeconds <= 0 {
            resetTimer()
        }
    }
    
    @IBAction func resetTimerAction(_ sender: Any) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        resetTimer()
    }
    
    private func stopCountDown() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    private func resetTimer() {
        startPauseButton.setTitle("Start", for: .normal)
        
        isRunning = false
        timerState = .reset
        
        timerValueInSeconds = 0
        startPauseButton.isEnabled = false
        
        setTimerLabelValue(with: timerValueInSeconds / 60, sec: timerValueInSeconds % 60)
        
        stopCountDown()
        timerView.stopAnimation()
    }
    
    @IBAction func timerValueLabelTapped(_ sender: Any) {
        guard timerState == .reset else {
            return
        }
        pickerView.animatePickerView(show: true)

        guard let timeComponents = timerValueLabel.text?.components(separatedBy: ":") else { return }
        pickerView.setTimePicker(for: Int(timeComponents[0]) ?? 0, sec: Int(timeComponents[1])  ?? 0)
    }
    
    private func setTimerLabelValue(with min:Int, sec:Int) {
        timerValueLabel.text = "\(String(format: "%02d", min)):\(String(format: "%02d", sec))"
    }

    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
     
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.2109377086, green: 0.6190578938, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 0.2120122313, green: 0.08042155951, blue: 0.4985589981, alpha: 1).cgColor]
     
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func triggerLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Timer expired!"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "egg_timer_alarm.caf"))
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timerValueInSeconds), repeats: false)
        
        let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.alert, .sound])
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
