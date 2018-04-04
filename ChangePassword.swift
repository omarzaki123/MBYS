//
//  ChangePassword.swift
//  Mesh
//
//  Created by Ariel Bong on 8/23/16.
//  Copyright © 2016 ArielBong. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ChangePassword: UIViewController {
    @IBOutlet weak var changePasswordText: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 248/255, green: 40/255, blue: 54/255, alpha: 0.85)//UIColor(red: 248/255, green: 40/255, blue: 54/255, alpha: 0.85)
        
    }
    
    @IBAction func confirmNewPassword(sender: AnyObject) {
        
        if changePasswordText.text!.isEmpty {
            displayAlert("Please enter your new password")
        } else if confirmPasswordText.text!.isEmpty{
            displayAlert("Please confirm your new password")
        } else if(changePasswordText.text != changePasswordText.text) {
            displayAlert("Passwords do not match")
        }
        
        if let newPassword = confirmPasswordText.text {
            let user = FIRAuth.auth()?.currentUser!
            user!.updatePassword(newPassword, completion: { (callback) in
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