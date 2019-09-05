//
//  ContactSettingsViewController.swift
//  Notifier
//
//  Created by Cade May on 9/14/17.
//  Copyright © 2017 Cade May. All rights reserved.
//

import UIKit

class ContactSettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

   // table.reloadData()
    var senderList: [String] = []
    
    @IBOutlet weak var senderTable: UITableView!
    
    @IBOutlet weak var editButtonOutlet: UIBarButtonItem!
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return senderList.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier:"contactCell")
        cell.textLabel?.text = senderList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    
    }
    
    /*
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Who's Contacting You?"
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerText = UILabel()
        
        headerText.text = "Who's Contacting You?"
        headerText.textAlignment = .center
        headerText.backgroundColor = UIColor.lightGray
        //headerText.textColor = UIColor.lightGray
        //headerText.adjustsFontSizeToFitWidth = true
        
        return headerText
    }
    */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fetchList()
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchList()
        senderTable.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let list = getSenderList()
        
        if (list == [] || list.count == 0) {
            let newList = ["(678) 999-8212", "Cade May", "(365) 598-1356", "(202) 555-0150", "Mom"]
            
            let storage = UserDefaults.standard
            storage.set(newList, forKey: "senders")
        }
        
    }
    
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            var senders = getSenderList()
            print("list length: \(senders.count)")
            print("index: \(indexPath.row)")
            senders.remove(at: indexPath.row)
            
            let storage = UserDefaults.standard
            storage.set(senders, forKey: "senders")
            
            fetchList()
            senderTable.reloadData()
            
        }
    }
    
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if senderTable.isEditing == true {
            senderTable.setEditing(false, animated: true)
            editButtonOutlet.title = "Edit"
        } else {
            senderTable.setEditing(true, animated: true)
            editButtonOutlet.title = "Done"
        }
        
    }
    
    func fetchList() {
        
        let storage = UserDefaults.standard

        if let list = storage.object(forKey: "senders"), let l = list as? [String] {
            senderList = l
        } else {
        
            senderList = ["(678) 999-8212", "Cade May", "(365) 598-1356", "(202) 555-0150", "Mom"]
            storage.set(senderList, forKey: "senders")
        }
        
    }
    
    func getSenderList() -> [String] {
        
        let storage = UserDefaults.standard
        
        if let list = storage.object(forKey: "senders"), let li = list as? [String] {
            return li
        }
        
        return []
        
        
        
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
