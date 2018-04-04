//
//  ViewController.swift
//  Mesh
//
//  Created by Kevin Kusch on 7/24/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var theWholeView: UIView!
    var colorView = UIView()
    var masteraccounts: [String:String]?
    private var spinner = UIActivityIndicatorView()
    private var sendingRequest = false // true if sending request to firebase. This prevents multiple requests from being sent at the same time
    var completedRequests = 0  // keeps track of requests completed from firebase so we know when to segue if loading a different account
    let numAsyncRequests = 5 // number of requests made in getProfileData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LogInViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        slightAdjustments()
        spinner.center = self.view.center
        spinner.color = UIColor.meshRed()
        self.view.addSubview(spinner)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    @IBAction func login(sender: UIButton) {
        if (sendingRequest) {
            return
        }
        if EmailTextField.text!.isEmpty {
            displayAlert("Please enter your email address")
        } else if PasswordTextField.text!.isEmpty {
            displayAlert("Please enter your password")
        }
        
        if let email = EmailTextField.text, password = PasswordTextField.text {
            sendingRequest = true
            spinner.startAnimating()
            FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
                if (error != nil) {
                    self.displayAlert(error!.localizedDescription)
                    self.sendingRequest = false
                    self.spinner.stopAnimating()
                    return
                } else if !(user!.emailVerified) {
                    self.sendingRequest = false
                    self.spinner.stopAnimating()
                    self.displayAlert("This account has not been verified. Please check your email to verify.")
                } else {
                    self.moveThingsDown()
                    if let userID = user?.uid {
                        if (currentUser.userId == user?.uid) {
                            self.performSegueWithIdentifier("login", sender: self)
                        } else {
                            self.getProfileData(userID)
                        }
                    } else {
                        self.sendingRequest = false
                        self.spinner.stopAnimating()
                        self.displayAlert("Error: Unable to login at this time")
                    }
                }
            }
        }
    }
    
    
    func getProfileData(userID: String) {
        //we are logging in to a different account than the account we have local data saved. We must download the data of the new account
        currentUser = User()
        getUserInformation(userID) { (user) in
            if let user = user {
                //successfully got information
                currentUser.firstName = user.firstName
                currentUser.lastName = user.lastName
                currentUser.secondaryEmail = user.secondaryEmail
                currentUser.phoneNumber = user.phoneNumber
                currentUser.school = user.school
                currentUser.company = user.company
                currentUser.position = user.position
                print(currentUser.firstName)
                print(currentUser.lastName)
                print(currentUser.secondaryEmail)
                print(currentUser.phoneNumber)
                
            }
            self.updateCompletedRequests()
        }
        
        getConnections() { (connections) in
            currentUser.connections = connections
            self.updateCompletedRequests()
        }
        getPicture(userID) { (image) in
            currentUser.profilePicture = image
            self.updateCompletedRequests()
        }
        getUserReminders() { (reminders) in
            currentUser.reminders = reminders
            self.updateCompletedRequests()
        }
        getUserEvents() { (events) in
            currentUser.events = events
            self.updateCompletedRequests()
        }
    }
    
    func updateCompletedRequests() {
        completedRequests = completedRequests + 1
        if (completedRequests == numAsyncRequests) { //we are done gathering data and can segue
            currentUser.save()
            self.performSegueWithIdentifier("login", sender: self)
        }
    }
    
    @IBAction func createAnAccount(sender: UIButton) {
        currentUser = User() // reset the current user since we are making a new account
        performSegueWithIdentifier("createAccount", sender: nil)
    }
    
    func displayAlert(alertMessage: String) {
        let alertController = UIAlertController(title: "Error", message:
            alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func segueToCorrectScreen(isTechAccount: Bool) {
        if(isTechAccount) {
            //moveThingsDown()
            //self.performSegueWithIdentifier("requestTable", sender: self)
        } else {
            moveThingsDown()
            self.performSegueWithIdentifier("login", sender: self)
            
        }
    }
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     if(segue.identifier == "requestTable") {
     let masterRequestVC = segue.destinationViewController as? MasterRequestTable
     masterRequestVC?.masterAccountRequests = masteraccounts
     masterRequestVC?.masterAccountRequestKeys = Array(masteraccounts!.keys)
     }
     }*/
    
    func slightAdjustments() {
        let frame = self.view.frame
        EmailTextField.addTarget(self, action: #selector(moveThingsUp), forControlEvents: UIControlEvents.EditingDidBegin)
        PasswordTextField.addTarget(self, action: #selector(moveThingsUp), forControlEvents: UIControlEvents.EditingDidBegin)
        EmailTextField.addTarget(self, action: #selector(moveThingsDown), forControlEvents: UIControlEvents.EditingDidEnd)
        PasswordTextField.addTarget(self, action: #selector(moveThingsDown), forControlEvents: UIControlEvents.EditingDidEnd)
        colorView = UIView(frame: CGRectMake(0, 0, frame.width, 20))
        colorView.backgroundColor = UIColor.meshRed()
        self.view.addSubview(colorView)
    }
    
    func moveThingsUp() {
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseIn , animations: {
            let up = CGAffineTransformMakeTranslation(0, -78)
            self.theWholeView.transform = up
            self.colorView.transform = up
            }, completion:nil)
    }
    
    func moveThingsDown() {
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseIn , animations: {
            let down = CGAffineTransformMakeTranslation(0, 0)
            self.theWholeView.transform = down
            self.colorView.transform = down
            }, completion:nil)
    }
    
    
}

