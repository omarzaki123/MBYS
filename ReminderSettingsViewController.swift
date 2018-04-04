//
//  ViewController.swift
//  reminderSettings
//
//  Created by Akash Wadawadigi on 9/1/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class ReminderSettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Setting background color
        self.view.backgroundColor = UIColor(red: 248/255, green: 40/255, blue: 54/255, alpha: 0.85)
        setupLocalSettings()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReminderSettingsViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        reminderSettingsVC.dismissViewControllerAnimated(true) {}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var saveSettings: UIButton!
    @IBAction func saveReminderSettings(sender: AnyObject) {
        if(reminderCheckBox.titleLabel?.text == "✓"){
            setSendReminderNotificationsSetting(true)
        } else if (reminderCheckBox.titleLabel?.text == " "){
            setSendReminderNotificationsSetting(false)
        }
        setDefaultEventReminderUnits(defaultReminderUnits.selectedSegmentIndex)
        
        var initialReminderInt: Int
        if defaultInitialReminderValue.text != nil {
            initialReminderInt = Int(defaultInitialReminderValue.text!)!
        } else {
            initialReminderInt = getDefaultInitialReminder()
        }
        setDefaultInitialReminder(initialReminderInt)
        
        var periodicReminder: Int
        if defaultInitialReminderValue.text != nil {
            periodicReminder = Int(periodicReminderValue.text!)!
        } else {
            periodicReminder = getPeriodicReminderValue()
        }
        setPeriodicReminderValue(periodicReminder)
        setPeriodicReminderUnits(periodicReminderUnits.selectedSegmentIndex)
        userDefaults.synchronize()
    }
    
    @IBOutlet weak var defaultInitialReminderValue: UITextField!
    @IBOutlet weak var defaultReminderUnits: UISegmentedControl!
    @IBOutlet weak var periodicReminderValue: UITextField!
    @IBOutlet weak var periodicReminderUnits: UISegmentedControl!
    
    @IBOutlet weak var reminderCheckBox: UIButton!
    @IBAction func sendNotifications(sender: AnyObject) {
        if(sender.titleLabel?!.text == "✓"){
            sender.setTitle(" ", forState: .Normal)
        } else if (sender.titleLabel?!.text == " "){
            sender.setTitle("✓", forState: .Normal)
        }
    }
    
    
    
    //Pulls info from locally saved settings
    func setupLocalSettings() {
        defaultInitialReminderValue.text = String(getDefaultInitialReminder())
        defaultReminderUnits.selectedSegmentIndex = getDefaultInitialReminderUnits()
        
        periodicReminderValue.text = String(getPeriodicReminderValue())
        periodicReminderUnits.selectedSegmentIndex = getPeriodicReminderUnits()
        
        if getSendReminderNotificationsSetting() {
            reminderCheckBox.setTitle("✓", forState: .Normal)
        } else {
            reminderCheckBox.setTitle(" ", forState: .Normal)
        }
        
    }
    
    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}

