//
//  ChangeEmail.swift
//  Mesh
//
//  Created by Ariel Bong on 8/22/16.
//  Copyright © 2016 ArielBong. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ChangeEmail: UIViewController {
    @IBOutlet weak var changeEmailText: UITextField!
    @IBOutlet weak var confirmEmailText: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 248/255, green: 40/255, blue: 54/255, alpha: 0.85)//UIColor(patternImage: UIImage(named: "background popup window.png")!)
    
    }
    
    @IBAction func confirmNewEmail(sender: AnyObject) {
        
        if changeEmailText.text!.isEmpty {
            displayAlert("Please enter your email address")
        } else if confirmEmailText.text!.isEmpty{
            displayAlert("Please confirm your email address")
        } else if(changeEmailText.text != changeEmailText.text) {
            displayAlert("Emails do not match")
        }
        
        if let newEmail = confirmEmailText.text {
            let user = FIRAuth.auth()?.currentUser!
            user!.updateEmail(newEmail, completion: { (callback) in
                if let callback = callback{
                    self.displayAlert(callback.localizedDescription)
                }
                
            })
        }
      
        
        
    }
    
    func displayAlert(alertMessage: String) {
        let alertController = UIAlertController(title: "Error", message:
            alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}