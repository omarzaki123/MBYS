//
//  Reminder.swift
//  Mesh
//
//  Created by Ariel Bong on 8/29/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import Foundation
import UIKit


class Reminder: NSObject, NSCoding {
    
    var contactName: String
    var affiliation: String
    var time: NSDate
    var UUID: String
    
    
    override init() {
        contactName = ""
        affiliation = ""
        time = NSDate()
        UUID = ""
    }
    
    func assignUUID() {
        
        self.UUID = NSUUID().UUIDString
    }
    
    // The following two methods are needed to save and load events for the current user in locally.
    // If you add a new variable above, make sure to add them in these two methods.
    
    required init(coder: NSCoder) {
        if let contactName = coder.decodeObjectForKey("contactName") as? String {
            self.contactName = contactName
        } else {
            self.contactName = ""
        }
        
        if let affiliation = coder.decodeObjectForKey("affiliation") as? String {
            self.affiliation = affiliation
        } else {
            self.affiliation = ""
        }
        
        if let time = coder.decodeObjectForKey("time") as? NSDate {
            self.time = time
        } else {
            self.time = NSDate()
        }
        
        if let UUID = coder.decodeObjectForKey("UUID") as? String {
            self.UUID = UUID
        } else {
            self.UUID = ""
        }
        
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.contactName, forKey: "contactName")
        coder.encodeObject(self.affiliation, forKey: "affiliation")
        coder.encodeObject(self.time, forKey: "time")
        coder.encodeObject(self.UUID, forKey: "UUID")
    }
}

/*
 REMINDER SETTINGS FUNCTIONS
 */
//Sets default initial reminder value
func setDefaultInitialReminder(initial: Int) {
    userDefaults.setInteger(initial, forKey: "defaultReminderValue")
}

//Sets default initial reminder units (weeks or months)
func setDefaultInitialReminderUnits(unit: Int) {
    
    userDefaults.setInteger(unit, forKey: "defaultReminderUnits")
}

//Sets number of periodic reminder values
func setPeriodicReminderValue(value: Int) {
    userDefaults.setInteger(value, forKey: "defaultPeriodicReminderValue")
}

//Set number of times a reminder is made
func setPeriodicReminderUnits(unit: Int) {
    
    userDefaults.setInteger(unit, forKey: "defaultPeriodicReminderUnits")
}

//Saves user decision to send reminder notifications
func setSendReminderNotificationsSetting(send: Bool) {
    userDefaults.setBool(send, forKey: "sendReminderNotifications")
}

//Gets default initial reminder value
func getDefaultInitialReminder() -> Int {
    
    return userDefaults.integerForKey("defaultReminderValue")
}

//Gets default initial reminder units (0 = days or 1 = weeks)
func getDefaultInitialReminderUnits() -> Int{
    return userDefaults.integerForKey("defaultReminderUnits")
    
}

//Gets number of periodic reminder value
func getPeriodicReminderValue() -> Int {
    
    return userDefaults.integerForKey("defaultPeriodicReminderValue")
}

//Get number of times a reminder is made (0 = weeks or 1 = months)
func getPeriodicReminderUnits() -> Int {
    
    return userDefaults.integerForKey("defaultPeriodicReminderUnits")
    
}

//Gets user decision to send reminder notifications
func getSendReminderNotificationsSetting() -> Bool {
    return userDefaults.boolForKey("sendReminderNotifications")
}