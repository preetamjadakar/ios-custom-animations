//
//  Constants.swift
//  Animations
//
//  Created by admin on 23/02/20.
//  Copyright © 2020 preetamjadakar. All rights reserved.
//

import UIKit

let triggerTimeKey = "triggerTime"
let timerDurationKey = "timerDuration"
let timerPauseTimeKey = "timerPauseTime"
let timerStateKey = "timerState"

let fontStyle1 = UIFont.init(name: "RobotoMono-Light", size: 25)
let fontStyle2 = UIFont.init(name: "RobotoMono-Regular", size: 15)
let fontStyle3 = UIFont.init(name: "RobotoMono-Regular", size: 25)

let isIPAD = UIDevice.current.userInterfaceIdiom == .pad

let clockRectMargin:CGFloat = 3.0
let clockLineWidth:CGFloat = isIPAD ? 15.0 : 10.0
let minuteHandLineWidth:CGFloat = isIPAD ? 9.0 : 6.0
let replicatorLineWidth:CGFloat = isIPAD ? 9.0 : 6.0
let minuteHandRoundedTipLength:CGFloat = isIPAD ? 30 : 20

let progressiveLayerColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
let minuteHandColor: UIColor = #colorLiteral(red: 0.9770211577, green: 0.8214630485, blue: 0, alpha: 1)
let lightGrayColor = #colorLiteral(red: 0.8598186298, green: 0.8598186298, blue: 0.8598186298, alpha: 0.5)
let clearColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)

let localNotificationId = "notification.id.01"

