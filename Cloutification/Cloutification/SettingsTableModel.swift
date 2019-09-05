//
//  SettingsTableModel.swift
//  NotifyMe
//
//  Created by Cade May on 9/8/17.
//  Copyright © 2017 Cade May. All rights reserved.
//

import Foundation

class SettingsTableModel {
    
    var frequencySpacing: Int?
    var durationInMinutes: Int?
    var startTime: Int?
    var phoneCallRatio: Int?
    var alertStyle: AlertStyle?
    
    
    let storage: UserDefaults
    
    init() {
        storage = UserDefaults.standard
        
        frequencySpacing = getFrequency()
        durationInMinutes = getDuration()
        startTime = getStart()
        phoneCallRatio = getAlertRatio()
        alertStyle = getAlertStyle()
        
    }
    
    func configureVitalVariables() {
        frequencySpacing = getFrequency()
        durationInMinutes = getDuration()
        startTime = getStart()
        phoneCallRatio = getAlertRatio()
        alertStyle = getAlertStyle()
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
    
    enum AlertStyle: Int {
        case audio = 0
        case audioVisible = 1
        case visible = 2
    }
    
    
    func getAlertStyle() -> AlertStyle {
        
        var toReturn = AlertStyle.audioVisible
        
        if let style = storage.object(forKey: "alertStyle"), let s = style as? Int {
            toReturn = SettingsTableModel.AlertStyle(rawValue: s)!
        } else {
            toReturn = AlertStyle.audioVisible
        }
        
        return toReturn
        
    }
    
}
