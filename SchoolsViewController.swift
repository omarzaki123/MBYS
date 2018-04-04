//
//  SchoolsViewController.swift
//  schoolsTest
//
//  Created by Ariel Bong on 8/16/16.
//  Copyright © 2016 ArielBong. All rights reserved.
//

import UIKit

class SchoolsViewController: UITableViewController, UISearchResultsUpdating {
    
    var allSchools: [String] = []
    var filteredSchools = [String]()
    var tempPost: tempTextPost?
    var imagePost: tempImagePost?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet var schoolsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        schoolsTable.tableHeaderView = searchController.searchBar
        
        loadSchools()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadSchools() {
        if let path = NSBundle.mainBundle().pathForResource("us_universities", ofType: "txt") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe)
                        loadJsonData(jsonData)  {jsonResults in
                            let schools: [[String:AnyObject]] = jsonResults
                            for school: [String:AnyObject] in schools {
                                self.allSchools.append(school["name"] as! String)
                            }
                        }
                    schoolsTable.reloadData()
                 }
                
             catch {
            
              print("Fetch failed: \((error as NSError).localizedDescription)")
            }
        }
     
    }
    
    func loadJsonData(data: NSData, callback: ([[String:AnyObject]]) -> Void ) {
       
        do {
            if let result = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [[String:AnyObject]] {
                callback(result)
            }
        } catch let error {
            print(error)
        }
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredSchools.count
        }
        return allSchools.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("schoolCell")! as UITableViewCell
        let school: String
        if searchController.active && searchController.searchBar.text != "" {
            school = filteredSchools[indexPath.row]
        } else {
            school = allSchools[indexPath.row]
        }
        cell.textLabel?.text = school
        
        return cell
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredSchools = allSchools.filter { school in
            return school.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       let schoolIndex = schoolsTable.indexPathForSelectedRow?.row
        
        if segue.identifier == "schoolTableToSetup",
        let destination = segue.destinationViewController as? SetupProfileViewController
        {
            if filteredSchools == [] {
                currentUser.school = allSchools[schoolIndex!]
            } else {
                currentUser.school = filteredSchools[schoolIndex!]
            }
            currentUser.save()
        }
        
        if segue.identifier == "backToTextPost"{
            if filteredSchools == [] {
                tempPost!.school = allSchools[schoolIndex!]
            } else {
                tempPost!.school = filteredSchools[schoolIndex!]
            }
            
            let displayVC = segue.destinationViewController as! newTextViewController
            displayVC.tempPost = tempPost
        }
        
        if segue.identifier == "backToImagePost"{
            if filteredSchools == [] {
                imagePost!.school = allSchools[schoolIndex!]
            } else {
                imagePost!.school = filteredSchools[schoolIndex!]
            }
            
            let displayVC = segue.destinationViewController as! newImagePostViewController
            displayVC.tempPost = imagePost
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}