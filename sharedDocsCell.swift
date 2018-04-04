//
//  sharedDocsCell.swift
//  viewSharedDocs
//
//  Created by Akash Wadawadigi on 8/31/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import Foundation
import UIKit

class sharedDocsCell: UITableViewCell{
    
    //If this variable is 0, then the start is NOT favorited
    var isFavorited = 0;
    
    @IBOutlet weak var documentTitle: UILabel!
    
    @IBOutlet weak var sharedDate: UILabel!
    
    @IBOutlet weak var documentImage: UIImageView!

    @IBAction func favoriteStarToggle(sender: AnyObject) {
        
        if(isFavorited == 0){
            print("Its empty")
            sender.setImage(UIImage(named: "icon favorite filled.png"), forState: .Normal)
            isFavorited = 1
        } else {
            print("Or is it")
            sender.setImage(UIImage(named: "icon favorite empty.png"), forState: .Normal)
            isFavorited = 0
        }
    }

}