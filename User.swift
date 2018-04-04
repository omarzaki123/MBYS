//
//  User.swift
//  Mesh
//
//  Created by Paa Adu on 8/2/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import Foundation
import UIKit

var currentUser = User()

class User: NSObject, NSCoding {
    var primaryEmail: String //for their account
    var userId: String
    var firstName: String
    var lastName: String
    var secondaryEmail: String //school or company email/where they want to be contacted
    var company: String
    var school: String
    var position: String
    var phoneNumber: String
    var favorites: [String]
    var profilePicture: UIImage?
    var resume: NSData?
    var connections: [User]
    var events: [Event]
    var reminders: [Reminder]
    
    override init() {
        primaryEmail = ""
        userId = ""
        firstName = "";
        lastName = "";
        secondaryEmail = "";
        company = "";
        school = "";
        position = "";
        phoneNumber = "";
        favorites = []
        connections = []
        events = []
        reminders = []
    }
    
    func assignUserId() {
        self.userId = NSUUID().UUIDString
    }
    
    // Saves information about the current user locally.
    // Call this function after changes have been made to currentUser
    func save() {
        let data  = NSKeyedArchiver.archivedDataWithRootObject(currentUser)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(data, forKey:"currentUser")
    }
    
    // Load the current user. This called only when the app starts.

    static func loadCurrentUser() {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("currentUser") as? NSData {
            currentUser = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! User
        } else {
            currentUser = User()
        }
    }

    // The following two methods are needed to save and load the current user in AppDelagate.
    // If you add a new variable above, make sure to add them in these two methods. 
    
    required init(coder: NSCoder) {
        if let primaryEmail = coder.decodeObjectForKey("primaryEmail") as? String {
            self.primaryEmail = primaryEmail
        } else {
            self.primaryEmail = ""
        }
        
        if let userId = coder.decodeObjectForKey("userId") as? String {
            self.userId = userId
        } else {
            self.userId = ""
        }
        
        if let firstName = coder.decodeObjectForKey("firstName") as? String {
            self.firstName = firstName
        } else {
            self.firstName = ""
        }
        
        if let lastName = coder.decodeObjectForKey("lastName") as? String {
            self.lastName = lastName
        } else {
            self.lastName = ""
        }
        
        if let secondaryEmail = coder.decodeObjectForKey("secondaryEmail") as? String {
            self.secondaryEmail = secondaryEmail
        } else {
            self.secondaryEmail = ""
        }
        
        if let company = coder.decodeObjectForKey("company") as? String {
            self.company = company
        } else {
            self.company = ""
        }
        
        if let school = coder.decodeObjectForKey("school") as? String {
            self.school = school
        } else {
            self.school = ""
        }
        
        if let position = coder.decodeObjectForKey("position") as? String {
            self.position = position
        } else {
            self.position = ""
        }
        
        if let phoneNumber = coder.decodeObjectForKey("phoneNumber") as? String {
            self.phoneNumber = phoneNumber
        } else {
            self.phoneNumber = ""
        }
        
        if let favorites = coder.decodeObjectForKey("favorites") as? [String] {
            self.favorites = favorites
        } else {
            self.favorites = []
        }
        
        if let profilePicture = coder.decodeObjectForKey("profilePicture") as? UIImage? {
            self.profilePicture = profilePicture
        }
        
        if let resume = coder.decodeObjectForKey("resume") as? NSData? {
            self.resume = resume
        }
        
        if let connections = coder.decodeObjectForKey("connections") as? [User] {
            self.connections = connections
        } else {
            self.connections = []
        }
        
        if let events = coder.decodeObjectForKey("events") as? [Event] {
            self.events = events
        } else {
            self.events = []
        }
        
        if let reminders = coder.decodeObjectForKey("reminders") as? [Reminder] {
            self.reminders = reminders
        } else {
            self.reminders = []
        }

    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.primaryEmail, forKey: "primaryEmail")
        coder.encodeObject(self.userId, forKey: "userId")
        coder.encodeObject(self.firstName, forKey: "firstName")
        coder.encodeObject(self.lastName, forKey: "lastName")
        coder.encodeObject(self.secondaryEmail, forKey: "secondaryEmail")
        coder.encodeObject(self.company, forKey: "company")
        coder.encodeObject(self.school, forKey: "school")
        coder.encodeObject(self.position, forKey: "position")
        coder.encodeObject(self.phoneNumber, forKey: "phoneNumber")
        coder.encodeObject(self.favorites, forKey: "favorites")
        coder.encodeObject(self.profilePicture, forKey: "profilePicture")
        coder.encodeObject(self.resume, forKey: "resume")
        coder.encodeObject(self.connections, forKey: "connections")
        coder.encodeObject(self.events, forKey: "events")
        coder.encodeObject(self.reminders, forKey: "reminders")
    }
    
}