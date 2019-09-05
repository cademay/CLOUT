//
//  SettingsTableViewController.swift
//  NotifyMe
//
//  Created by Cade May on 9/6/17.
//  Copyright © 2017 Cade May. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    
    @IBOutlet weak var durationSliderOutlet: UISlider!
    
    @IBOutlet weak var frequencySliderOutlet: UISlider!

    @IBOutlet weak var onsetSliderOutlet: UISlider!

    @IBOutlet weak var messageToCallRatioSliderOutlet: UISlider!
    
    @IBOutlet weak var frequencyValueLabel: UILabel!

    @IBOutlet weak var durationValueLabel: UILabel!
    
    @IBOutlet weak var onsetValueLabel: UILabel!

    @IBOutlet weak var alertStyleLabel: UILabel!
    
    @IBOutlet weak var messagePercentageLabel: UILabel!
    @IBOutlet weak var phoneCallPercentageLabel: UILabel!
    
    @IBOutlet weak var alertStyleSegmentedControlOutlet: UISegmentedControl!

    @IBOutlet weak var navigationBar: UINavigationItem!
    

    
    let model = SettingsTableModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.configureVitalVariables()
        updateUI()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        model.configureVitalVariables()
        updateUI()
    }
    
    
    func updateUI() {
        alertStyleSegmentedControlOutlet.selectedSegmentIndex = 1
        
        frequencySliderOutlet.value = Float(model.frequencySpacing!)
        durationSliderOutlet.value = Float(model.durationInMinutes!)
        onsetSliderOutlet.value = Float(model.startTime!)
        messageToCallRatioSliderOutlet.value = Float(model.phoneCallRatio!)
        
        alertStyleSegmentedControlOutlet.selectedSegmentIndex = model.alertStyle!.rawValue
        synchronizeAlertStyleControlAndLabel()
        
        
        frequencyValueLabel.text =  "~ " + String(model.frequencySpacing!) + " seconds"
        setDurationValueLabelText(with: model.durationInMinutes!)
        setOnsetValueLabelText(with: model.startTime!)
        setMessageToCallRatioLabelText(value: model.phoneCallRatio!)
        
        
        
        navigationBar.title = "Settings"
        
        /* custom slider thumbs:
        let thumbImage = UIImage(named: "sliderThumb.png")
        let emojiThumbImage = UIImage(named: "sunglassesEmoji.png")
        frequencySliderOutlet.setThumbImage(thumbImage, for: .normal)
        frequencySliderOutlet.setThumbImage(emojiThumbImage, for: .highlighted)
        
        durationSliderOutlet.setThumbImage(thumbImage, for: .normal)
        durationSliderOutlet.setThumbImage(emojiThumbImage, for: .highlighted)
        
        onsetSliderOutlet.setThumbImage(thumbImage, for: .normal)
        onsetSliderOutlet.setThumbImage(emojiThumbImage, for: .highlighted)
        */
        
    }
    
    
    @IBAction func contactSelectButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "contactSelect", sender: nil)
    }
    
    
    @IBAction func durationSliderAction(_ sender: UISlider) {
        let sliderValue = Int(sender.value)
        setDurationValueLabelText(with: sliderValue)
    }
    
    @IBAction func frequencySliderAction(_ sender: UISlider) {
        let sliderValue = Int(sender.value)
        frequencyValueLabel.text = "~ " + String(sliderValue) + " seconds"
    }
    
    @IBAction func onsetSliderAction(_ sender: UISlider) {
        let sliderValue = Int(sender.value)
        setOnsetValueLabelText(with: sliderValue)
    }
    
    
    @IBAction func messageToCallRatioAction(_ sender: UISlider) {
        let sliderValue = Int(sender.value)
        setMessageToCallRatioLabelText(value: sliderValue)
    }
    
    
    func setDurationValueLabelText(with duration: Int) {
        if (duration == 1) {
            durationValueLabel.text = String(duration) + " minute"
        } else {
            durationValueLabel.text = String(duration) + " minutes"
        }
    }
    
    func setOnsetValueLabelText(with time: Int) {
        if (time == 1) {
            onsetValueLabel.text = "in " + String(time) + " minute"
        } else if (time == 0) {
            onsetValueLabel.text = "Immediately"
        } else {
            onsetValueLabel.text = "in " + String(time) + " minutes"
        }
    }
    
    func setMessageToCallRatioLabelText(value: Int) {
        let phoneCallNum = value
        let messageNum = 10 - value
        messagePercentageLabel.text = (messageNum == 0) ? String(messageNum) + "%" : String(messageNum) + "0%"
        phoneCallPercentageLabel.text = (phoneCallNum == 0) ? String(phoneCallNum) + "%" : String(phoneCallNum) + "0%"
    }
    
    

    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        saveVitals()
        print("viewWillDisappear")
    }
    
    
    func saveVitals() {
        model.storage.set(durationSliderOutlet.value, forKey: "duration")
        model.storage.set(frequencySliderOutlet.value, forKey: "frequency")
        model.storage.set(onsetSliderOutlet.value, forKey: "startTime")
        model.storage.set(messageToCallRatioSliderOutlet.value, forKey: "phoneCallRatio")
        model.storage.set(alertStyleSegmentedControlOutlet.selectedSegmentIndex, forKey: "alertStyle")

    }
    
    
    
    
    
    
    @IBAction func alertStyleSegmentedControlAction(_ sender: UISegmentedControl) {
        synchronizeAlertStyleControlAndLabel()
    }
    
    func synchronizeAlertStyleControlAndLabel() {
        
        if alertStyleSegmentedControlOutlet.selectedSegmentIndex == SettingsTableModel.AlertStyle.audio.rawValue {
            alertStyleLabel.text = "Audio"
        }
        
        if alertStyleSegmentedControlOutlet.selectedSegmentIndex == SettingsTableModel.AlertStyle.audioVisible.rawValue {
            alertStyleLabel.text = "Audio + Visible"
        }
        
        if alertStyleSegmentedControlOutlet.selectedSegmentIndex == SettingsTableModel.AlertStyle.visible.rawValue {
            alertStyleLabel.text = "Visible"
        }
        
    }

    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    
    // MARK: - Table view data source
    /*
     override func numberOfSections(in tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     return 0
     }
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     // #warning Incomplete implementation, return the number of rows
     return 0
     }
     
     */
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
