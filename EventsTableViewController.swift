//
//  ViewController.swift
//  MeshReminders
//
//  Created by Akash Wadawadigi on 8/27/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit
import Foundation

class Events: UIViewController,UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {

    
    
    
    @IBOutlet weak var eventTable: UITableView!
    var eventsArray: [Event] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting background color
        self.view.backgroundColor = UIColor(red: 248/255, green: 40/255, blue: 54/255, alpha: 0.85)
        
        eventTable.dataSource = self
        eventTable.delegate = self
        
        eventTable.tableFooterView = UIView()
        
        self.eventTable.addSubview(self.refreshControl)
        
        eventsArray = currentUser.events //userEvents
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //set number of sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1// eventsArray.count
    }
    
    //sets number of rows in sections
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArray.count
    }
    
    
    //sets all the rows to the names of the array (nearbyUserNames)
    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell: reminderCell! = eventTable.dequeueReusableCellWithIdentifier("EventCell") as? reminderCell
        
        let currentEvent = currentUser.events[indexPath.row]

      
        
        //Access the elements of the array that holds the contact name
         cell.contactName.text = currentEvent.title //***rename cell contact name to title
        
        //Access the element of the array that holds the contact's affiliation
        cell.reminderAffiliation.text = currentEvent.company
        
        //Access the element of the array that holds the date of meeting
        cell.reminderDate.text = returnDateFormat(.Day, date: currentEvent.startTime)
        
        //Access the element of the array that holds the time of the meeting
        cell.reminderTime.text = returnDateFormat(.Hour, date: currentEvent.startTime)
        
        //Access location
        cell.reminderLocation.text = currentEvent.location
        
        return cell
    }
    
    lazy var refreshControl: UIRefreshControl = {
     let refreshControl = UIRefreshControl()
     refreshControl.addTarget(self, action: #selector(Events.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
     
     return refreshControl
     }()
    
    //Controls what happens when table is refreshed; simply reloads data
    func handleRefresh(refreshControl: UIRefreshControl) {
     // Do some reloading of data and update the table view's data source
     // Fetch more objects from a web service, for example...
        
     
     // Simply adding an object to the data source for this example
        getUserEvents() {
            events in
            currentUser.events = events
            self.eventsArray = events
            self.eventTable.reloadData()
            currentUser.save()
            refreshControl.endRefreshing()
        }
        
     }
    
    func returnDateFormat(typeOfDate: NSCalendarUnit, date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        if(typeOfDate == .Day) {
            dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
            return dateFormatter.stringFromDate(date)
        } else if (typeOfDate == .Hour) {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.stringFromDate(date)
        }
        
        return ""
        
    }

    //Function that segues to screen with the reminder settings
    @IBAction func eventsSettingsCalled(sender: AnyObject) {
        calendarSettingsVC.modalPresentationStyle = .Popover
        calendarSettingsVC.preferredContentSize = CGSize(width: 400, height: 400)
        let popup = calendarSettingsVC.popoverPresentationController
        popup?.sourceView = self.view
        popup?.delegate = self //*****
        //masterView.view.bringSubviewToFront(addContactPopUp.view)
        popup?.sourceRect = CGRectMake(0, 0, 50, 50)
        popup?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        self.presentViewController(calendarSettingsVC, animated: true, completion: nil)
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            deleteEvent(eventsArray[indexPath.row])
            eventsArray.removeAtIndex(indexPath.row)
            currentUser.events.removeAtIndex(indexPath.row)
            eventTable.reloadData()
            currentUser.save()
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle { //*****
        // Return no adaptive presentation style, use default presentation behaviour
        return .None
    }
}



