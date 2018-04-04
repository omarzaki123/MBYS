//
//  RegisterAccountViewController.swift
//  Mesh
//
//  Created by Kevin Kusch on 8/19/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import UIKit
import Firebase

class RegisterAccountViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    
    private var spinner = UIActivityIndicatorView()
    private var sendingRequest = false // true if sending request to firebase. This prevents multiple requests from being sent at the same time
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.center = self.view.center
        spinner.color = UIColor.whiteColor()
        self.view.addSubview(spinner)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterAccountViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func createAccount(sender: UIButton) {
        if emailTextField.text!.isEmpty {
            displayAlert("Please enter your email address")
        } else if passwordTextField.text!.isEmpty {
            displayAlert("Please enter your password")
        } else if confirmTextField.text!.isEmpty {
            displayAlert("Please re-enter your password")
        } else if passwordTextField.text! != confirmTextField.text! {
            displayAlert("Your passwords do not match")
        } else if let email = emailTextField.text, let password = passwordTextField.text {
            sendingRequest = true
            spinner.startAnimating()
            FIRAuth.auth()?.createUserWithEmail(email, password: password) { (user, error) in
                if error != nil {
                    self.spinner.stopAnimating()
                    self.displayAlert(error!.localizedDescription)
                    self.sendingRequest = false
                    return
                }
                user?.sendEmailVerificationWithCompletion(nil)
                FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
                    self.spinner.stopAnimating()
                    self.sendingRequest = false
                    if error != nil {
                        self.displayAlert(error!.localizedDescription)
                    } else {
                        currentUser.primaryEmail = email
                        currentUser.userId = getCurrentUserId()
                        currentUser.save()
                        self.performSegueWithIdentifier("registerAccount", sender: self)
                    }
                }
            }
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func displayAlert(alertMessage: String) {
        let alertController = UIAlertController(title: "Error", message:
            alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
