
//
//  ViewController.swift
//  MeshSettings
//
//  Created by Akash Wadawadigi on 8/15/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit
import Foundation

class Settings: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var settingsOptions: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Gives User the option to exit Settings
        makeGoBackOption()
        
        settingsOptions.dataSource = self
        settingsOptions.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Only need 1 section
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //Array of Titles for cells in settings tab
    var settingsOpts = ["Account Settings", "Change Account Email", "Add Secondary Email", "Change Password", "Verify Student Email", "Advanced", "Notification Settings", "Information", "Support", "Terms of Service", "Logout"]
    

    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.Value1, reuseIdentifier:"SettingOpt")
        
        let isSectionHeader = indexPath.row
        
        //We want the headers to be in red and the subheaders to be in grey
        if(isSectionHeader == 0 || isSectionHeader == 5 || isSectionHeader == 7 || isSectionHeader == 10){
            cell.backgroundColor = UIColor(red: 248/255, green: 40/255, blue: 54/255, alpha: 0.85)
            cell.textLabel?.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        } else {
            cell.backgroundColor = UIColor(red: 147/255, green: 149/255, blue: 152/255, alpha: 0.35)
        }
  
        //Populating text fields
        cell.textLabel?.text = settingsOpts[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Calibri", size: 17)
        //Need to change the font
        
        return cell
    }
    
    //sets number of rows in sections
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsOpts.count
    }
    
    func makeGoBackOption() {
        let frame = self.view.frame
        let settingsLogoButton = UIButton(frame: CGRectMake(floor(frame.width/2) - 15, 20, 30, 30))
        settingsLogoButton.setImage(UIImage(named: "mesh logo login"), forState: UIControlState.Normal)
        settingsLogoButton.addTarget(self, action: #selector(goBack), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(settingsLogoButton)
    }
    
    func goBack(){
        settingsPage.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func popUpVC(settingChange: String) {
        let VC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewControllerWithIdentifier(settingChange)
        VC.modalPresentationStyle = .Popover
        VC.preferredContentSize = CGSize(width: 400, height: 300)
        let popUp = VC.popoverPresentationController
        popUp?.sourceView = self.view
        popUp?.delegate = self //*****
        //masterView.view.bringSubviewToFront(addContactPopUp.view)
        popUp?.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds),0,0)
        popUp?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        self.presentViewController(VC, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle { //*****
        // Return no adaptive presentation style, use default presentation behaviour
        return .None
    }
    
    //Will be used when we link each cell to its own screen
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch(indexPath.row) {
        case 1: popUpVC("ChangeEmail")
            break
        case 2: popUpVC("AddSecondaryEmail")
            break
        case 3: popUpVC("ChangePassword")
            break
        case 4: popUpVC("VerifyStudentEmail")
            break
        case 5: break //popUpVC("Advanced")
        case 13: //signOut()
            break
            
        default: break
        }
        
    }
    
    /*@IBAction func backToViews(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }*/
    
    //Will be used when we link each cell to its own screen
    /*func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("You selected cell number: \(indexPath.row)!")
        self.performSegueWithIdentifier("yourIdentifier", sender: self)
    }*/


}

