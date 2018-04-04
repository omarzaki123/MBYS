//
//  LiasonsViewController.swift
//  Company Profile
//
//  Created by Arjun Tambe on 9/20/16.
//  Copyright © 2016 Arjun Tambe. All rights reserved.
//

import Foundation

import UIKit

class LiasonsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var liasonsTable: UITableView!
        
    var liasonsArray: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        
        //placeholder data
        createPlaceholderData()

        
        liasonsTable.dataSource = self
        liasonsTable.delegate = self
        
        //used to set up cell reusing for the table view - creates one cell and reuses it to display the other cells
        self.liasonsTable.registerClass(LiasonsTableViewCell.self, forCellReuseIdentifier: "CellIdentifier")

        
        //configure size of the table by getting size of the screen
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, containerFrameHeight!, self.view.frame.width)
        
        liasonsTable.frame = CGRectMake(0, liasonsTable.frame.origin.y, self.view.frame.width, liasonsTable.contentSize.height);
        
    }
    
    
    func createPlaceholderData() {
        let user1 = User()
        user1.firstName = "Timmy"
        user1.lastName = "Turner"
        user1.company = "Cartoon Network"
        user1.position = "Student Ambassador"
        
        let user2 = User()
        user2.firstName = "Patrick"
        user2.lastName = "Star"
        user2.company = "Cartoon Network"
        user2.position = "Student Ambassador"

        
        let user3 = User()
        user3.firstName = "Tom N."
        user3.lastName = "Jerry"
        user3.company = "Cartoon Network"
        user3.position = "Student Ambassador"
        
        liasonsArray.append(user1)
        liasonsArray.append(user2)
        liasonsArray.append(user3)
    }
    
    
    
    //Number of entries in the table's one section - equal to number of events in the timelineEventsArray
    func tableView(tableView: UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return liasonsArray.count
    }
    
    //Sets some displays stuff
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //set background color
        cell.backgroundColor = tableBackgroundColor
        
        //set separator inset to 0 and prevent it from inheriting default margins from table view - separator inset is where the dividing lines between rows don't extend all the way to the left
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        cell.frame = CGRectMake(0, cell.frame.origin.y, tableView.frame.width, liasonsTableRowHeight)
    }

    
    //sets height of the table
    func tableView(tableView: UITableView,
                   heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexOfExpandedRowLiasons == indexPath.row) {
            //collapse the other cells when we are expanding one cell
//            collapseOtherCells()
            
            
            //calculate height of the row by creating a UILabel from the event description and determining how tall it will be
            return CGFloat (liasonsTableRowHeight + 10)
            
        } else {
            return CGFloat(liasonsTableRowHeight)
        }
    }

    
    //This method loops through all the cells in the table and configures them using the custom cell class CompanyTimelineTableViewCell. First, it calls the corresponding member of the timelineEventsArray; the information from this event is used to configure the cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        //gets the corresponding event from the array - the 1st cell gets the 1st array member, 2nd cell gets the 2nd array member, etc
        let user = liasonsArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("liasonCell") as! LiasonsTableViewCell
        
        //set various labels and image
        cell.setLabels(user.firstName, lastName: user.lastName, company: user.company, position: user.position)
        cell.setProfilePicture(UIImage(named:"default-image.png")!) //revise this so it gets the data for the profile image
        

        //tag the cell based on its row number so we can get reference to it later. shift up by 1 because 0 isn't a valid identifier
        cell.tag = indexPath.row + 1
        
        return cell
    }

    
}