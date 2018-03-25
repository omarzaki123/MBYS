//
//  LiasonsTableViewCell.swift
//  Company Profile
//
//  Created by Arjun Tambe on 9/20/16.
//  Copyright © 2016 Arjun Tambe. All rights reserved.
//

import Foundation

import UIKit

class LiasonsTableViewCell: UITableViewCell {


    //keeps track of whether the cell is currently expanded
    var isExpanded = false
    
    
    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var companyLabel: UILabel?
    @IBOutlet var positionLabel: UILabel?
    @IBOutlet var addContactIcon: UIButton?
    @IBOutlet var expandContractButton: UIButton?
    @IBOutlet var profileImage: UIImageView?

    
    func setLabels(firstName: String, lastName: String, company: String, position: String) {
        let name = firstName + " " + lastName
        self.nameLabel!.text = name
        self.nameLabel!.font = liasonNameFont
        self.nameLabel!.textColor = altTextColor
        
        self.companyLabel!.text = company
        self.companyLabel!.font = liasonCompanyFont
        self.companyLabel!.textColor = titleTextColor
        
        self.positionLabel!.text = position
        self.positionLabel!.font = liasonPositionFont
        self.positionLabel!.textColor = titleTextColor
    }
    
    
    func setProfilePicture(image: UIImage) {
        profileImage?.image = image
    }
    
    //triggered when the add contact icon gets pressed
    @IBAction func addContact(sender: AnyObject!) {
        //add code for adding contact
    }
    
    
    @IBAction func expandContract(sender: AnyObject!) {
        let tableView = getTableView()
        tableView.beginUpdates()
        
        if (!isExpanded) {
            expand(sender as! UIButton)
        } else {
            indexOfExpandedRowLiasons = -1
            collapse(sender as! UIButton)
        }
        tableView.endUpdates()
    }
    
    //gets the table view - In ios 6, tableview is a superview of cell; in ios 7, it's a superview of tableviewwrapper which is a superview of cell  - this code circumvents version checks
    func getTableView() -> UITableView {
        var view = self.superview
        while (!(view?.isKindOfClass(UITableView))!) {
            view = view?.superview
        }
        return (view as! UITableView)
    }
    
    
    //handles expansion of the cell
    func expand(button: UIButton) {
        //we shifted tags up by 1 to avoid tagging any cell as 0, so now we need to shift them back down
        indexOfExpandedRowLiasons = self.tag - 1
        button.setImage(UIImage(named: "icon collapse diag up"), forState: UIControlState.Normal)
        isExpanded = true
        putSubviews()
    }
    
    func putSubviews() {
//        profileImage
    }

    
    //collapse the cell by removing the subviews we added when expanded and changing the corner button back to the downward diagonal icon
    func collapse(button: UIButton) {
        button.setImage(UIImage(named: "icon collapse diag down"), forState: UIControlState.Normal)
        isExpanded = false

    }
    
    
}