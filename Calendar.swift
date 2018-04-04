//
//  ViewController.swift
//  calendarUpdates
//
//  Created by Ariel Bong on 7/20/16.
//  Copyright © 2016 ArielBong. All rights reserved.
//

import UIKit
import FSCalendar
import Foundation
import EventKit

protocol calendarDelegate {
    func presentAddEventVC()
}

class Calendar: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UIPopoverPresentationControllerDelegate {
    
    
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var addEventButton: UIButton!
    var delegate: calendarDelegate?
    
    //let addEventVC = UIStoryboard(name: "NewEvent", bundle: nil).instantiateViewControllerWithIdentifier("NewEvent") as! NewEvent
    
    var selectedDate = NSDate()
    
    let eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.scrollDirection = .Vertical
        // Do any additional setup after loading the view, typically from a nib.
        
        eventStore.requestAccessToEntityType(EKEntityType.Reminder,
                                             completion: {(granted, error) in
                                                if !granted {
                                                    print("Access to store not granted")
                                                }
                                                
        })
        calendar.appearance.headerTitleColor = UIColor.redColor()
        calendar.appearance.weekdayTextColor = UIColor.redColor()
        selectedDate = NSDate()
       // print(selectedDate)
        
        //adds event icon on that date
        for event in currentUser.events {
            calendar(calendar, hasEventForDate: event.startTime)
            calendar.reloadData()
        }
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        masterPageIdentificationNum = 2
        
        let cell0 = bigRedCollectionView.collectionView!.cellForItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        
        let cell1 = bigRedCollectionView.collectionView!.cellForItemAtIndexPath(NSIndexPath(forRow: 1, inSection: 0))
        
        let cell2 = bigRedCollectionView.collectionView!.cellForItemAtIndexPath(NSIndexPath(forRow: 2, inSection: 0))
        
        cell0?.contentView.backgroundColor = UIColor.meshRed()
        
        cell1?.contentView.backgroundColor = UIColor.meshRed()
        
        cell2?.contentView.backgroundColor = UIColor.lightGrayColor()

        
        barNameLabel.text = "Calendar"
        
        //        UIView.animateWithDuration(0.3, animations: {
        //            cornerQuickAccessButton.alpha = 0.5
        //        })
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    //autolayout
    
    //func calendar(calendar: FSCalendar, boundingRectWillChange bounds: CGRect ,  animated animated: Bool ) {
    
    func minimumDateForCalendar(calendar: FSCalendar) -> NSDate {
        return calendar.dateWithYear(2016, month: 1, day: 1)
    }
   
    func maximumDateForCalendar(calendar: FSCalendar) -> NSDate {
        return calendar.dateWithYear(2020, month: 12, day: 31)
    }
    
    func calendar(calendar: FSCalendar, didSelectDate date: NSDate) {
        NSLog("calendar did select date \(calendar.stringFromDate(date))")
       
    }
    
    func calendarCurrentPageDidChange(calendar: FSCalendar) {
        NSLog("change page to \(calendar.stringFromDate(calendar.currentPage))")
    }
 
    //func calendar(calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
       // calendarHeightConstraint.constant = bounds.height
        //view.layoutIfNeeded()
    //}
    
 /*   @IBAction func addEvent(sender: AnyObject) {
        let reminder = EKReminder(eventStore: self.eventStore)
        
        //reminder.title = "Go to the store and buy milk"
       
        //var error: NSError?
  
        try! eventStore.saveReminder(reminder, commit: true)
       
        addAlarm(reminder)
    }
    
    func addAlarm(reminder: EKReminder) {
        let alarm = EKAlarm()
        alarm.relativeOffset = 5
       // selectedDate.dateByAddingTimeInterval(<#T##ti: NSTimeInterval##NSTimeInterval#>)
        reminder.addAlarm(alarm)
    
    }*/
    

    //places a
    func calendar(calendar: FSCalendar, hasEventForDate date: NSDate) -> Bool {
        return true
    }
    
 
    
   /* override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if segue.identifier == "toAddEvent" {
            print("also in this bi")
            if calendar.selectedDates.count != 0 {
                selectedDate = calendar.selectedDates[0] as! NSDate
                print(selectedDate)
            }
            let addEventVC = segue.destinationViewController //as? addEvents
           // addEventVC!.startingDate = selectedDate
        }

    }*/
    
    @IBAction func addEventSegue(sender: AnyObject) {
        
        //addEventVC.modalPresentationStyle = .Popover
        if calendar.selectedDates.count != 0 {
            selectedDate = calendar.selectedDates[0] as! NSDate
            print(selectedDate)
        }
        //addEventVC.eventDate.text = dateToString()
        //addEventVC.preferredContentSize = CGSize(width: 400, height: 400)
        
        //let popUp = addEventVC.popoverPresentationController
        
        if calendar.selectedDates.count != 0 {
            selectedDate = calendar.selectedDates[0] as! NSDate
            print(selectedDate)
        }
        addEventVC.startingDate = selectedDate
        //popUp?.sourceView = self.view
       // popUp!.delegate = self
    
        /*popUp?.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds),0,0)
        popUp?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0*/
        //self.presentViewController(addEventVC, animated: true, completion: nil)  //*****
        delegate!.presentAddEventVC()
    }
    
    func dateToString() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        return dateFormatter.stringFromDate(selectedDate)
    }
    
   /**func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle { 
        // Return no adaptive presentation style, use default presentation behaviour
        return .None
    }
    **/

}

