//
//  orderedEventArray.swift
//  calendarUpdates
//
//  Created by Ariel Bong on 7/26/16.
//  Copyright © 2016 ArielBong. All rights reserved.
//

import Foundation
import UIKit


class orderedEventArray {
    
    //singleton because only one list needed
    static let sharedList = orderedEventArray()
    
    private let EVENTS_KEY = "events"
    
    private  var arrayOfDates: [NSDate]
    private var dictionaryOfEvents: Dictionary<NSDate, Array<Event>>
    let reminderActionCompleted = UIMutableUserNotificationAction()
    let reminderActionSnooze = UIMutableUserNotificationAction()
    let eventNotificationCategory = UIMutableUserNotificationCategory()
  
    private init() {
        arrayOfDates = []
        dictionaryOfEvents = [:]
        
        reminderActionCompleted.identifier = "Completed"
        reminderActionCompleted.title = "Completed"
        reminderActionCompleted.activationMode = UIUserNotificationActivationMode.Background
        reminderActionCompleted.destructive = false
        reminderActionCompleted.authenticationRequired = false
        
        
        //might change to postpone
        reminderActionSnooze.identifier = "Snooze"
        reminderActionSnooze.title = "Snooze"
        reminderActionSnooze.activationMode = UIUserNotificationActivationMode.Background
        reminderActionSnooze.destructive = true
        reminderActionSnooze.authenticationRequired = false
        
        eventNotificationCategory.identifier = "notificationCategory"
        eventNotificationCategory.setActions([reminderActionCompleted, reminderActionSnooze], forContext: UIUserNotificationActionContext.Default)
        eventNotificationCategory.setActions([reminderActionCompleted, reminderActionSnooze], forContext: UIUserNotificationActionContext.Minimal)

        
    }
    
    //adds event to dicitionary of events; will make it easier to list events in table
   /* func addEvent(newEvent: Event) {
        addDateToArray(newEvent.startDay)
        if dictionaryOfEvents[newEvent.startDay] == nil { // maybe add order later
            dictionaryOfEvents[newEvent.startDay] = [newEvent]
        } else {
            dictionaryOfEvents[newEvent.startDay]?.append(newEvent)
        }
        addNotification(newEvent)
    }*/
    
    //adds date to ordered array of dates
    func addDateToArray(date: NSDate) {
        
        for i in 0..<arrayOfDates.count {
            
            //checks if date is already in array
           if date.compare(arrayOfDates[i]) == .OrderedSame {
                return
                
            }
            //checks if the new date is older than the one in comparison(array index), if so,
            //insert in array at that spot
            else if date.compare(arrayOfDates[i]) == .OrderedAscending {
                arrayOfDates.insert(date, atIndex: i)
                return
            
            }
         
        }
         arrayOfDates.append(date)
    }
    
    //will be sections for tableOfEvents
    func getArrayOfDates() -> [NSDate] {
        return arrayOfDates
    }
    
    //will be data under sections - use the associated arrays
    func getDictionaryOfEvents() -> Dictionary<NSDate, Array<Event>> {
        return dictionaryOfEvents
    }
    
   /* func addNotification(newEvent: Event) {
        // persist a representation of this todo item in NSUserDefaults; have to do this in order for the local notification to stay after app is closed
        var eventDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(EVENTS_KEY) ?? Dictionary() // if todoItems hasn't been set in user defaults, initialize todoDictionary to an empty dictionary using nil-coalescing operator (??)
        eventDictionary[newEvent.getUUID()] = ["eventTime": newEvent.startTime, "title": newEvent.title, "UUID": newEvent.getUUID()] // store NSData representation of todo item in dictionary with UUID as key
        NSUserDefaults.standardUserDefaults().setObject(eventDictionary, forKey: EVENTS_KEY) // save/overwrite todo item list
        
        
        // create a corresponding local notification
        let notification = UILocalNotification()
        notification.alertBody = "Mesh Event: \"\(newEvent.title)\" " // text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = newEvent.startTime// event time (when notification will be fired)
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["title": newEvent.title, "UUID": newEvent.getUUID()] // assign a unique identifier to the notification so that we can retrieve it later
        notification.category = "notificationCategory"
        notification.applicationIconBadgeNumber += 1 //
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        
    }*/
    

   
   
}
