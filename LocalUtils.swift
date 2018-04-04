//
//  LocalUtils.swift
//  Mesh
//
//  Created by Ariel Bong on 8/29/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

private let EVENTS_KEY = "mesh_events"
private let REMINDERS_KEY = "mesh_reminders"
let userDefaults = NSUserDefaults.standardUserDefaults()
let reminderActionCompleted = UIMutableUserNotificationAction()
let reminderActionSnooze = UIMutableUserNotificationAction()
let eventNotificationCategory = UIMutableUserNotificationCategory()

func addLocalNotification(newEvent: Event) { //*****
    // persist a representation of this todo item in NSUserDefaults; have to do this in order for the local notification to stay after app is closed
    var eventDictionary = userDefaults.dictionaryForKey(EVENTS_KEY) ?? Dictionary() // if todoItems hasn't been set in user defaults, initialize todoDictionary to an empty dictionary using nil-coalescing operator (??)
    eventDictionary[newEvent.UUID] = ["eventTime": newEvent.startTime, "title": newEvent.title, "UUID": newEvent.UUID, "description": newEvent.description] // store NSData representation of todo item in dictionary with UUID as key
    userDefaults.setObject(eventDictionary, forKey: EVENTS_KEY) // save/overwrite todo item list
    
    
    // create a corresponding local notification
    let notification = UILocalNotification()
    initNotificationSpecs()
    notification.alertBody = "Event: \(newEvent.title) " // text that will be displayed in the notification
    notification.alertAction = "Open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
    notification.fireDate = newEvent.startTime// event time (when notification will be fired)
    notification.soundName = UILocalNotificationDefaultSoundName // play default sound
    notification.userInfo = ["title": newEvent.title, "UUID": newEvent.UUID] // assign a unique identifier to the notification so that we can retrieve it later
    notification.alertLaunchImage = "mesh logo small"
    notification.category = "notificationCategory"
    notification.applicationIconBadgeNumber += 1 //
    
    UIApplication.sharedApplication().scheduleLocalNotification(notification)
    
    
}

func addLocalNotification(newReminder: Reminder) { //*****
    // persist a representation of this todo item in NSUserDefaults; have to do this in order for the local notification to stay after app is closed
    var eventDictionary = userDefaults.dictionaryForKey(REMINDERS_KEY) ?? Dictionary() // if todoItems hasn't been set in user defaults, initialize todoDictionary to an empty dictionary using nil-coalescing operator (??)
    eventDictionary[newReminder.UUID] = ["eventTime": newReminder.time, "affiliation": newReminder.affiliation, "UUID": newReminder.UUID] // store NSData representation of todo item in dictionary with UUID as key
    userDefaults.setObject(eventDictionary, forKey: REMINDERS_KEY) // save/overwrite todo item list
    
    
    // create a corresponding local notification
    let notification = UILocalNotification()
    initNotificationSpecs()
    notification.alertBody = "Reminder: Meeting with \(newReminder.contactName)" //(newReminder.affiliation) " // text that will be displayed in the notification
    notification.alertAction = "Open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
    notification.fireDate = newReminder.time// event time (when notification will be fired)
    notification.soundName = UILocalNotificationDefaultSoundName // play default sound
    //notification.userInfo = ["title": newReminder.title, "UUID": newReminder.UUID] // assign a unique identifier to the notification so that we can retrieve it later
    notification.category = "notificationCategory"
    notification.alertLaunchImage = "mesh logo small"
    notification.applicationIconBadgeNumber += 1//
    
    UIApplication.sharedApplication().scheduleLocalNotification(notification)
    
    
}

func initNotificationSpecs() {
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


/*
    NOTIFICATION SETTINGS; pretty much self explanatory
 */

func setSendNotificationSetting(send: Bool) {
     userDefaults.setBool(send, forKey: "sendNotifications")
}

func setVibrationSetting(send: Bool) {
    userDefaults.setBool(send, forKey: "vibrationSetting")
}

func setSoundSetting(send: Bool) {
    userDefaults.setBool(send, forKey: "soundSetting")
}

func getSendNotificationSetting() -> Bool {
    return userDefaults.boolForKey("sendNotifications")
}

func getVibrationSetting() -> Bool {
    return userDefaults.boolForKey("vibrationSetting")
}

func getSoundSetting() -> Bool {
    return userDefaults.boolForKey("soundSetting")
}


func initializeSettingDefaults() {
    let initialDefaults: NSDictionary = ["defaultReminderValue": 2,
                                         "defaultReminderUnits": 0,
                                         "defaultPeriodicReminderValue": 2,
                                         "defaultPeriodicReminderUnits": 0, //0 = weeks, 1 month
                                         "sendReminderNotifications": true,
                                         "defaultEventReminderValue": 1,
                                         "defaultEventReminderUnits": 0, //0 = hours; maybe change in later version to hours and
                                         "sendRemindersForAllEvents": true,
                                         "sendNotifications": true,
                                         "vibrationSetting": true,
                                         "soundSetting": true]
    userDefaults.registerDefaults(initialDefaults as! [String : AnyObject])
}

//TEMP STRUCTS FOR IN BETWEEN SEGUES

struct tempTextPost {
    var title: String
    var text: String
    var school: String
    
}

struct tempImagePost {
    var title: String
    var text: String
    var school: String 
    var image: UIImage
}


