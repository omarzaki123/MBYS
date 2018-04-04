//
//  ViewController.swift
//  manageSharing
//
//  Created by Akash Wadawadigi on 8/31/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit
import Foundation

class manageSharingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableOfSharedDocs: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Setting background color
        self.view.backgroundColor = UIColor(red: 248/255, green: 40/255, blue: 54/255, alpha: 0.85)

        
        tableOfSharedDocs.dataSource = self
        tableOfSharedDocs.delegate = self
        
        tableOfSharedDocs.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //set number of sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //sets number of rows in sections
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1//array of reminders.count
    }
    
    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell: documentCell! = tableOfSharedDocs.dequeueReusableCellWithIdentifier("DocumentCell") as? documentCell
        
        //Fill in the following statements to correctly populate each document cell with its corresponding information
//        cell.documentAddDate.text = ""
//        cell.documentTitle.text = ""
//        cell.sharedWithCount.text = ""
        
        //In the future, we can even post screenshot previews of the document instead of using that generic resume image
        //cell.documentImage.image = ""
        
        //To make the button rounded
        cell.editSharingButton.layer.cornerRadius = 5
        
        return cell
    }




}

