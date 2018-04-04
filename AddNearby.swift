//
//  ViewController.swift
//  addNearby
//
//  Created by Ariel Bong on 7/12/16.
//  Copyright © 2016 ArielBong. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import Foundation

class AddNearby: UIViewController, UITableViewDelegate, UITableViewDataSource, MCSessionDelegate, UISearchBarDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {

    let meshServiceType = "mesh-addNearby"
    
    var peerID: MCPeerID!; //current device=
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    var serviceBrowser: MCNearbyServiceBrowser!
    var serviceAdvertiser: MCNearbyServiceAdvertiser! // service advertiser
    var nearbyUsers = [MCPeerID]() //array of nearbyUsers
    var invitationHandler: ((Bool, MCSession)->Void)?
    
       //let profileName = "Ariel Bong"
    
    
    @IBOutlet weak var nearbyUsersTable: UITableView!
    @IBOutlet weak var addNearby: UISwitch!
    @IBOutlet weak var visibleLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nearbyUsersTable.dataSource = self
        nearbyUsersTable.delegate = self
        
        self.view.backgroundColor = UIColor(red: 248/255, green: 40/255, blue: 54/255, alpha: 0.85)
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background popup window.png")!)
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddNearby.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //var profileName = currentUser.firstName + " " + currentUser.lastName
        peerID = MCPeerID(displayName: currentUser.userId)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .None)
        mcSession.delegate = self
        
        //creates advertising service
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: meshServiceType)
        serviceAdvertiser.delegate = self
       
        //service that browses for other advertising peers
        serviceBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: meshServiceType)
        serviceBrowser.delegate = self
        
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: meshServiceType, discoveryInfo: nil, session: mcSession)
       
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //handles when the switch is flipped
    @IBAction func startStopAdvertising(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "", message: "Change Visibility", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        var actionTitle: String
        if addNearby.on {
            actionTitle = "Make me visible to others"
        }
        else{
            actionTitle = "Make me invisible to others"
        }
        
        //sets up an alert telling the user they will change state; maybe should add implementation to stepp message from appearing
        let visibilityAction: UIAlertAction = UIAlertAction(title: actionTitle, style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            if self.addNearby.on == true {
                self.serviceAdvertiser.startAdvertisingPeer()
                self.visibleLable.text = "Visibility: On"
                self.serviceBrowser.startBrowsingForPeers()
            }
            else{
                self.serviceAdvertiser.stopAdvertisingPeer()
                self.visibleLable.text = "Visibility: Off"
                self.serviceBrowser.stopBrowsingForPeers()
                self.nearbyUsers.removeAll()
                self.nearbyUsersTable.reloadData()
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            (alertAction) -> Void in
            self.addNearby.setOn(!self.addNearby.on, animated: true) //sets the setting back to original if action cancelled
            
        }
        
        actionSheet.addAction(visibilityAction)
        actionSheet.addAction(cancelAction)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    //CHANGED THIS TO WHEN KEYBOARD SEARCH BUTTON IS CLICKED
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        let searchUser = searchBar.text
        nearbyUsers = []
        for (_, nearbyUser) in nearbyUsers.enumerate(){
            if (nearbyUser.displayName.rangeOfString(searchUser!) != nil){
                nearbyUsers.append(nearbyUser)
                nearbyUsersTable.reloadData()
            }
            //could add a prototype cell that says no user found
        }
    }
    
    
    // neccessary to implement MCSessionDelegate class
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
    }
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        //handling data
    }
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        switch state{
        case MCSessionState.Connected:
            print("Connected to session: \(session)")
            // connectedWithPeer(peerID), addUser(peerID: MCPeerID)
            addConnection(peerID.displayName)
        case MCSessionState.Connecting:
            print("Connecting to session: \(session)")
            
        default:
            print("Did not connect to session: \(session)")
        }
    }

    
    //implementing browserviewcontroller
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //implementing MCNearbyAdvertiser
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession?) -> Void) {
        self.invitationHandler = invitationHandler
        
        invitationWasReceived(peerID.displayName)
    }
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) { //handles error, can later print error on screen
        print(error.localizedDescription)
    }
    
    
    
    //to implement MCNearbyServiceBrowser
    func browser(browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: NSError) {
        //NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [String: String]?) {
        
        for (_, nearbyUser) in nearbyUsers.enumerate(){
            if peerID == nearbyUser {
                //print("insidethisbitch")
                return
            }
        }
        nearbyUsers.append(peerID)
        nearbyUsersTable.reloadData()
    }
    
    
    
    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        for (index, aPeer) in nearbyUsers.enumerate(){
            if aPeer == peerID {
                nearbyUsers.removeAtIndex(index)
                break
            }
        }
        nearbyUsersTable.reloadData()
    
    }
    
    
    func invitationWasReceived(fromPeer: String) {
        let alert = UIAlertController(title: "", message: "\(fromPeer) wants to join your network", preferredStyle: UIAlertControllerStyle.Alert)
        
        let acceptAction: UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            self.invitationHandler!(true, self.mcSession)
        }
        
        let declineAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
            self.invitationHandler!(false, self.mcSession)
        }
        
        alert.addAction(acceptAction)
        alert.addAction(declineAction)
        
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    //set number of sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //sets number of rows in sections
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyUsers.count
    }
    
    
    //sets all the rows to the names of the array (nearbyUserNames)
    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        //let cell:addNearbyCustomCell = addNearbyCustomCell(style:UITableViewCellStyle.Default, reuseIdentifier:"Sample")
        
        let cell: addNearbyCustomCell! = nearbyUsersTable.dequeueReusableCellWithIdentifier("Sample") as? addNearbyCustomCell
        
        var nearbyUser = User()
        getUserInformation(nearbyUsers[indexPath.row].displayName) {
            user in
            nearbyUser = user!
        }
        
        
        //Add the user's name
        cell.cellName.text = nearbyUser.firstName + " " + nearbyUser.lastName
        
        //Add the user's affiliation
        cell.cellAffiliation.text = nearbyUser.company
        
        //Add the user's profile picture
        getPicture(nearbyUser.userId) {
            pic in
            cell.cellPicture.image = pic
            self.nearbyUsersTable.reloadData()
        }
        
        //cell.textLabel?.text = nearbyUsers[indexPath.row].displayName
        
        return cell
    }
    
    
    @IBAction func AddButtonPressed(sender: AnyObject) {
        
        print("Hello")
        
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! UITableViewCell
        
        let indexPath = nearbyUsersTable.indexPathForCell(cell)
        let selectedPeer = nearbyUsers[indexPath!.row] as MCPeerID
        serviceBrowser.invitePeer(selectedPeer, toSession: mcSession, withContext: nil, timeout: 45)
        
        
        /*var touchPoint: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let clickedButtonIndexPath: NSIndexPath = self.tableView.indexPathForRowAtPoint(touchPoint!)
        let selectedPeer = nearbyUsersTable[clickedButtonIndexPath] as MCPeerID*/
        
        //serviceBrowser.invitePeer(selectedPeer, toSession: mcSession, withContext: nil, timeout: 45)
        
    }
    //handles when user is clicked; the context sends extradata to the of type nsdata, so this is where "number" can be sent
    /*func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedPeer = nearbyUsers[indexPath.row] as MCPeerID
        
       serviceBrowser.invitePeer(selectedPeer, toSession: mcSession, withContext: nil, timeout: 45)
    }*/
    

}

