//
//  StartPressedPopupViewController.swift
//  NotifyMe
//
//  Created by Cade May on 9/6/17.
//  Copyright © 2017 Cade May. All rights reserved.
//

import UIKit


class StartPressedPopupViewController: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popupButtonOutlet: UIButton!
    
    @IBOutlet weak var popupTitle: UILabel!
    
    @IBOutlet weak var popText1: UILabel!
    @IBOutlet weak var popupText2: UILabel!
    
    
    var authorized: Bool?
    let model = StartPressedPopupModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        model.confirmAuthorization { result in
            
            self.authorized = result
            
            print("auhtorised")
            print(self.authorized)
            
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    
    
    @IBAction func popupButtonPressed(_ sender: UIButton) {
        
        if self.authorized! {
            dismiss(animated: true, completion: nil)
        } else {
            openSettings()
        }
        
    }
    
    @IBAction func popupBackgroundButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateUI() {
        popupView.layer.cornerRadius = 8
        popupView.layer.masksToBounds = true
        popupButtonOutlet.layer.cornerRadius = 8
        
        
        if self.authorized! {
            popupButtonOutlet.backgroundColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
            popupButtonOutlet.setTitle("Okay", for: .normal)
            
            popupTitle.text = "Success"
            //popupTitle.textColor = UIColor.green
            
            let startTime = model.getStart()
            
            if startTime == 0 {
                popText1.text = "Your notification cycle will begin in 10 seconds."
            } else if startTime == 1 {
                popText1.text = "Your notification cycle will begin in " + String(startTime) + " minute."
            } else {
                popText1.text = "Your notification cycle will begin in " + String(startTime) + " minutes."
            }
            
            popupText2.text = "May the clout be with you."
            
            
        } else {
            
            popupButtonOutlet.backgroundColor = UIColor.blue
            popupButtonOutlet.setTitle("Settings", for: .normal)
            
            popupTitle.text = "Error"
            popupTitle.textColor = UIColor.red
            
            popText1.text = "Cloutification needs your permssion"
            popupText2.text = "Please enable notifications and sounds for Cloutification"
            
        }
        
        
    }
    
    func openSettings() {
        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
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
