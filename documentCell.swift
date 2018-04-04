//
//  documentCell.swift
//  manageSharing
//
//  Created by Akash Wadawadigi on 8/31/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import Foundation
import UIKit

class documentCell: UITableViewCell{
    
    @IBOutlet weak var documentImage: UIImageView!
    
    @IBOutlet weak var sharedWithCount: UILabel!

    @IBAction func editSharing(sender: AnyObject) {
    }
    @IBOutlet weak var documentAddDate: UILabel!
    @IBOutlet weak var editSharingButton: UIButton!
    

    
    @IBOutlet weak var documentTitle: UILabel!
}