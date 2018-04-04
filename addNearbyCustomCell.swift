//
//  addNearbyCustomCell.swift
//  addNearby
//
//  Created by Akash Wadawadigi on 8/23/16.
//  Copyright © 2016 ArielBong. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class addNearbyCustomCell: UITableViewCell{
    @IBOutlet weak var cellPicture: UIImageView!
    @IBOutlet weak var cellName: UILabel!
    @IBOutlet weak var cellAffiliation: UILabel!
    var cellPeerID: MCPeerID?
    
    @IBAction func addUser(sender: AnyObject) {
        //print("Hello")
        
    }
    
}
