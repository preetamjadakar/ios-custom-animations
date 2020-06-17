//
//  TimerViewController.swift
//  CountdownTimer
//
//  Created by admin on 23/02/20.
//  Copyright © 2020 preetamjadakar. All rights reserved.
//

import UIKit
import UserNotifications
import AVFoundation


class TimerViewController: UIViewController {
    
    @IBOutlet weak var timerValueLabel: UILabel!
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var timerView: PJTimerView!
    
    var pickerView: PJPickerView!
    var gradientLayer: CAGradientLayer!
    
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
    
    var triggerTime:TimeInterval?
    var timerDuration:TimeInterval?
    
    var player: AVAudioPlayer?
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startPauseButton.isEnabled = false
        resetButton.isEnabled = false
        addPickerView()
        createGradientLayer()
        addApplicationStateChangeObservers()
        
        localNotificationSetup()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didFinishLaunchingNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    fileprivate func addPickerView() {
        pickerView = PJPickerView.instanceFromNib()
        pickerView.delegate = self
        pickerView.isHidden = true
        view.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: view.topAnchor),
            pickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pickerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            pickerView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    fileprivate func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.2109377086, green: 0.6190578938, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 0.2120122313, green: 0.08042155951, blue: 0.4985589981, alpha: 1).cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    fileprivate func localNotificationSetup() {
        //request for local notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: { (granted, error) in
            if !granted {
                print("TODO: You need to enable local notifications to get better notified about timer completions.")
            }
        })
        // set delegate to show local notification in forground state
        UNUserNotificationCenter.current().delegate = self
    }
    
    /// Adds application state observers
    fileprivate func addApplicationStateChangeObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationLaunched), name: UIApplication.didFinishLaunchingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pickerView.presentationPoint = timerValueLabel.superview!.convert(timerValueLabel.center, to: view)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        gradientLayer.frame = CGRect(origin: .zero, size: size)
    }
    
    // MARK: - Application State handling methods
    @objc func applicationLaunched() {
        checkAndRescheduleOngoingTimer()
    }
    
    @objc func applicationMovedToBackground() {
        saveTimerMetadata()
    }
    
    @objc func applicationMovedToForeground() {
        checkAndRescheduleOngoingTimer()
    }
    
    /// Saves Timer related metadata from user defaults
    func saveTimerMetadata() {
        // if timer is running or paused, then only save timer data
        switch timerState {
        case .paused:
            UserDefaults.standard.set(timerState.rawValue, forKey: timerStateKey)
            UserDefaults.standard.set(timerValueInSeconds, forKey: timerPauseTimeKey)
        case .running:
            UserDefaults.standard.set(timerState.rawValue, forKey: timerStateKey)
            UserDefaults.standard.set(triggerTime, forKey: triggerTimeKey)
            UserDefaults.standard.set(timerDuration, forKey: timerDurationKey)
        case .reset: break
        }
    }
    
    /// Clears Timer related metadata from user defaults
    fileprivate func clearTimerMetadata() {
        UserDefaults.standard.set(nil, forKey: triggerTimeKey)
        UserDefaults.standard.set(nil, forKey: timerDurationKey)
        UserDefaults.standard.set(nil, forKey: timerStateKey)
        UserDefaults.standard.set(nil, forKey: timerPauseTimeKey)
    }
    
    /// If timer duration is still yet to complete then set the timer again
    fileprivate func checkAndRescheduleOngoingTimer() {
        guard let timerLastStateRawValue = UserDefaults.standard.value(forKey: timerStateKey) as? String, let timerLastState = TimerState(rawValue: timerLastStateRawValue) else {
            return
        }
        
        switch timerLastState {
        //if last state is .reset, no need to proccess further
        case .reset: break
        case .paused:
            timerState = timerLastState
            if let timerPauseTime = UserDefaults.standard.value(forKey: timerPauseTimeKey) as? Int {
                timerValueInSeconds = timerPauseTime
                startPauseButton.setTitle(NSLocalizedString("buttonTitle_resume", comment: ""), for: .normal)
                timerValueLabel.backgroundColor = clearColor
                setTimerLabelValue(with: timerValueInSeconds / 60, sec: timerValueInSeconds % 60)
                timerView.setMinuteHand(with: CGFloat(timerValueInSeconds))
            }
        case .running:
            guard let triggerTime = UserDefaults.standard.value(forKey: triggerTimeKey) as? TimeInterval, let timerDuration = UserDefaults.standard.value(forKey: timerDurationKey) as? TimeInterval  else {
                return
            }
            let difference = Date().timeIntervalSince1970 - triggerTime
            guard difference < timerDuration else {
                clearTimerMetadata()
                resetTimer()
                return
            }
            //setup timer UI, as per remaining timer value
            let timeRemaining = Int(timerDuration - difference)
            resetTimer()
            timerValueInSeconds = timeRemaining
            startOrPauseAnimationAction(startPauseButton as Any)
        }
    }
    
    // MARK: - IBAction methods
    @IBAction func timerValueLabelTapped(_ sender: Any) {
        // timer label is clickable only during '.reset' state, once the timer is started
        //user should not change time unless he resets or timer is completed
        guard timerState == .reset else { return }
        pickerView.showPickerView(true)
        
        guard let timeComponents = timerValueLabel.text?.components(separatedBy: ":") else { return }
        pickerView.setTimePicker(for: Int(timeComponents[0]) ?? 0, sec: Int(timeComponents[1])  ?? 0)
    }
    
    @IBAction func startOrPauseAnimationAction(_ sender: Any) {
        timerValueLabel.backgroundColor = clearColor
        switch timerState {
        case .reset, .paused:
            // start timer only when valid time duration is selected
            guard timerValueInSeconds > 0 else { return }
            
            timerState = .running
            
            triggerTime = Date().timeIntervalSince1970
            timerDuration = TimeInterval(timerValueInSeconds)
            setTimerLabelValue(with: timerValueInSeconds / 60, sec: timerValueInSeconds % 60)
            startPauseButton.setTitle(NSLocalizedString("buttonTitle_pause", comment: ""), for: .normal)
            
            timerView.startTimer(withValue: CGFloat(timerValueInSeconds))
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimerFire(timer:)), userInfo: nil, repeats: true)
            guard let mainLoopTimer = timer else { fatalError("Failed to create timer") }
            RunLoop.current.add(mainLoopTimer, forMode: RunLoop.Mode.common)
            //schedule local notification
            scheduleLocalNotification()
        case .running:
            timerState = .paused
            startPauseButton.setTitle(NSLocalizedString("buttonTitle_resume", comment: ""), for: .normal)
            timerView.pauseTimer()
            stopCountDown()
            //cancel existing local notifications
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }
    
    @IBAction func resetTimerAction(_ sender: Any) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        resetTimer()
    }
    
    @objc private func onTimerFire(timer:Timer!) {
        timerValueInSeconds -= 1
        setTimerLabelValue(with: timerValueInSeconds / 60, sec: timerValueInSeconds % 60)
        if timerValueInSeconds <= 0 {
            resetTimer()
            //Play sound if notifications are not authorised
            UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { settings in
                switch settings.authorizationStatus {
                case .notDetermined, .denied:
                    self.playTimerCompletionTone()
                case .authorized, .provisional: break
                @unknown default: break
                }
            })
        }
    }
    
    /// stops the ongoing timer
    private func stopCountDown() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    /// Resets the current ongoing timer to default state. 00:00 time
    private func resetTimer() {
        timerState = .reset
        timerValueLabel.backgroundColor = #colorLiteral(red: 0, green: 0.4793453217, blue: 0.9990863204, alpha: 1)
        startPauseButton.setTitle(NSLocalizedString("buttonTitle_start", comment: ""), for: .normal)
        timerValueInSeconds = 0
        setTimerLabelValue(with: 0, sec: 0)
        stopCountDown()
        timerView.stopAnimation()
        clearTimerMetadata()
    }
    
    private func setTimerLabelValue(with min:Int, sec:Int) {
        timerValueLabel.text = "\(String(format: "%02d", min)):\(String(format: "%02d", sec))"
    }
    
    /// Schedules local notification for timer completion
    func scheduleLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("label_timer_completed", comment: "")
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "egg_timer_tone.caf"))
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timerValueInSeconds), repeats: false)
        
        let request = UNNotificationRequest(identifier: localNotificationId, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func playTimerCompletionTone() {
        guard let url = Bundle.main.url(forResource: "egg_timer_tone", withExtension: "caf") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.caf.rawValue)
            guard let player = player else { return }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

// MARK: - PickerViewDelegate
extension TimerViewController: PJPickerViewDelegate {
    func didSelect(min: Int, sec: Int) {
        timerValueInSeconds = min * 60 + sec
        setTimerLabelValue(with: min, sec: sec)
        timerView.setMinuteHand(with: CGFloat(timerValueInSeconds))
    }
}

// MARK: - UNUserNotificationCenterDelegate method
extension TimerViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
}
