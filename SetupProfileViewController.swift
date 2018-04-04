//
//  SetupProfileViewController.swift
//  Mesh
//
//  Created by Kevin Kusch on 8/23/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import UIKit

class SetupProfileViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var companyPositionTextField: UITextField!
    
    private var spinner = UIActivityIndicatorView() // spins when sending information to firebase
    private var sendingRequest = false // true if sending request to firebase. This prevents multiple requests from being sent at the same time
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.center = self.view.center
        spinner.color = UIColor.whiteColor()
        self.view.addSubview(spinner)
        
        schoolTextField.delegate = self
        
        self.firstNameTextField.text = currentUser.firstName
        self.lastNameTextField.text = currentUser.lastName
        self.schoolTextField.text = currentUser.school
        self.emailAddressTextField.text = currentUser.secondaryEmail
        self.phoneNumberTextField.text = currentUser.phoneNumber
        self.companyNameTextField.text = currentUser.company
        self.companyPositionTextField.text = currentUser.position
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddNearby.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func setupProfile(sender: UIButton) {
        if firstNameTextField.text!.isEmpty {
            displayAlert("Enter first name")
            return
        } else if lastNameTextField.text!.isEmpty {
            displayAlert("Enter last name")
            return
        }
        save()
        if sendingRequest {
            return
        }
        spinner.startAnimating()
        saveProfile(currentUser) { (error) in
            self.spinner.stopAnimating()
            if error != nil {
                self.displayAlert(error!.localizedDescription)
                return
            }
            self.performSegueWithIdentifier("addProfilePicture", sender: self)
        }
        sendingRequest = true

        
        // Add check that student email is valid/ends in edu?
        
    }
    
    func displayAlert(alertMessage: String) {
        let alertController = UIAlertController(title: "Error", message:
            alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        save() // needed to remember the state of all text fields so that we can reload after selecting a school
        self.performSegueWithIdentifier("setupToSchoolTable", sender: self)
        return false
    }
    
    func save(){
        currentUser.firstName =  firstNameTextField.text!
        currentUser.lastName = lastNameTextField.text!
        currentUser.school = schoolTextField.text!
        currentUser.phoneNumber = phoneNumberTextField.text!
        currentUser.company = companyNameTextField.text!
        currentUser.position = companyPositionTextField.text!
        currentUser.secondaryEmail = emailAddressTextField.text!
        currentUser.save()
    }
    
    // Calls this function when the tap is recognized.
    func dismissKeyboard() {
        // Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
