//
//  NewContactModalViewController.swift
//  Notifier
//
//  Created by Cade May on 9/14/17.
//  Copyright © 2017 Cade May. All rights reserved.
//

import UIKit

class NewContactModalViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var saveButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var userTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //saveButtonOutlet.isEnabled = false

        // Do any additional setup after loading the view.
    }


    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        print("save")
        
        let storage = UserDefaults.standard
        var senderList: [String] = []
        
        if let list = storage.object(forKey: "senders"), let l = list as? [String] {
            senderList = l
        } else {
            senderList = []
        }
        
        if let newContacter = userTextField.text {
            senderList.append(newContacter)
            storage.set(senderList, forKey: "senders")
        }
        
        dismiss(animated: true, completion: nil)

        
    }

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
