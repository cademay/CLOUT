//
//  HomeViewController.swift
//  NotifyMe
//
//  Created by Cade May on 9/5/17.
//  Copyright © 2017 Cade May. All rights reserved.
//

import UIKit
import UserNotifications

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var outerStyleBox: UIView!
    @IBOutlet weak var settingsDisplayBox: UIView!
    
    @IBOutlet weak var startButtonOutlet: UIButton!
    @IBOutlet weak var stopButtonOutlet: UIButton!
    
    @IBOutlet weak var frequencyDescriptionLabel: UILabel!
    @IBOutlet weak var durationDescriptionLabel: UILabel!
    @IBOutlet weak var startDescriptionLabel: UILabel!


    
    let model = HomeModel()
    
    @IBAction func openSettings(_ sender: UIButton) {
        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        model.configureVitalVariables()
        setupUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        model.configureVitalVariables()
        setupUI()
        print("viewDidAppear")
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        model.configureVitalVariables()
        
        model.checkAuthorizationAndGenerateNotifications { result in
            

            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "startPressedSegue", sender: self)
            }
            
            /*
            if result == true {
                print("success in homeVC -- about to show user success segue")
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "alertSuccessSegue", sender: self)
                }
                
            } else {
                
                //there is an issue with auth settings, notifications were not sent
                //send user a popup that instructs them on going to iOS settings and authorizing each value in the authIssues array
                print("failure in homeVC, about to show user error")
                
                self.model.authorizationIssues { issues in
                    
                    print(issues)
                }
                
                
            }*/
            
            
        }
    
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startPressedSegue" {
            self.model.authorizationIssues { issues in
                print(issues)
                self.model.storage.set(issues, forKey: "authorizationIssues")
            }
        }
    }
    
    
    func setupUI() {
        
        frequencyDescriptionLabel.text = model.getFrequencyLabelDescription()
        durationDescriptionLabel.text = model.getDurationLabelDescription()
        startDescriptionLabel.text = model.getStartLabelDescription()
        
        settingsDisplayBox.layer.cornerRadius = 8.0
        outerStyleBox.layer.cornerRadius = 8.0
        
        //settingsDisplayBox.layer.borderColor = UIColor.blue
        //outerStyleBox.layer.borderColor = UIColor.blue as! CGColor
        
        startButtonOutlet.layer.cornerRadius = 8.0
        stopButtonOutlet.layer.cornerRadius = 8.0
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 1
    }
    
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
/*
extension UIViewController: UNUserNotificationCenterDelegate {
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        completionHandler( [.alert, .sound])
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        print("Do what ever you want")
        
    }
    
}
*/
