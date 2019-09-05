//
//  StartPressedPopupModel.swift
//  Notifier
//
//  Created by Cade May on 12/23/17.
//  Copyright © 2017 Cade May. All rights reserved.
//

import Foundation
import UserNotifications

class StartPressedPopupModel {
    
    let storage: UserDefaults
    
    
    
    
    init() {
        storage = UserDefaults.standard
    }
    
    
    
    func confirmAuthorization(completion: @escaping (Bool) -> ()) {
        
        
        authorizationIssues { issues in
            
            if issues == [] {
                completion(true)
            } else {
                completion(false)
            }
            
        }

        
        /*
        if let i = storage.object(forKey: "authorizationIssues"), let issues = i as? [String] {
            
            print(issues)
            if issues == [] {
                completion(true)
            } else {
                completion(false)
            }
            
        } else {
            
            authorizationIssues { issues in
                
                if issues == [] {
                    completion(true)
                } else {
                    completion(false)
                }
                
            }
        }
        */
    }
    
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
    
    func getStart() -> Int {
        
        var toReturn = 0
        
        if let start = storage.object(forKey: "startTime"), let s = start as? Int {
            toReturn = s
        } else {
            toReturn = 0
        }
        
        return toReturn
    }
    
    
    
}
