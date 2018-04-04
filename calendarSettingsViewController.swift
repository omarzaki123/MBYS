//
//  ViewController.swift
//  calendarSettings
//
//  Created by Akash Wadawadigi on 8/30/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class calendarSettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Setting background color
        self.view.backgroundColor = UIColor(red: 248/255, green: 40/255, blue: 54/255, alpha: 0.85)
        
        setupLocalSettings()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(calendarSettingsViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveCalendarSettings(sender: AnyObject) {
        if(setRemindersCheckButton.titleLabel!.text == "✓"){
            setRemindersForAllEventsSetting(true)
        } else if (setRemindersCheckButton.titleLabel!.text == " "){
            setRemindersForAllEventsSetting(false)
        }
        setDefaultEventReminderUnits(defaultReminderUnits.selectedSegmentIndex)
        
        var defaultReminderInt: Int
        if numberForDefaultReminder.text != nil {
            defaultReminderInt = Int(numberForDefaultReminder.text!)!
        } else {
            defaultReminderInt = getDefaultEventReminderUnits()
        }
        setDefaultEventReminderUnits(defaultReminderInt)
        userDefaults.synchronize()
    }
    @IBOutlet weak var saveSettings: UIButton!
    @IBAction func setRemindersCheckBox(sender: AnyObject) {
        if(sender.titleLabel?!.text == "✓"){
            sender.setTitle(" ", forState: .Normal)
        } else if (sender.titleLabel?!.text == " "){
            sender.setTitle("✓", forState: .Normal)
        }
    }
    @IBOutlet weak var setRemindersCheckButton: UIButton!
    @IBOutlet weak var numberForDefaultReminder: UITextField!

    @IBOutlet weak var defaultReminderUnits: UISegmentedControl!
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func setupLocalSettings() {
        numberForDefaultReminder.text = String(getDefaultEventReminderValue())
      defaultReminderUnits.selectedSegmentIndex = getDefaultEventReminderUnits()
        if getRemindersForAllEventsSetting() {
            setRemindersCheckButton.setTitle("✓", forState: .Normal)
        } else {
            setRemindersCheckButton.setTitle(" ", forState: .Normal)
        }
    }
}

