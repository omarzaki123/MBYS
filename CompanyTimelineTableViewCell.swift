//
//  CompanyTimelineTableViewCell.swift
//  Company Profile
//
//  Created by Arjun Tambe on 9/7/16.
//  Copyright © 2016 Arjun Tambe. All rights reserved.
//

import Foundation
import UIKit

class CompanyTimelineTableViewCell: UITableViewCell {
    
    //keeps track of whether the cell is currently expanded
    var isExpanded = false
    
    
    @IBOutlet var title: UILabel?
    @IBOutlet var date: UILabel?
    @IBOutlet var calendarButton: UIButton?
    var descriptionLabel: UILabel?
    var clockView: UIImageView?
    var durationLabel: UILabel?
    var addEventLabel: UIButton?
    
    @IBOutlet var expandContractButton: UIButton?
    
    
    var constrainCalendarBottomToDateBottom: NSLayoutConstraint?

    //Configures appearance of the event's title
    func setEventTitle(title: String) {
        self.title!.text = title
        self.title!.font = timelineEventTitleFont
        self.title!.textColor = titleTextColor
    }
    
    //handles display of various labels - the label for the date of the event, the time duration of the event that gets displayed when you expand the cell, and the "Add Event" label next to the calendar icon that appears when you expand the cell
    func setOtherLabels(startTime: NSDate, endTime: NSDate) {
        //date label
        self.date!.font = timelineEventDateFont
        self.date!.textColor = altTextColor
        self.date!.text = convertDate(startTime)
        
        //set height of the calendar icon
        self.addConstraint(NSLayoutConstraint(item: calendarButton!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: iconHeight))


        //duration label
        durationLabel = UILabel()
        durationLabel!.font = timelineEventDescriptionFont
        durationLabel!.text = convertDuration(startTime, end: endTime)
        durationLabel!.textColor = altTextColor
        
        //also add the label that says "Add Event" and programmatically connects it to the function that adds events
        addEventLabel = UIButton()
        addEventLabel!.setTitle("Add Event", forState: UIControlState.Normal)
        addEventLabel!.titleLabel!.font = timelineEventDescriptionFont
        addEventLabel!.setTitleColor(altTextColor, forState: UIControlState.Normal)
        addEventLabel!.addTarget(self, action: #selector(CompanyTimelineTableViewCell.addEvent), forControlEvents: .TouchUpInside)
        addEventLabel!.titleLabel!.sizeToFit()
        
        // create the clock image
        clockView = UIImageView()
        clockView!.image = UIImage(named: "icon calendar red")

        
        //finally, connect the calendar icon button to the addEvent action, and add constraint to it that aligns its bottom to the bottom of the date
        calendarButton!.addTarget(self, action: #selector(CompanyTimelineTableViewCell.addEvent), forControlEvents: .TouchUpInside)
        constrainCalendarBottomToDateBottom = NSLayoutConstraint(item: calendarButton!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: date, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        self.addConstraint(constrainCalendarBottomToDateBottom!)

    }
    
    //takes the start date and converts it to a string. first uses NSDateFormatter to automatically convert date to string form, then clips last 6 characters if the date's year is the current year
    func convertDate(startTime: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let startDateAsString = dateFormatter.stringFromDate(startTime)
        
        //get current year; if the date string ends with it we remove it
        let currentYear = NSCalendar.currentCalendar().components([.Day , .Month , .Year], fromDate: NSDate()).year
        if startDateAsString.hasSuffix(String(currentYear)) {
            return startDateAsString.substringToIndex(startDateAsString.endIndex.advancedBy(-6))
        } else {
            return startDateAsString
        }
    }
    
    //Converts a duration to the appropriate format - if the event is longer than 8 hrs, returns "All Day"; otherwise it returns the time interval in form "HH:MM - HH:MM"
    func convertDuration(start: NSDate, end: NSDate) -> String {
        let duration = NSTimeInterval(end.timeIntervalSinceDate(start))

        if (duration > 28800) {
            return "All Day"
        } else {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            let startTime = dateFormatter.stringFromDate(start)
            let endTime = dateFormatter.stringFromDate(end)
            
            return (startTime + " - " + endTime)
        }
    }
    
    
    //sets event description appearance
    func setEventDescription(description: String) {
        descriptionLabel = UILabel()
        descriptionLabel!.numberOfLines = 0
        descriptionLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
        descriptionLabel!.font = timelineEventDescriptionFont
        descriptionLabel!.text = description
        descriptionLabel!.textColor = altTextColor
        descriptionLabel!.sizeToFit()
    }
    
    
    //func that gets called when the calendar icon or "Add Event" is clicked - fill this in
    func addEvent() {
        print ("touched")
    }
    
    
    @IBAction func expandContract(sender: AnyObject!) {
        let tableView = getTableView()
        tableView.beginUpdates()

        if (!isExpanded) {
            expand(sender as! UIButton)
        } else {
            indexOfExpandedRow = -1
            collapse(sender as! UIButton)
        }
        tableView.endUpdates()
    }
    
    //gets the table view - In ios 6, tableview is a superview of cell; in ios 7, it's a superview of tableviewwrapper which is a superview of cell  - this code circumvents version checks

    func getTableView() -> UITableView {
        var view = self.superview
        while (!(view?.isKindOfClass(UITableView))!) {
            view = view?.superview
        }
        return (view as! UITableView)
    }
    
    
    //handles expansion of the cell
    func expand(button: UIButton) {
        //we shifted tags up by 1 to avoid tagging any cell as 0, so now we need to shift them back down
        indexOfExpandedRow = self.tag - 1
        button.setImage(UIImage(named: "icon collapse diag up"), forState: UIControlState.Normal)
        isExpanded = true
        putSubviews()
    }
    
    
    //This method handles configuration of the clock image, the duration label next to it, and the description label underneath it
    func putSubviews() {
        
        //add these to the frame
        self.contentView.addSubview(clockView!)
        self.contentView.addSubview(durationLabel!)
        self.contentView.addSubview(descriptionLabel!)
        self.contentView.addSubview(addEventLabel!)
        
        //allows the constraints below to override frame size constraints
        clockView!.translatesAutoresizingMaskIntoConstraints = false
        durationLabel!.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel!.translatesAutoresizingMaskIntoConstraints = false
        title!.translatesAutoresizingMaskIntoConstraints = false
        calendarButton!.translatesAutoresizingMaskIntoConstraints = false
        addEventLabel!.translatesAutoresizingMaskIntoConstraints = false
        
        //top of clock is 5 px below bottom of title
        self.contentView.addConstraint(NSLayoutConstraint(item: clockView!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: title, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 8.0))
        //clock's leading margin is 8 px to the right of the title's leading margin
        self.addConstraint(NSLayoutConstraint(item: clockView!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: title, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 8.0))
        //clock's aspect ratio is set to a square (width = height)
        self.addConstraint(NSLayoutConstraint(item: clockView!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: clockView, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
        //clock's size is iconHeight constant (currently 20 px)
        self.addConstraint(NSLayoutConstraint(item: clockView!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: iconHeight))

        
        //leading edge of duration label = trailing edge of clock image + 5px
        self.addConstraint(NSLayoutConstraint(item: durationLabel!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: clockView, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 5.0))
        //baseline of duration label = bottom of clock image
        self.addConstraint(NSLayoutConstraint(item: durationLabel!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: clockView, attribute: NSLayoutAttribute.Baseline, multiplier: 1.0, constant: 0))

        //top of description label is 2px below bottom of clock image
        self.addConstraint(NSLayoutConstraint(item: descriptionLabel!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: clockView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 2.0))
        //leading edge of description label is aligned with duration label's leading margin
        self.addConstraint(NSLayoutConstraint(item: descriptionLabel!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: durationLabel, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0))
        //description label's trailing edge = leading edge of the add event button
        self.addConstraint(NSLayoutConstraint(item: descriptionLabel!, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: calendarButton, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0))

        
        //since the calendar icon needs to move, add a constraint that fixes its position relative to expand button at the bottom and remove previous vertical position constraint
        self.removeConstraint(constrainCalendarBottomToDateBottom!)
        self.addConstraint(NSLayoutConstraint(item: calendarButton!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: expandContractButton, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: -6.0))
        //top of calendar button is 6 px below the bottom of the description
        self.addConstraint(NSLayoutConstraint(item: calendarButton!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: descriptionLabel!, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 6.0))

        
        
        //Add Event label button's trailing edge = leading edge of the add event button - 2px
        self.addConstraint(NSLayoutConstraint(item: addEventLabel!, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: calendarButton!, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: -3.0))
        
        //bottom of the add event label = bottom of add event button
        self.addConstraint(NSLayoutConstraint(item: addEventLabel!, attribute: NSLayoutAttribute.Baseline, relatedBy: NSLayoutRelation.Equal, toItem: calendarButton!, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -3.0))
        
    }
    
    //collapse the cell by removing the subviews we added when expanded and changing the corner button back to the downward diagonal icon
    func collapse(button: UIButton) {
        button.setImage(UIImage(named: "icon collapse diag down"), forState: UIControlState.Normal)
        isExpanded = false
        descriptionLabel!.removeFromSuperview()
        clockView!.removeFromSuperview()
        durationLabel!.removeFromSuperview()
        addEventLabel!.removeFromSuperview()
    }
    
    

}