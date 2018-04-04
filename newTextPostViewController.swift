//
//  ViewController.swift
//  newTextPost
//
//  Created by Akash Wadawadigi on 8/30/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit


class newTextViewController: UIViewController {

    var tempPost: tempTextPost?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Setting background color
        self.view.backgroundColor = UIColor(red: 248/255, green: 40/255, blue: 54/255, alpha: 0.85)
        
        //To make the button rounded
        postButton.layer.cornerRadius = 5
        
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(newTextViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        self.textOfPost.layer.cornerRadius = 5
        
        if tempPost != nil {
            titleOfPost.text = tempPost?.title
            schoolOfPost.text = tempPost?.school
            textOfPost.text = tempPost?.text
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    @IBOutlet weak var titleOfPost: UITextField!
    @IBOutlet weak var textOfPost: UITextView!

    @IBOutlet weak var schoolOfPost: UITextField!
    @IBOutlet weak var postButton: UIButton!
    
    @IBAction func createTextPost(sender: AnyObject) {
        let textPost = Event()
        
        if titleOfPost.text == nil {
            displayAlert("Please enter a title")
        } else if textOfPost.text == nil {
            displayAlert("Please enter text post")
        } else if textOfPost.text.characters.count > 250 {
            displayAlert("Text post over 250 characters")
        }
        
        textPost.title = titleOfPost.text!
        textPost.eventDescription = textOfPost.text
        
        saveEvent(textPost) //check if it's for just user, for certain schools or some other spec
        getUserEvents() {
            events in
            currentUser.events = events
        }
        
        self.dismissViewControllerAnimated(false, completion: nil)
        
        
    }
    @IBAction func schoolSelection(sender: AnyObject) {
        tempPost = tempTextPost(title: titleOfPost.text!, text: textOfPost.text, school: "")
        self.performSegueWithIdentifier("showSchools", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        tempPost = tempTextPost(title: titleOfPost.text!, text: textOfPost.text, school: "")
        if segue.identifier == "showSchools" {
            let displayedVC = segue.destinationViewController as! SchoolsViewController
            displayedVC.tempPost = tempPost
        }
    }
    
    func displayAlert(alertMessage: String) {
        let alertController = UIAlertController(title: "Error", message:
            alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
   
    
}



