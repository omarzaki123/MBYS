//
//  ViewController.swift
//  AddReminder
//
//  Created by Akash Wadawadigi on 8/27/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class setReminderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Setting background color
        self.view.backgroundColor = UIColor(red: 248/255, green: 40/255, blue: 54/255, alpha: 0.85)
        
        setupVC()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(setReminderViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

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
    
    //Sets up the VC based on the settings reminder
    func setupVC() {
        
        if getDefaultInitialReminderUnits() == 0 { //0 = days in settings
            initialFollowUp.text = String(getDefaultInitialReminder())
        } else { //1 = weeks in settings
            let daysUntilReminder = 7 * getDefaultInitialReminder()
            initialFollowUp.text = String(daysUntilReminder)
        }
        
        if getPeriodicReminderUnits() == 0 { //0 = weeks
            frequencyOfReminder.text  = String(getPeriodicReminderValue())
        } else { //
            let weeksUntilReminder = 4 * getPeriodicReminderValue()
            frequencyOfReminder.text = String(weeksUntilReminder)
        }
        
        let currentdate = NSDate()
       // let advanceByTimeInterval = .Ho
    }

    //This outlet is for the intial follow up reminder notification
    @IBOutlet weak var initialFollowUp: UITextField!

    //This outlet is for the reminder that occurs with frequency
    @IBOutlet weak var frequencyOfReminder: UITextField!
    
    //The following three outlets are for the set date
    @IBOutlet weak var monthOfSetDate: UITextField!
    
    @IBOutlet weak var dayOfSetDate: UITextField!
    
    @IBOutlet weak var yearOfSetDate: UITextField!
    
    @IBAction func reminderToggle(sender: AnyObject) {
        if(sender.titleLabel?!.text == "✓"){
            sender.setTitle(" ", forState: .Normal)
        } else if (sender.titleLabel?!.text == " "){
            sender.setTitle("✓", forState: .Normal)
        }
    }
    
    @IBAction func autoReminderToggle(sender: AnyObject) {
        reminderToggle(sender)
    }
    
    
    @IBAction func setDateReminder(sender: AnyObject) {
        reminderToggle(sender)
    }
    
    @IBAction func setMonth(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        
         datePickerView.addTarget(self, action: #selector(setReminderViewController.dateEditing(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBAction func setDay(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(setReminderViewController.dateEditing(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBAction func setYear(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(setReminderViewController.dateEditing(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func dateEditing(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        let selectedDate = sender.date
        var selectedDateComponents = NSDateComponents()
        selectedDateComponents = NSCalendar.currentCalendar().components([.Month, .Day, .Year], fromDate: selectedDate)
        
        monthOfSetDate.text = String(selectedDateComponents.month)
        dayOfSetDate.text = String(selectedDateComponents.day)
        yearOfSetDate.text = String(selectedDateComponents.year)
    }
}

