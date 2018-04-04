//
//  TimelineViewController.swift
//  Company Profile
//
//  Created by Arjun Tambe on 9/7/16.
//  Copyright © 2016 Arjun Tambe. All rights reserved.
//

import Foundation
import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    
    @IBOutlet weak var eventTable: UITableView!
    
    var timelineEventsArray: [Event] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //placeholder data
        createPlaceholderData()
        
        eventTable.dataSource = self
        eventTable.delegate = self
        
        //used to set up cell reusing for the table view - creates one cell and reuses it to display the other cells
        self.eventTable.registerClass(CompanyTimelineTableViewCell.self, forCellReuseIdentifier: "CellIdentifier")

        //configure size of the table by getting size of the screen

        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, timelineContainerFrameHeight!, self.view.frame.width)
        
        eventTable.frame = CGRectMake(0, eventTable.frame.origin.y, self.view.frame.width, eventTable.contentSize.height);
        
    }
    
    //needs to be replaced with actual data
    func createPlaceholderData() {
        let event1 = Event()
        event1.title = "Lunch"
        event1.startTime = NSDate(timeIntervalSinceNow: 1000)
        event1.endTime = NSDate(timeIntervalSinceNow: 10000)
        event1.location = "My house"
        event1.description = "I will be eating a delicious meal. Blah abllakj alskjl  kj ajbalh alkj alkj flkjadlkjf asdf aldskfj aldskjf laksdj f;lkajs dfl;kaj sdlf;kj asfd"
        
        let event2 = Event()
        event2.title = "Dinner"
        event2.startTime = NSDate(timeIntervalSinceNow: 15000)
        event2.endTime = NSDate(timeIntervalSinceNow: 20000)
        event2.location = "Los Angeles"
        event2.description = "Scrumptious food. a;lkdj flkj alkj ad;lskfj ."

        let event3 = Event()
        event3.title = "Breakfast"
        event3.startTime = NSDate(timeIntervalSinceNow: 43000)
        event3.endTime = NSDate(timeIntervalSinceNow: 46000)
        event3.location = "My Car"
        event3.description = "The most important meal of the day."
        
        timelineEventsArray.append(event1)
        timelineEventsArray.append(event2)
        timelineEventsArray.append(event3)
    }
    
    
    //The methods below configure the table
    
    //Number of entries in the table's one section - equal to number of events in the timelineEventsArray
    func tableView(tableView: UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return timelineEventsArray.count
    }
    
    //Sets some displays stuff
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //set background color
        cell.backgroundColor = tableBackgroundColor
        
        //set separator inset to 0 and prevent it from inheriting default margins from table view - separator inset is where the dividing lines between rows don't extend all the way to the left
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        cell.frame = CGRectMake(0, cell.frame.origin.y, tableView.frame.width, timelineTableRowHeight)
        
    }
    
    
    //sets height of the table
    func tableView(tableView: UITableView,
                   heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexOfExpandedRow == indexPath.row) {
            //collapse the other cells when we are expanding one cell
            collapseOtherCells()
            //calculate height of the row by creating a UILabel from the event description and determining how tall it will be
            return CGFloat (getExpandedHeight(indexPath.row))

        } else {
            return CGFloat(timelineTableRowHeight)
        }
    }
    
    
    //loop through all the other indices in the array, use the index to get the cell with the corresponding tag (set below in tableView(cellForRowAtIndexPath), and then collapse that cell if it isn't the one we just expanded.
    func collapseOtherCells() {
        for i in 0..<timelineEventsArray.count {
            let cell = self.eventTable.viewWithTag(i + 1) as! CompanyTimelineTableViewCell

            if (i != indexOfExpandedRow) {
                cell.collapse(cell.expandContractButton!)
            }
        }
        
    }

    
    //Calculates the height of the cell when expanded. First creates the description label with the correct formatting and gets its height, then adds this to the height of the expand/contract corner button + the height of the calendar button to get the label's total height
    func getExpandedHeight(index: Int) -> CGFloat {
        let description = timelineEventsArray[index].description
        
        let descriptionLabel = UILabel(frame: CGRectMake(0, 0, 200, CGFloat.max))
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        descriptionLabel.font = timelineEventDescriptionFont
        descriptionLabel.text = description

        descriptionLabel.sizeToFit()
        
        //start with regular cell height; when expanded it adds the description, the clock icon, and shifts the calendar icon down so we need 2 * iconHeight
        return (timelineTableRowHeight + descriptionLabel.frame.height + (2 * iconHeight) + 15)
    }
    

    
    //This method loops through all the cells in the table and configures them using the custom cell class CompanyTimelineTableViewCell. First, it calls the corresponding member of the timelineEventsArray; the information from this event is used to configure the cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        //gets the corresponding event from the array - the 1st cell gets the 1st array member, 2nd cell gets the 2nd array member, etc
        let event = timelineEventsArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! CompanyTimelineTableViewCell
        
        //set various labels
        cell.setEventTitle(event.title)
        cell.setOtherLabels(event.startTime, endTime: event.endTime)
        cell.setEventDescription(event.description)
        
        //tag the cell based on its row number so we can get reference to it later. shift up by 1
        cell.tag = indexPath.row + 1
        
        return cell
    }

    
}