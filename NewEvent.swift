//
//  ViewController.swift
//  NewEventPost
//
//  Created by Akash Wadawadigi on 8/23/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class NewEvent: UIViewController {
    var currentTextField: UITextField?
    @IBOutlet weak var eventLocation: UITextField!
    @IBOutlet weak var eventEndTime: UITextField!
    @IBOutlet weak var eventStartTime: UITextField!
    @IBOutlet weak var eventDate: UITextField!
    @IBOutlet weak var eventEndDate: UITextField!
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var companyName: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var postEvent: UIButton!
    
    var startingDate: NSDate = NSDate()
    
    var chosenDate: NSDate?
    var chosenStartTime: NSDate?
    var chosenEndDate: NSDate?
    var chosenEndTime: NSDate?
    
    var companyEvent: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //If we are adding an event from the newsfeed
        if let event = companyEvent {
            eventTitle.text = event.title
            companyName.text = event.company
            eventLocation.text = event.location
            
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //Setting background color
        self.view.backgroundColor = UIColor(red: 248/255, green: 40/255, blue: 54/255, alpha: 0.85)
        
        //To make the button rounded
        postEvent.layer.cornerRadius = 5
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewEvent.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        companyEvent = nil
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    @IBAction func cancelNewEvent(sender: AnyObject) { //*****
         self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func startDateEdit(sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.setDate(startingDate, animated: false)
        sender.inputView = datePickerView
        
        
       datePickerView.addTarget(self, action: #selector(NewEvent.startDateEditing(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        
    }
    
    
    func startDateEditing(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        chosenDate = sender.date
        eventDate.text = dateFormatter.stringFromDate(sender.date)
    }
    
    @IBAction func endDateEdit(sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
         datePickerView.setDate(startingDate, animated: false)
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(NewEvent.endDateEditing(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        
    }
    
    
    func endDateEditing(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        chosenEndDate = sender.date
        eventEndDate.text = dateFormatter.stringFromDate(sender.date)
    }
    
    
    
    
    @IBAction func startTimeEdit(sender: UITextField) {
      
        let timePickerView:UIDatePicker = UIDatePicker()
        timePickerView.datePickerMode = UIDatePickerMode.Time
        sender.inputView = timePickerView
    
        timePickerView.addTarget(self, action: #selector(NewEvent.starTimeEditing(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func starTimeEditing(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        chosenStartTime = sender.date
        eventStartTime.text = dateFormatter.stringFromDate(sender.date)
    }
    
    @IBAction func endTimeEdit(sender: UITextField) {
 
        let timePickerView:UIDatePicker = UIDatePicker()
        timePickerView.datePickerMode = UIDatePickerMode.Time
        sender.inputView = timePickerView
        
        timePickerView.addTarget(self, action: #selector(NewEvent.endTimeEditing(_:)), forControlEvents: UIControlEvents.ValueChanged)

    }
  
    func endTimeEditing(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        chosenEndTime = sender.date
        eventEndTime.text = dateFormatter.stringFromDate(sender.date)
    }
    
    @IBAction func postNewEvent(sender: AnyObject) {
        
        if eventTitle.text!.isEmpty {
            displayAlert("Please enter event title")
        } else if eventDate.text!.isEmpty {
            displayAlert("Please enter start date")
        } else if eventStartTime.text!.isEmpty {
            displayAlert("Please enter start time")
        } else if eventEndTime.text!.isEmpty {
            displayAlert("Please enter end time")
        }
        
        let newEvent = Event()
        newEvent.assignUUID()
        var startDateComponents = NSDateComponents()
        var startTimeComponents = NSDateComponents()
        var endDateComponents = NSDateComponents()
        var endTimeComponents = NSDateComponents()
        
        startDateComponents = NSCalendar.currentCalendar().components([.Day, .Year, .Month],fromDate: chosenDate!)
        startTimeComponents = NSCalendar.currentCalendar().components([.Hour, .Minute], fromDate:chosenStartTime!)
        startDateComponents.hour  = startTimeComponents.hour
        startDateComponents.minute = startTimeComponents.minute
        
        endDateComponents = NSCalendar.currentCalendar().components([.Day, .Year, .Month],fromDate: chosenEndDate!)
        endTimeComponents = NSCalendar.currentCalendar().components([.Hour, .Minute], fromDate:chosenEndTime!)
        endDateComponents.hour  = endTimeComponents.hour
        endDateComponents.minute = endTimeComponents.minute

        newEvent.startTime = NSCalendar.currentCalendar().dateFromComponents(startDateComponents)!
        newEvent.title = eventTitle.text!
        newEvent.endTime =  NSCalendar.currentCalendar().dateFromComponents(endDateComponents)!
    
        if(!eventLocation.text!.isEmpty) {
            newEvent.location = eventLocation.text!
        }
        if(!companyName.text!.isEmpty) {
            newEvent.company = companyName.text!
        }
        
        print(newEvent.title)
        print(newEvent.startTime)
        print(newEvent.endTime)
        print(newEvent.location)
        
        if(newEvent.startTime.compare(newEvent.endTime) == .OrderedDescending) {
            displayAlert("Please enter later end time or date")
        } else {
            currentUser.events.append(newEvent)
            currentUser.save()
            saveEvent(newEvent)
            //pushEventToSchools("Stanford University", event: newEvent)
            addLocalNotification(newEvent)
            self.dismissViewControllerAnimated(true){}
        }
        
        
    }
    
    
    func displayAlert(alertMessage: String) {
        let alertController = UIAlertController(title: "Error", message:
            alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }



}

