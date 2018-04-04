//
//  AddContactManuallyViewController.swift
//  Mesh
//
//  Created by Paa Adu on 9/11/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import UIKit

class AddContactManuallyViewController: UIViewController {
    // TODO add option to add/take picture
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    private var spinner = UIActivityIndicatorView()
    private var sendingRequest = false // true if sending request to firebase. This prevents multiple requests from being sent at the same time
    var userFromQrCode: User? // This user might be passed in if we are adding a contact from a qr code
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let user = userFromQrCode {
            firstNameTextField.text = user.firstName
            lastNameTextField.text = user.lastName
            emailAddressTextField.text = user.primaryEmail
            phoneNumberTextField.text = user.phoneNumber
            companyTextField.text = user.company
            profilePictureImageView.image =
                user.profilePicture
        }
        spinner.center = self.view.center
        spinner.color = UIColor.meshRed()
        self.view.addSubview(spinner)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        // Reset everything for the next time the view is presented
        userFromQrCode = nil
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        emailAddressTextField.text = ""
        phoneNumberTextField.text = ""
        companyTextField.text = ""

    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let user = user {
//            firstNameTextField.text = user.firstName
//            lastNameTextField.text = user.lastName
//            emailAddressTextField.text = user.primaryEmail
//            phoneNumberTextField.text = user.phoneNumber
//            companyTextField.text = user.company
//        }
        //Setting background color
        self.view.backgroundColor = UIColor(red: 248/255, green: 40/255, blue: 54/255, alpha: 0.85)
        
        //To make the button rounded
        addButton.layer.cornerRadius = 5
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddContactManuallyViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func addButtonPressed(sender: AnyObject) {
        if (sendingRequest) {
            return
        }
        
        if firstNameTextField.text!.isEmpty {
            displayAlert("Enter a first name")
            return
        } else if lastNameTextField.text!.isEmpty {
            displayAlert("Enter a last name")
            return
        }
        
        let contact = User()
        contact.firstName = firstNameTextField.text!
        contact.lastName = lastNameTextField.text!
        contact.secondaryEmail = emailAddressTextField.text!
        contact.phoneNumber = phoneNumberTextField.text!
        contact.company = companyTextField.text!
        if (userFromQrCode != nil) {
            scanner.contactAdded = true
            contact.profilePicture = userFromQrCode?.profilePicture
            contact.userId = userFromQrCode!.userId
        } else {
            contact.assignUserId()
        }
        
        currentUser.connections.append(contact)
        currentUser.save()
        spinner.startAnimating()
        sendingRequest = true
        addConnection(contact) { (error) in
            // TODO: handle error
            self.sendingRequest = false
            self.spinner.stopAnimating()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func displayAlert(alertMessage: String) {
        let alertController = UIAlertController(title: "Error", message:
            alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
