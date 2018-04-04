//
//  tableOfEvents.swift
//  calendarUpdates
//
//  Created by Ariel Bong on 7/26/16.
//  Copyright © 2016 ArielBong. All rights reserved.
//

import Foundation
import UIKit

class tableOfEvents: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var eventTable: UITableView!
    //var events =
    let dateFormatter = NSDateFormatter()
    
   // let testSections = ["sec1", "sec2", "sec3"]
    //var testDate = Dictionary<String, Array<String>>()

    override func viewDidLoad() {
        print("in this bih")
        
        eventTable.dataSource = self
        eventTable.delegate = self
        
        //test arrays
        //testDate["sec1"] = ["1", "2", "3", "4"]
        //testDate["sec2"] = ["nine", "seven", "eight", "six"]
        //testDate["sec3"] = ["cypress", "sharon", "martin jr."]
        getUserEvents() {
            events in
            
        }
        
        super.viewDidLoad()
        
      
    }
    
    
    /*
     functions to implement datasource; so there's no need pass data in between this view controller and tableOfEvents
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //return the number of sections
         return orderedEventArray.sharedList.getArrayOfDates().count
        //return testSections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows; iterates through ordered dates and uses the key for the dictionary to get array; gets count from that array
        return orderedEventArray.sharedList.getDictionaryOfEvents()[orderedEventArray.sharedList.getArrayOfDates()[section]]!.count
        //return testDate[testSections[section]]!.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .NoStyle //style of date will be Nov. 21, 2007 w/ no time
        return dateFormatter.stringFromDate(orderedEventArray.sharedList.getArrayOfDates()[section])
        //return testSections[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("sectionCell", forIndexPath: indexPath)
        
        // Configure the cell...
         cell.textLabel?.text = orderedEventArray.sharedList.getDictionaryOfEvents()[orderedEventArray.sharedList.getArrayOfDates()[indexPath.section]]![indexPath.row].title
        //cell.textLabel?.text = testDate[testSections[indexPath.section]]![indexPath.row]
        return cell
    }

    
    
}
