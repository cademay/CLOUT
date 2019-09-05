//
//  HomeModel.swift
//  NotifyMe
//
//  Created by Cade May on 9/7/17.
//  Copyright © 2017 Cade May. All rights reserved.
//

import Foundation
import UserNotifications

class HomeModel {
    
    
    var frequencySpacing: Int?
    var durationInMinutes: Int?
    var startTime: Int?
    var phoneCallRatio: Int?
    var previousNotificationTime: Int?
    var alertStyle: AlertStyle?
    var senders: [String]?
    
    var messageMap: [String: (Int, String)]
    
    let immediacyOffset = 10
    
    let timedNotificationIdentifer = "timedNotificationIdentifer"
    var previousNotificationIsPhoneCall = false
    
    let storage: UserDefaults
    
    init() {
        storage = UserDefaults.standard
        
        messageMap = [:]
        frequencySpacing = getFrequency()
        durationInMinutes = getDuration()
        startTime = getStart()
        phoneCallRatio = getAlertRatio()
        senders = getSenders()
        alertStyle = getAlertStyle()
        
        
        
        previousNotificationTime = 0
        
    }
    
    
    func configureVitalVariables() {
        frequencySpacing = getFrequency()
        durationInMinutes = getDuration()
        startTime = getStart()
        phoneCallRatio = getAlertRatio()
        previousNotificationTime = 0

    }
    
    
    func settingsCheck() {
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            let badgeStatus = settings.badgeSetting
            
            let alertSetting = settings.alertSetting
            let soundSetting = settings.soundSetting
            
            
            if alertSetting == .enabled {
                print("alertSetting == true")
            } else {
                print("alertSetting == false")
            }
            
            if soundSetting == .enabled {
                print("soundSetting == true")
            } else {
                print("soundSetting == false")
            }
            
            
            
        }
    }
    
    
    
    func checkAuthorizationAndGenerateNotifications(completion: @escaping (Bool) -> ()) {
        
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            let authorization = settings.authorizationStatus
            let alert = settings.alertSetting
            let sound = settings.soundSetting
            
            
            if(authorization == .authorized && alert == .enabled && sound == .enabled) {
                
                self.createNotifications()
                
                print("already authorized")
                
                completion(true)
                
            } else {
                
                print("about to call request auth")
                
                self.requestAuthorization { result in
                    print("entering requestAuthorization's completion handler")
                    switch result {
                    case .success:
                        self.createNotifications()
                        completion(true)
                        
                    case .failure: completion(false)
                    }
                    
                }
         
            }
            
            
            print("else4")
        }
        

        
    }
    
    
    enum AuthResult {
        case success, failure
    }
    
    func requestAuthorization(completion: @escaping (AuthResult) -> ()) {
        
        print("top of request auth")
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge, .alert], completionHandler: { (success, error) in
            
            
            if let error = error {
                print(error)
            
            } else {
                
                
                
                UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                    
                    print ("about to check settings again in requestAuthorization")
                    let authorization = settings.authorizationStatus
                    let alert = settings.alertSetting
                    let sound = settings.soundSetting
            
                    if (authorization == .authorized && alert == .enabled && sound == .enabled) {
                        print("success in requestAuth")
                        completion(.success)
                    } else {
                        print("failure in requestAuth")
                        completion(.failure)
                    }
                    
                }
                
                
            }
        })
    }

    /*
    func checkAuthorizationAndGenerateNotifications() -> Bool {
     
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
     
            let authorization = settings.authorizationStatus
            let alert = settings.alertSetting
            let sound = settings.soundSetting
            
            
            if(authorization == .authorized && alert == .enabled && sound == .enabled) {
   
                self.createNotifications()
                print("if")
                return true
                
            } else {
                
                print("else")
                UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge, .alert], completionHandler: { (success, error) in
                    
                    print("else2")
                    if let error = error {
                        print(error)
                        print("else2.4")
                    } else {
                        print("else3")
                        print(success)
                        
                        if (authorization == .authorized && alert == .enabled && sound == .enabled) {
                            self.createNotifications()
                            return true
                        } else {
                            return false
                        }
                        
                        /*
                        if (success) {
                            self.createNotifications()
                            
                        } else {
                            // ask user to enable notifications, turn on sounds and alerts
                        }
                        */
 
                        
                        
                        
                    }
                })
            }
            
            
            print("else4")
        }
        
    }
 
    */
    
    func authorizationIssues(completion: @escaping ([String]) -> ()) {
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            var issues: [String] = []
            
            let authorization = settings.authorizationStatus
            let alert = settings.alertSetting
            let sound = settings.soundSetting
            
            
            
            if (authorization != .authorized) {
                issues.append("authorizationStatus")
            }
            
            if (alert != .enabled) {
                issues.append("alerts")
            }
            
            if (sound != .enabled) {
                issues.append("sounds")
            }
            
            
            completion(issues)
        }
    }
    
    
    func createNotifications() {
        
        if startTime! < 1 {
            startTime = immediacyOffset
        } else {
            startTime = startTime! * 60
            
        }
        
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let durationInSeconds = durationInMinutes! * 60
        
        let numberOfNotificationsToSend = Int(durationInSeconds / frequencySpacing!)
        
        print("duration seconds: \(durationInSeconds)")
        print("frequency spacing: \(frequencySpacing!)")
        print("num notifications: \(numberOfNotificationsToSend)")
        print("startTime : \(startTime!)")
        
        for i in 0..<numberOfNotificationsToSend {
            scheduleNotification(index: i)
            print(startTime)
        }
        
    }
    
    
    
    func scheduleNotification(index: Int) {
        
        let message = messageOrPhoneCallBoolGenerator(phoneCallRatio: phoneCallRatio!)
        
        if (message) {
            scheduleMessage(intervalMultiplier: index)
        } else {
            schedulePhoneCall(intervalMultiplier: index)
        }
        
    }
    
    func scheduleMessage(intervalMultiplier: Int) {
        
        let content = UNMutableNotificationContent()
        var identifier = timedNotificationIdentifer + String(intervalMultiplier)
        
        
        //content.title = "(202) 555-0150"
        

        
        /*
        if messageMap[content.title] != nil {
            //contains
            
            var count = (messageMap[content.title]?.0)!
            identifier = (messageMap[content.title]?.1)!
            count += 1
            
            messageMap.updateValue((count, identifier), forKey: content.title)
            
            content.title = content.title + " (" + String(count) + ")"
     
        } else {
            //doesn't contain
            
            
            messageMap[content.title] = (1, identifier)
        }
        */

    
        switch alertStyle! {
            
        case .audioVisible:
            content.title = getContentTitle()
            content.body = "iMessage"
            content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: "messageAlert.caf"))
            
        case .audio:
            content.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: "messageAlert.caf"))
            
        case .visible:
            content.title = getContentTitle()
            content.body = "iMessage"
        }
        
        /*
        content.title = getContentTitle()
        content.body = "iMessage"
        content.sound = UNNotificationSound.init(named: "messageAlert.caf")
        */
        
        if (previousNotificationIsPhoneCall) {
            startTime = startTime! + 21
        }
        
        
        let interval = getInterval(multiplier: intervalMultiplier)
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(interval), repeats: false)
        
        let notificationRequest = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        //let center =UNUserNotificationCenter.current()
        //center.add(request, withCompletionHandler:nil)
        
        let center = UNUserNotificationCenter.current()
        
        center.add(notificationRequest) { (error) in
            
            if let error = error {
                print(error)
            } else {
                print("text alert scheduled at \(interval)")
                print("")
            }
        }
        
        previousNotificationTime = interval
        previousNotificationIsPhoneCall = false
    }
    
    
    func schedulePhoneCall(intervalMultiplier: Int) {
        //schedule 1 sound alert, followed by a missed call no sound alert 20 seconds later
        
        
        let identifier = timedNotificationIdentifer + String(intervalMultiplier)
        
        if (previousNotificationIsPhoneCall) {
            startTime = startTime! + 21
        }
        
        let interval = getInterval(multiplier: intervalMultiplier)
        
        
        
        let center = UNUserNotificationCenter.current()
        
        switch alertStyle! {
            
        case .audioVisible:
            schedulePhoneCallSound(center: center, multiplier: intervalMultiplier, identifier: identifier, interval: interval)
            scheduleMissedCallAlert(center: center, identifier: identifier, interval: interval)
        case .audio:
            schedulePhoneCallSound(center: center, multiplier: intervalMultiplier, identifier: identifier, interval: interval)
        case .visible:
            scheduleMissedCallAlert(center: center, identifier: identifier, interval: interval)
        }
        schedulePhoneCallSound(center: center, multiplier: intervalMultiplier, identifier: identifier, interval: interval)
        scheduleMissedCallAlert(center: center, identifier: identifier, interval: interval)
        
        //leave this line as the last thing
        previousNotificationIsPhoneCall = true
    }
    
    func schedulePhoneCallSound(center: UNUserNotificationCenter, multiplier intervalMultiplier: Int, identifier: String, interval: Int) {
        
        let ringtoneContent = UNMutableNotificationContent()
        ringtoneContent.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: "ringtoneAlert.caf"))
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(interval), repeats: false)
        let notificationRequest = UNNotificationRequest(identifier: identifier, content: ringtoneContent, trigger: trigger)
        
        center.add(notificationRequest) { (error) in
            
            if let error = error {
                print(error)
            } else {
                print("ringtone sound scheduled at \(interval)")
                
            }
        }
    }
    
    
    func scheduleMissedCallAlert(center: UNUserNotificationCenter, identifier: String, interval: Int) {
        
        let missedCallContent = UNMutableNotificationContent()
        
        missedCallContent.title = "No Caller ID"
        missedCallContent.body = "Missed Call"
        
        let missedCallInterval = (interval + 20)
        
        let missedCallIdentifer = identifier + "missedCall"
        let missedCallTrigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(missedCallInterval), repeats: false)
        
        let missedCallNotificationRequest = UNNotificationRequest(identifier: missedCallIdentifer, content: missedCallContent, trigger: missedCallTrigger)
        
        center.add(missedCallNotificationRequest) { (error) in
            
            if let error = error {
                print(error)
            } else {
                print("missed call note scheduled at \(missedCallInterval))")
                print("")
            }
        }
        
        previousNotificationTime = missedCallInterval
    }
    
    
    
    
    func getContentTitle() -> String {
        
        senders = getSenders()
        
        if let numSenders = senders?.count {
            
            
            let randomIndex = Int(arc4random_uniform(UInt32(numSenders)))
            
            return (senders?[randomIndex])!

        }
        
        
        
        print("returning default sender")
        
        let defaultSender = "(202) 555-0150"
        return defaultSender
        
    }
    
    
    
    func getInterval(multiplier: Int) -> Int {
        
        var interval = startTime! + (multiplier * frequencySpacing!)
        
        let randomShift = getRandomShift(withRespectTo: frequencySpacing!)
        interval = interval + randomShift
        
        if (interval < previousNotificationTime!) {
            interval = interval - randomShift
        }
        
        return interval
        
    }
    
    
    
    
    
    
    func getRandomShift(withRespectTo value: Int) -> Int {
        
        var shiftMax = value / 5
        
        if shiftMax == 0 {
            shiftMax = 1
        }
        
        shiftMax += 1
        let shiftMagnitude = arc4random_uniform(UInt32(shiftMax))
        
        let positive = getRandomBool()
        var shift = Int(shiftMagnitude)
        
        if (!positive) {
            shift = (shift * -1)
        }
        
        return shift
    }
    
    
    func messageOrPhoneCallBoolGenerator(phoneCallRatio ratio: Int) -> Bool {
        
        if (ratio == 0) {
            return true
        }
        
        if (ratio == 10) {
            return false
        }
        
        let randomNum = Int(arc4random_uniform(11))
        
        if (randomNum > ratio) {
            return true
        } else {
            return false
        }
        
    }
    
    func getRandomBool() -> Bool {
        let randomBoolConstant = UInt32(2)
        let oneOrZero = arc4random_uniform(randomBoolConstant)
        
        if (oneOrZero == 1) {
            return true
        } else {
            return false
        }
    }
    
    func getStartLabelDescription() -> String {
        var startDescription = ""
        
        if (startTime! == 0) {
            startDescription = "Notification period will begin immediately"
        } else if (startTime! == 1) {
            startDescription = "Notification period will begin in " + String(startTime!) + " minute"
        } else {
            startDescription = "Notification period will begin in " + String(startTime!) + " minutes"
        }
        
        return startDescription
    }
    
    func getFrequencyLabelDescription() -> String {
        let toReturn = "Alerts will be delivered every " + String(frequencySpacing!) + " seconds"
        return toReturn
    }
    
    func getDurationLabelDescription() -> String {
        let toReturn = "Notification period will last " + String(durationInMinutes!) + " minutes"
        return toReturn
    }
    
    func getFrequency() -> Int {
        
        var toReturn = 0
        
        if let frequency = storage.object(forKey: "frequency"), let f = frequency as? Int {
            toReturn = f
        } else {
            toReturn = 40
        }
        
        return toReturn
    }
    
    
    func getDuration() -> Int {
        
        var toReturn = 0
        
        if let duration = storage.object(forKey: "duration"), let d = duration as? Int {
            toReturn = d
        } else {
            toReturn = 10
        }
        
        return toReturn
    }
    
    func getStart() -> Int {
        
        var toReturn = 0
        
        if let start = storage.object(forKey: "startTime"), let s = start as? Int {
            toReturn = s
        } else {
            toReturn = 0
        }
        
        return toReturn
    }
    
    func getAlertRatio() -> Int {
        
        var toReturn = 0
        if let alertTypeRatio = storage.object(forKey: "phoneCallRatio"), let a = alertTypeRatio as? Int {
            toReturn = a
        } else {
            toReturn = 0
        }
        
        return toReturn
    }
    
    func getSenders() -> [String] {
        
        let defaultSenders = ["(678) 999-8212", "Cade May", "(365) 598-1356", "(202) 555-0150", "Mom"]
        
        var toReturn: [String] = []
        
        if let list = storage.object(forKey: "senders"), let li = list as? [String] {
            toReturn = li
        } else {
            print("using default sender")
            toReturn = defaultSenders
        }
        
        
        return toReturn
    }
    
    
    enum AlertStyle: Int {
        case audio = 0
        case audioVisible = 1
        case visible = 2
    }
    
    
    func getAlertStyle() -> AlertStyle {
        
        var toReturn = AlertStyle.audioVisible
        
        if let style = storage.object(forKey: "alertStyle"), let s = style as? Int {
            toReturn = HomeModel.AlertStyle(rawValue: s)!
        } else {
            toReturn = AlertStyle.audioVisible
        }
        
        return toReturn
        
    }
    
    
    
    
    
}
