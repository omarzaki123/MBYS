//
//  Event.swift
//  Mesh
//
//  Created by Paa Adu on 8/2/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import Foundation
import UIKit

class Event: NSObject, NSCoding {
    var title: String
    var startTime: NSDate
    var endTime: NSDate
    var postedTime: NSDate // when the event was posted by a company
    var location: String
    var eventDescription: String
    var company: String
    var UUID: String
    var hasImage: Bool?
    
    override init() {
        self.title = ""
        startTime = NSDate()
        endTime = NSDate()
        postedTime = NSDate()
        location = ""
        eventDescription = ""
        company = ""
        UUID = ""
    }

    func assignUUID() {
        
        self.UUID = NSUUID().UUIDString
    }
    
    // The following two methods are needed to save and load events for the current user in locally.
    // If you add a new variable above, make sure to add them in these two methods.
    
    required init(coder: NSCoder) {
        if let title = coder.decodeObjectForKey("title") as? String {
            self.title = title
        } else {
            self.title = ""
        }
        
        if let startTime = coder.decodeObjectForKey("startTime") as? NSDate {
            self.startTime = startTime
        } else {
            self.startTime = NSDate()
        }
        
        if let endTime = coder.decodeObjectForKey("endTime") as? NSDate {
            self.endTime = endTime
        } else {
            self.endTime = NSDate()
        }
        
        if let postedTime = coder.decodeObjectForKey("postedTime") as? NSDate {
            self.postedTime = postedTime
        } else {
            self.postedTime = NSDate()
        }
        
        if let location = coder.decodeObjectForKey("location") as? String {
            self.location = location
        } else {
            self.location = ""
        }
        
        if let eventDescription = coder.decodeObjectForKey("eventDescription") as? String {
            self.eventDescription = eventDescription
        } else {
            self.eventDescription = ""
        }
        
        if let company = coder.decodeObjectForKey("company") as? String {
            self.company = company
        } else {
            self.company = ""
        }
        
        if let UUID = coder.decodeObjectForKey("UUID") as? String {
            self.UUID = UUID
        } else {
            self.UUID = ""
        }
        
        if let hasImage = coder.decodeObjectForKey("hasImage") as! Bool? {
            self.hasImage = hasImage
        } else {
            self.hasImage = nil
        }
        
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.title, forKey: "title")
        coder.encodeObject(self.startTime, forKey: "startTime")
        coder.encodeObject(self.endTime, forKey: "endTime")
        coder.encodeObject(self.postedTime, forKey: "postedTime")
        coder.encodeObject(self.location, forKey: "location")
        coder.encodeObject(self.eventDescription, forKey: "description")
        coder.encodeObject(self.company, forKey: "company")
        coder.encodeObject(self.UUID, forKey: "UUID")
        coder.encodeObject(self.hasImage, forKey: "hasImage")
    }

}

class EventWithImage: Event {
    
    var image: UIImage
    
    override init() {
        self.image = UIImage()
        super.init()
        self.hasImage = true
    }
    
    required init(coder: NSCoder) {
        if let image = coder.decodeObjectForKey("image") as? UIImage {
            self.image = image
        } else {
            self.image = UIImage()
        }
        
        super.init(coder: coder)
    }
    
    
    
    override func encodeWithCoder(coder: NSCoder) {
        
        coder.encodeObject(self.hasImage, forKey: "hasImage")
        coder.encodeObject(self.image, forKey: "image")
        
        
    }
    
}

/*
 EVENT SETTINGS FUNCTIONS
 */

//Sets number of periodic reminder values
func setDefaultEventReminderValue(value: Int) {
    userDefaults.setInteger(value, forKey: "defaultEventReminderValue")
}

//Set number of times a reminder is made (Hours and Weeks)
func setDefaultEventReminderUnits(unit: Int) {
    
    userDefaults.setInteger(unit, forKey: "defaultEventReminderUnits")
}

//Saves user decision to send reminders for all events
func setRemindersForAllEventsSetting(send: Bool) {
    userDefaults.setBool(send, forKey: "sendRemindersForAllEvents")
}

//Gets number of periodic reminder values
func getDefaultEventReminderValue() -> Int {
    return userDefaults.integerForKey("defaultEventReminderValue")
}

//Get number of times a reminder is made (Hours and Weeks)
func getDefaultEventReminderUnits() -> Int {
    
    return userDefaults.integerForKey("defaultEventReminderUnits")
}

//Gets user decision to send reminders for all events
func getRemindersForAllEventsSetting()-> Bool {
    return userDefaults.boolForKey("sendRemindersForAllEvents")
}