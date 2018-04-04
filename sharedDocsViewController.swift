//
//  ViewController.swift
//  viewSharedDocs
//
//  Created by Akash Wadawadigi on 8/31/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit
import Foundation

class sharedDocsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {


    
    @IBOutlet weak var tableOfUserDocs: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Setting background color
        self.view.backgroundColor = UIColor(red: 248/255, green: 40/255, blue: 54/255, alpha: 0.85)
        
        tableOfUserDocs.dataSource = self
        tableOfUserDocs.delegate = self
        
        tableOfUserDocs.tableFooterView = UIView()
        

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
        return 1//array of documents.count
    }
    
    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell: sharedDocsCell! = tableOfUserDocs.dequeueReusableCellWithIdentifier("SharedDocsCell") as? sharedDocsCell
        
        //Fill in the following statements to correctly populate each document cell with its corresponding information
        
        //        cell.sharedDate.text = ""
        //        cell.documentTitle.text = ""
        
        //In the future, we can even post screenshot previews of the document instead of using that generic resume image
        //cell.documentImage.image = ""
        
        
        return cell
    }



}

