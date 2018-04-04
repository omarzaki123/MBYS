//
//  ViewController.swift
//  newImagePost
//
//  Created by Akash Wadawadigi on 8/30/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class newImagePostViewController: UIViewController {
    
    var tempPost: tempImagePost?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Setting background color
        self.view.backgroundColor = UIColor(red: 248/255, green: 40/255, blue: 54/255, alpha: 0.85)
        
        //To make the button rounded
        uploadButton.layer.cornerRadius = 5
        postButton.layer.cornerRadius = 5

        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(newImagePostViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.textOfImage.layer.cornerRadius = 5
        
        if tempPost != nil {
            imagePostTitle.text = tempPost?.title
            textOfImage.text = tempPost!.text
            schoolOfPost.text = tempPost!.school
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

    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var imagePostTitle: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var textOfImage: UITextView!
    @IBOutlet weak var schoolOfPost: UITextField!
    
    @IBAction func newImagePost(sender: AnyObject) {
        let imagePost = Event()
        imagePost.title = imagePostTitle.text!
        if imagePostTitle.text == nil {
            displayAlert("Please enter a title")
        }
        
    }
   
    @IBAction func schoolEditing(sender: AnyObject) {
        self.performSegueWithIdentifier("showSchools", sender: self)
    }
    
    //saves temp post info for the moment
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        tempPost = tempImagePost(title: imagePostTitle.text!, text: textOfImage.text, school: "", image: UIImage())
        
        if segue.identifier == "showSchools" {
            let destination = segue.destinationViewController as? SchoolsViewController
            destination?.imagePost = tempPost
        }
    }
    
    @IBAction func createImagePost(sender: AnyObject) {
        let imagePost = EventWithImage()
        
        if imagePostTitle.text == nil {
            displayAlert("Please enter a title")
        } else if textOfImage.text == nil {
            displayAlert("Please enter text post")
        } else if textOfImage.text.characters.count > 250 {
            displayAlert("Text post over 250 characters")
        } else if schoolOfPost.text == nil {
            displayAlert("Please select school")
        }
        
        imagePost.title = imagePostTitle.text!
        imagePost.eventDescription = textOfImage.text!
        imagePost.image = (tempPost?.image)!
        
        pushEventToSchool(schoolOfPost.text!, event: imagePost)
        
    }
    
    func displayAlert(alertMessage: String) {
        let alertController = UIAlertController(title: "Error", message:
            alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
}

