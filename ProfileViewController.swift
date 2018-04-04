//
//  MyProfile.swift
//  Mesh
//
//  Created by Daniel Ssemanda on 8/14/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import Foundation
import UIKit


class MyProfileView: UIViewController{
    
    //For handling the tabs and their look
    var isMyInfoPageOpen = true
    var myInfoTab = UIButton()
    var myInfoTabSelectedString = NSMutableAttributedString()
    var myInfoTabString = NSMutableAttributedString()
    var myDocumentsTab = UIButton()
    var myDocumentsTabSelectedString = NSMutableAttributedString()
    var myDocumentsTabString = NSMutableAttributedString()
    var myDocumentsSuperView = UIView()
    var myInfoScroll = UIScrollView()
    var isEditButtonTapped = false
    
    var myInfoView = UIView()
    var myNameLabel = UITextField()
    var  myProfilePic = UIImageView()
    var myCompanyLabel = UITextField()
    var myPositionLabel = UITextField()
    
    var workPhoneNumber = UITextField()
    var workEmailText = UITextField()
    var schoolText = UITextField()
    
    var editLabel = UILabel()
    
    //For SearchBar in myDocuments Section
    //    var bigRedMenuBool = false
    var secondBar = UIView()
    let searchBox = TextField()
    
    private var spinner = UIActivityIndicatorView() // spins when sending information to firebase
    private var sendingRequest = false // true if sending request to firebase. This prevents multiple requests from being sent at the same time
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        //        let frame = self.view.frame
        
        //Creates My Info and My Documents Tabs
        createTabs()
        
        //Creating the NavBar
        makeBioSection()
        
        //Creates Phone, Email, Fax, etc. sections
        makeOtherSections()
        
        //Create the view for when my Documents is touched
        createMyDocumentsSuperView()
        
        view.addSubview(myInfoScroll)
        view.bringSubviewToFront(cornerQuickAccessButton)
        
        barNameLabel.text = "My Profile"
        //        createAndAddButtonsToNavBar()
        spinner.center = self.view.center
        spinner.color = UIColor.redColor()
        self.view.addSubview(spinner)
    }
    
    override func viewDidAppear(animated: Bool) {
        masterPageIdentificationNum = 0
        
        let cell0 = bigRedCollectionView.collectionView!.cellForItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        
        let cell1 = bigRedCollectionView.collectionView!.cellForItemAtIndexPath(NSIndexPath(forRow: 1, inSection: 0))
        
        let cell2 = bigRedCollectionView.collectionView!.cellForItemAtIndexPath(NSIndexPath(forRow: 2, inSection: 0))
        
        cell0?.contentView.backgroundColor = UIColor.lightGrayColor()
        
        cell1?.contentView.backgroundColor = UIColor.meshRed()
        
        cell2?.contentView.backgroundColor = UIColor.meshRed()
        
        barNameLabel.text = "My Profile"
        
        //        UIView.animateWithDuration(0.3, animations: {
        //            cornerQuickAccessButton.alpha = 0.5
        //        })
        
    }
    
    func removeKeyboard() {
        searchBox.resignFirstResponder()
    }
    
    //Create the view for when my Documents is touched
    func createMyDocumentsSuperView() {
        let frame = self.view.frame
        myDocumentsSuperView = UIView(frame: CGRectMake(0, 108, frame.width, frame.height - 108))
        myDocumentsSuperView.backgroundColor = UIColor.whiteColor()
        let tappingDocumentsSuperview = UITapGestureRecognizer(target: self, action: #selector(removeKeyboard))
        myDocumentsSuperView.addGestureRecognizer(tappingDocumentsSuperview)
        
        secondBar = UIView(frame: CGRectMake(0, 0, view.frame.width, 36))
        secondBar.backgroundColor = UIColor.whiteColor()
        
        let grayBox = UIView()
        grayBox.backgroundColor = UIColor.rgb(230, green: 231, blue: 232)
        
        let searchButton = UIButton()
        searchButton.setImage(UIImage(named:"icon search"), forState: .Normal)
        //        searchButton.addTarget(self, action: #selector(makeSegueChange), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        searchBox.backgroundColor = UIColor.rgb(230, green: 231, blue: 232)
        //      searchBox.backgroundColor = UIColor.rgb(176, green: 238, blue: 237)
        searchBox.layer.borderWidth = 1.0
        searchBox.layer.borderColor = UIColor.blackColor().CGColor
        searchBox.placeholder = "Type a company name"
        //searchBox.font = UIFont(name: "Calibri-Light", size: 11)!
        searchBox.font = UIFont.systemFontOfSize(11)
        searchBox.layer.cornerRadius = 5
        //      searchBox.hidden = false
        searchBox.addTarget(self, action: #selector(touchedSearchBox), forControlEvents: UIControlEvents.EditingDidBegin)
        searchBox.addTarget(self, action: #selector(leftSearchBox), forControlEvents: UIControlEvents.EditingDidEnd)
        
        
        
        //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchedSearchBox))
        //        secondBar.addGestureRecognizer(tapGesture)
        
        let sortBy = UIButton(type: .System)
        let sortByText = NSMutableAttributedString()
        let sortByFirstPart = NSAttributedString(string: "Sort by", attributes: [NSFontAttributeName: UIFont(name: "Calibri-Light", size: 11)!, NSForegroundColorAttributeName: UIColor.rgb(88, green: 89, blue: 91)])
        let sortBySecondPart = NSAttributedString(string: " date added", attributes: [NSFontAttributeName: UIFont(name: "Calibri-Light", size: 11)!, NSForegroundColorAttributeName: UIColor.meshRed()])
        sortByText.appendAttributedString(sortByFirstPart)
        sortByText.appendAttributedString(sortBySecondPart)
        let dropDownAttachment = NSTextAttachment()
        dropDownAttachment.image = UIImage(named: "icon collapse down")
        dropDownAttachment.bounds = CGRectMake(0,0,8,4)
        sortByText.appendAttributedString(NSAttributedString(attachment: dropDownAttachment))
        sortBy.setAttributedTitle(sortByText, forState: .Normal)
        
        
        secondBar.addSubview(searchBox)
        secondBar.addSubview(grayBox)
        secondBar.addSubview(searchButton)
        secondBar.addSubview(sortBy)
        secondBar.addConstraintsWithFormat("H:[v0(18)]-10-|", views: searchButton)
        secondBar.addConstraintsWithFormat("V:|-9-[v0(17)]", views: searchButton)
        secondBar.addConstraintsWithFormat("V:|-6-[v0(24)]", views: searchBox)
        secondBar.addConstraintsWithFormat("H:|-0-[v0(102)]-0-[v1]-2-[v2(37)]|", views: sortBy, searchBox, grayBox)
        secondBar.addConstraintsWithFormat("V:|-6-[v0(24)]", views: grayBox)
        secondBar.addConstraintsWithFormat("V:|-12-[v0(24)]", views: sortBy)
        myDocumentsSuperView.addSubview(secondBar)
    }
    
    //Creates My Info and My Documents Tabs
    func createTabs() {
        let frame = self.view.frame
        
        //Old "My Info" Tab frame:
        //        myInfoTab.frame = CGRectMake(0, 65, ceil(frame.width / 2), 40)
        myInfoTab.frame = CGRectMake(0, 65, frame.width , 40)
        myInfoTab.backgroundColor = UIColor.meshRed()
        myInfoTab.addTarget(self, action: #selector(myInfoTabClicked), forControlEvents: UIControlEvents.TouchUpInside)
        
        let rightFacingCollapseIcon = NSTextAttachment()
        rightFacingCollapseIcon.image = imageResize(UIImage(named: "icon collapse right white")!, sizeChange: CGSize(width: 10, height: 10))
        
        let leftFacingCollapseIcon = NSTextAttachment()
        leftFacingCollapseIcon.image = imageResize(UIImage(named: "icon collapse left white")!, sizeChange: CGSize(width: 10, height: 10))
        
        let rightAttachmentString = NSAttributedString(attachment: rightFacingCollapseIcon)
        let leftAttachmentString = NSAttributedString(attachment: leftFacingCollapseIcon)
        
        
        let myInfoStringText = NSAttributedString(string: "  My Info  ", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        myInfoTabSelectedString.appendAttributedString(rightAttachmentString)
        myInfoTabSelectedString.appendAttributedString(myInfoStringText)
        myInfoTabSelectedString.appendAttributedString(leftAttachmentString)
        
        myInfoTabString.appendAttributedString(myInfoStringText)
        myInfoTab.setAttributedTitle(myInfoTabSelectedString, forState: .Normal)
        
        
        
        self.view.addSubview(myInfoTab)
        
        // Stuff for "My Documents" Tab
        //        myDocumentsTab.frame = CGRectMake(ceil(frame.width / 2) + 3, 65, frame.width - ceil(frame.width / 2) - 3 , 40)
        //        myDocumentsTab.backgroundColor = UIColor.rgb(229, green: 38, blue: 54)
        //        myDocumentsTab.addTarget(self, action: #selector(myDocumentsTabClicked), forControlEvents: UIControlEvents.TouchUpInside)
        //
        //        let myDocumentsStringText = NSAttributedString(string: " My Documents ", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        //
        //        myDocumentsTabSelectedString.appendAttributedString(rightAttachmentString)
        //        myDocumentsTabSelectedString.appendAttributedString(myDocumentsStringText)
        //        myDocumentsTabSelectedString.appendAttributedString(leftAttachmentString)
        //
        //        myDocumentsTabString.appendAttributedString(myDocumentsStringText)
        //
        //        myDocumentsTab.setAttributedTitle(myDocumentsTabString, forState: .Normal)
        //        self.view.addSubview(myDocumentsTab)
    }
    
    //When you touch the searchbox, the field changes to this color
    func touchedSearchBox(gesture: UITapGestureRecognizer) {
        searchBox.backgroundColor = UIColor.rgb(176, green: 238, blue: 237)
    }
    
    //When you leave the searchbox, the color reverts
    func leftSearchBox(gesture: UITapGestureRecognizer) {
        searchBox.backgroundColor = UIColor.rgb(230, green: 231, blue: 232)
    }
    
    
    func myDocumentsTabClicked() {
        if (isMyInfoPageOpen) {
            myDocumentsTab.setAttributedTitle(myDocumentsTabSelectedString, forState: .Normal)
            myInfoTab.setAttributedTitle(myInfoTabString, forState: .Normal)
            view.addSubview(myDocumentsSuperView)
            view.bringSubviewToFront(cornerQuickAccessButton)
            isMyInfoPageOpen = false
        }
    }
    
    func myInfoTabClicked() {
        if(!isMyInfoPageOpen){
            myDocumentsTab.setAttributedTitle(myDocumentsTabString, forState: .Normal)
            myInfoTab.setAttributedTitle(myInfoTabSelectedString, forState: .Normal)
            myDocumentsSuperView.removeFromSuperview()
            isMyInfoPageOpen = true
        }
    }
    
    
    func editButtonTapped() {
        if (isEditButtonTapped == false){
            isEditButtonTapped = true
            editLabel.textColor = UIColor.rgb(1, green: 255, blue: 255)
            editLabel.text = "Done"
            
            myNameLabel.userInteractionEnabled = true
            myNameLabel.textColor = UIColor.rgb(1, green: 255, blue: 255)
            
            myCompanyLabel.userInteractionEnabled = true
            myCompanyLabel.textColor = UIColor.rgb(1, green: 255, blue: 255)
            
            myPositionLabel.userInteractionEnabled = true
            myPositionLabel.textColor = UIColor.rgb(1, green: 255, blue: 255)
            
            
            workPhoneNumber.userInteractionEnabled = true
            workPhoneNumber.textColor = UIColor.rgb(4, green: 175, blue: 200)
            
            workEmailText.userInteractionEnabled = true
            workEmailText.textColor = UIColor.rgb(4, green: 175, blue: 200)
            
            schoolText.userInteractionEnabled = true
            schoolText.textColor = UIColor.rgb(4, green: 175, blue: 200)
            
            //            let myNameLabelTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(myNameLabelTapped))
            //            myNameLabel.addGestureRecognizer(myNameLabelTap)
            
        }
        else {
            var workPhoneBackEndCopy = workPhoneNumber.text!
            while (workPhoneBackEndCopy.containsString("+") || workPhoneBackEndCopy.containsString(" ") || workPhoneBackEndCopy.containsString("-") || workPhoneBackEndCopy.containsString(".") || workPhoneBackEndCopy.containsString("(") ||
                workPhoneBackEndCopy.containsString(")") ){
                    
                    if let index = workPhoneBackEndCopy.characters.indexOf("+"){
                        workPhoneBackEndCopy.removeAtIndex(index)
                    }
                    
                    if let index = workPhoneBackEndCopy.characters.indexOf(" "){
                        workPhoneBackEndCopy.removeAtIndex(index)
                    }
                    
                    if let index = workPhoneBackEndCopy.characters.indexOf("-"){
                        workPhoneBackEndCopy.removeAtIndex(index)
                    }
                    
                    if let index = workPhoneBackEndCopy.characters.indexOf("."){
                        workPhoneBackEndCopy.removeAtIndex(index)
                    }
                    
                    if let index = workPhoneBackEndCopy.characters.indexOf("("){
                        workPhoneBackEndCopy.removeAtIndex(index)
                    }
                    
                    if let index = workPhoneBackEndCopy.characters.indexOf(")"){
                        workPhoneBackEndCopy.removeAtIndex(index)
                    }
            }
            
            var check = 0
            for i in workPhoneBackEndCopy.characters{
                let aString = String(i)
                if let a = Int(aString) {
                    check += 1
                }
            }
            
            if( (workPhoneBackEndCopy != "") && (((workPhoneBackEndCopy.characters.count != 11) && (workPhoneBackEndCopy.characters.count != 10)) ||
                (check != workPhoneBackEndCopy.characters.count) ||
                (workPhoneBackEndCopy.characters.count == 11 &&
                    workPhoneBackEndCopy[workPhoneBackEndCopy.startIndex] != "1"))){
                let message = "You have entered an improper phone number!"
                let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else if ( (workEmailText.text != nil) && (!workEmailText.text!.containsString("@") ||
                !workEmailText.text!.containsString(".")) && (workEmailText.text! != "")){
                let message = "You have entered an improper Email!"
                let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                
                isEditButtonTapped = false
                editLabel.textColor = UIColor.whiteColor()
                editLabel.text = "Edit"
                
                myNameLabel.textColor = UIColor.whiteColor()
                myNameLabel.userInteractionEnabled = false
                myNameLabel.resignFirstResponder()
                
                myCompanyLabel.textColor = UIColor.whiteColor()
                myCompanyLabel.userInteractionEnabled = false
                myCompanyLabel.resignFirstResponder()
                
                myPositionLabel.textColor = UIColor.whiteColor()
                myPositionLabel.userInteractionEnabled = false
                myPositionLabel.resignFirstResponder()
                
                
                workPhoneNumber.textColor = UIColor.rgb(147, green: 149, blue: 152)
                workPhoneNumber.userInteractionEnabled = false
                workPhoneNumber.resignFirstResponder()
                
                workEmailText.textColor = UIColor.rgb(147, green: 149, blue: 152)
                workEmailText.userInteractionEnabled = false
                workEmailText.resignFirstResponder()
                
                schoolText.textColor = UIColor.rgb(147, green: 149, blue: 152)
                schoolText.userInteractionEnabled = false
                schoolText.resignFirstResponder()
                
                var workPhoneDisplayCopy = workPhoneBackEndCopy
                if (workPhoneDisplayCopy.characters.count == 10){
                    workPhoneDisplayCopy.insert("-", atIndex: workPhoneDisplayCopy.startIndex.advancedBy(3))
                    workPhoneDisplayCopy.insert("-", atIndex: workPhoneDisplayCopy.startIndex.advancedBy(7))
                } else if (workPhoneDisplayCopy.characters.count == 11){
                    workPhoneDisplayCopy.insert("-", atIndex: workPhoneDisplayCopy.startIndex.advancedBy(1))
                    workPhoneDisplayCopy.insert("-", atIndex: workPhoneDisplayCopy.startIndex.advancedBy(5))
                    workPhoneDisplayCopy.insert("-", atIndex: workPhoneDisplayCopy.startIndex.advancedBy(9))
                }
                workPhoneNumber.text = workPhoneDisplayCopy
                
                var firstName = ""
                var lastName = ""
                
                while(myNameLabel.text![myNameLabel.text!.startIndex] == " "){
                    myNameLabel.text!.removeAtIndex(myNameLabel.text!.startIndex)
                }
                
                if let index = myNameLabel.text!.characters.indexOf(" ") {
                    let intValue = myNameLabel.text!.startIndex.distanceTo(index)
                    
                    if (intValue != -1){
                        firstName = myNameLabel.text!.substringWithRange(
                            Range<String.Index>(myNameLabel.text!.startIndex..<index))
                        lastName = myNameLabel.text!.substringWithRange(
                            Range<String.Index>(index.advancedBy(1)..<myNameLabel.text!.endIndex))
                    }
                }
                
                if (firstName == ""){
                    firstName = myNameLabel.text!
                }
                
                currentUser.firstName = firstName
                currentUser.lastName = lastName
                currentUser.company = myCompanyLabel.text!
                currentUser.position = myPositionLabel.text!
                currentUser.phoneNumber = workPhoneBackEndCopy
                currentUser.secondaryEmail = workEmailText.text!
                currentUser.school = schoolText.text!
                currentUser.save()
                print(currentUser.userId)
                //save profile to firebase
                if sendingRequest {
                    return
                }
                spinner.startAnimating()
                saveProfile(currentUser) { (error) in
                    //TODO: handle error (check where savePRofile is called elsewhere)
                    self.spinner.stopAnimating()
                    self.sendingRequest = false
                }
                sendingRequest = true
            }
        }
    }
    
    func myNameLabelTapped(){
        if (isEditButtonTapped == true){
            myNameLabel.becomeFirstResponder()
            let viewTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(removeFirstResponder))
            self.view.addGestureRecognizer(viewTap)
            
        }
    }
    
    func removeFirstResponder(){
        myNameLabel.resignFirstResponder()
    }
    
    
    //Creates first biographical info section
    func makeBioSection() {
        let frame = self.view.frame
        myInfoScroll = UIScrollView(frame: CGRectMake(0, 108, frame.width, frame.height - 108))
        myInfoScroll.backgroundColor = UIColor.whiteColor()
        myInfoScroll.contentSize = CGSizeMake(frame.width, frame.height - 100)
        
        myInfoView = UIView(frame: CGRectMake(0, 0, frame.width, 120))
        myInfoView.backgroundColor = UIColor.rgb(229, green: 38, blue: 54)
        myInfoScroll.addSubview(myInfoView)
        
        
        if let profilePic = currentUser.profilePicture {
            myProfilePic.image = profilePic
        } else {
            myProfilePic.image = UIImage(named: "default profile picture")
        }
        myProfilePic.backgroundColor = UIColor.whiteColor()
        
        
        myNameLabel.userInteractionEnabled = false
        myNameLabel.text = currentUser.firstName +  " " + currentUser.lastName
        myNameLabel.font = UIFont(name: "Calibri-Light", size: 30)
        myNameLabel.textColor = UIColor.whiteColor()
        myNameLabel.placeholder = "First and Last Name"
        myNameLabel.backgroundColor = UIColor.meshRed()
        if (myNameLabel.text == " "){
            myNameLabel.text = ""
        }
        
        
        let myCompanyLabelString = currentUser.company
        myCompanyLabel.text = myCompanyLabelString
        myCompanyLabel.textColor = UIColor.whiteColor()
        myCompanyLabel.userInteractionEnabled = false
        let widthCalc = frame.width - 172
        let numberNeeded = getMinimumFontSizeNeededCalibri(myCompanyLabelString, numberOfLines: 1, width: widthCalc, fontSizeStart: 24)
        myCompanyLabel.font = UIFont(name: "Calibri-Light", size: numberNeeded)
        myCompanyLabel.placeholder = "Company Name"
        myCompanyLabel.backgroundColor = UIColor.meshRed()
        
        
        let myPositionLabelSttring = currentUser.position
        myPositionLabel.text = myPositionLabelSttring
        let widthInputCalc = frame.width - 172
        let numNeeded = getMinimumFontSizeNeededCalibri( myPositionLabelSttring, numberOfLines: 1, width: widthInputCalc, fontSizeStart: 18)
        myPositionLabel.userInteractionEnabled = false
        myPositionLabel.font = UIFont(name: "Calibri-Light", size: numNeeded)
        myPositionLabel.textColor = UIColor.whiteColor()
        myPositionLabel.placeholder = "Company Position"
        myPositionLabel.backgroundColor = UIColor.meshRed()
        
        
        
        let editButton = UIButton()
        
        editLabel.text = "Edit"
        editLabel.textColor = UIColor.whiteColor()
        editLabel.font = UIFont(name: "Calibri-Light", size: 15)
        let editIcon = UIImageView()
        editIcon.image = UIImage(named: "icon profile")
        editButton.addSubview(editLabel)
        editButton.addSubview(editIcon)
        editButton.addConstraintsWithFormat("H:[v0(35)][v1(13)]-2-|", views: editLabel, editIcon)
        editButton.addConstraintsWithFormat("V:[v0(15)]|", views: editLabel)
        editButton.addConstraintsWithFormat("V:|-8-[v0(15)]|", views: editIcon)
        //        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyProfileView.editButtonTapped))
        //        editButton.addGestureRecognizer(tap)
        editButton.addTarget(self, action: #selector(editButtonTapped), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        myInfoView.addSubview(myProfilePic)
        myInfoView.addSubview(myNameLabel)
        myInfoView.addSubview(myPositionLabel)
        myInfoView.addSubview(editButton)
        myInfoView.addSubview(myCompanyLabel)
        myInfoView.addConstraintsWithFormat("H:|-10-[v0(100)]-5-[v1]-5-|", views: myProfilePic, myNameLabel)
        myInfoView.addConstraintsWithFormat("V:|-10-[v0(100)]", views: myProfilePic)
        myInfoView.addConstraintsWithFormat("V:|-5-[v0]-2.5-[v1(35)]-2.5-[v2(35)]|", views: myNameLabel,myCompanyLabel, myPositionLabel)
        myInfoView.addConstraintsWithFormat("H:|-10-[v0(100)]-5-[v1]-5-|", views: myProfilePic, myCompanyLabel)
        myInfoView.addConstraintsWithFormat("H:|-10-[v0(100)]-5-[v1]-55-|", views: myProfilePic, myPositionLabel)
        myInfoView.addConstraintsWithFormat("H:[v0(55)]|", views: editButton)
        myInfoView.addConstraintsWithFormat("V:[v0(25)]-10-|", views: editButton)
    }
    
    func textField(textFieldToChange: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // limit to 4 characters
        let characterCountLimit = 9
        
        // We need to figure out how many characters would be in the string after the change happens
        let startingLength = textFieldToChange.text?.characters.count ?? 0
        let lengthToAdd = string.characters.count
        let lengthToReplace = range.length
        
        let newLength = startingLength + lengthToAdd - lengthToReplace
        
        return newLength <= characterCountLimit
    }
    
    //Creates Phone, Email, School, etc. sections
    func makeOtherSections(){
        let frame = self.view.frame
        let sizeCalculation = floor((frame.height - 350) / 4)
        
        let phoneSection = UIView(frame: CGRectMake(0, 128, frame.width, sizeCalculation + 20))
        phoneSection.backgroundColor = UIColor.rgb(230, green: 231, blue: 232)
        let phoneIcon = UIImageView()
        phoneIcon.image = UIImage(named: "icon number bubble")
        let phoneLabel = UILabel()
        phoneLabel.text = "Phone"
        phoneLabel.textColor = UIColor.rgb(65, green: 64, blue: 66)
        phoneLabel.font = UIFont(name: "Calibri-Light", size: 20)
        
        let sectionWidthSpaceCalc = frame.width - 45
        
        
        let workArea = UIView(frame: CGRectMake( 45 + floor(sectionWidthSpaceCalc/2), 29, ceil(sectionWidthSpaceCalc/2), phoneSection.frame.height - 29))
        workArea.backgroundColor = UIColor.clearColor()
        
        workPhoneNumber.text = currentUser.phoneNumber
        workPhoneNumber.placeholder = "No  number set"
        workPhoneNumber.userInteractionEnabled = false
        workPhoneNumber.textColor = UIColor.rgb(147, green: 149, blue: 152)
        workPhoneNumber.font = UIFont(name: "Calibri-Light", size: 18)
        
        
        workArea.addSubview(workPhoneNumber)
        workArea.addConstraintsWithFormat("H:|[v0]", views: workPhoneNumber)
        workArea.addConstraintsWithFormat("V:|-8-[v0]", views: workPhoneNumber)
        
        phoneSection.addSubview(phoneIcon)
        phoneSection.addSubview(phoneLabel)
        phoneSection.addConstraintsWithFormat("H:|-10-[v0(25)]-10-[v1]", views: phoneIcon, phoneLabel)
        phoneSection.addConstraintsWithFormat("V:|-10-[v0(25)]", views: phoneLabel)
        phoneSection.addConstraintsWithFormat("V:|-10-[v0(25)]", views: phoneIcon)
        
        
        workArea.frame = CGRectMake(45, 29, floor(sectionWidthSpaceCalc/2), phoneSection.frame.height - 29)
        phoneSection.addSubview(workArea)
        
        myInfoScroll.addSubview(phoneSection)
        
        //NEXT SECTION
        let emailSectionYPos = 128 + sizeCalculation + 30
        let emailSection = UIView(frame: CGRectMake(0, emailSectionYPos, frame.width, sizeCalculation + 20))
        emailSection.backgroundColor = UIColor.rgb(230, green: 231, blue: 232)
        let emailIcon = UIImageView()
        emailIcon.image = UIImage(named: "icon number bubble")
        let emailLabel = UILabel()
        emailLabel.text = "Email"
        emailLabel.textColor = UIColor.rgb(65, green: 64, blue: 66)
        emailLabel.font = UIFont(name: "Calibri-Light", size: 20)
        
        let workEmailArea = UIView(frame: CGRectMake(45, 29, floor(sectionWidthSpaceCalc/2), phoneSection.frame.height - 29))
        workEmailArea.backgroundColor = UIColor.clearColor()
        
        
        
        var workEmailTextString: String
        workEmailTextString = currentUser.secondaryEmail
        workEmailText.placeholder = "No email address set"
        workEmailText.userInteractionEnabled = false
        let workEmailNumNeeded = getMinimumFontSizeNeededCalibri(workEmailTextString, numberOfLines: 1, width: floor(sectionWidthSpaceCalc/2), fontSizeStart: 18)
        workEmailText.text = workEmailTextString
        workEmailText.textColor = UIColor.rgb(147, green: 149, blue: 152)
        workEmailText.font = UIFont(name: "Calibri-Light", size: workEmailNumNeeded)
        
        
        workEmailArea.addSubview(workEmailText)
        workEmailArea.addConstraintsWithFormat("H:|[v0]-5-|", views: workEmailText)
        workEmailArea.addConstraintsWithFormat("V:|-8-[v0]", views: workEmailText)
        
        
        
        
        emailSection.addSubview(workEmailArea)
        
        emailSection.addSubview(emailIcon)
        emailSection.addSubview(emailLabel)
        emailSection.addConstraintsWithFormat("H:|-10-[v0(25)]-10-[v1]", views: emailIcon, emailLabel)
        emailSection.addConstraintsWithFormat("V:|-10-[v0(25)]", views: emailLabel)
        emailSection.addConstraintsWithFormat("V:|-10-[v0(25)]", views: emailIcon)
        emailSection.addConstraintsWithFormat("V:|-30-[v0]|", views: workEmailArea)
        emailSection.addConstraintsWithFormat("H:|-45-[v0]|", views: workEmailArea)
        
        myInfoScroll.addSubview(emailSection)
        
        
        
        let schoolYPos = emailSectionYPos + sizeCalculation + 30
        let schoolSection = UIView(frame: CGRectMake(0, schoolYPos, frame.width, sizeCalculation))
        schoolSection.backgroundColor = UIColor.rgb(230, green: 231, blue: 232)
        let schoolIcon = UIImageView()
        schoolIcon.image = UIImage(named: "icon number bubble")
        
        let schoolLabel = UILabel()
        schoolLabel.text = "School"
        schoolLabel.textColor = UIColor.rgb(65, green: 64, blue: 66)
        schoolLabel.font = UIFont(name: "Calibri-Light", size: 20)
        
        schoolText.text = currentUser.school
        schoolText.placeholder = "No school set"
        schoolText.userInteractionEnabled = false
        schoolText.textColor = UIColor.rgb(147, green: 149, blue: 152)
        schoolText.font = UIFont(name: "Calibri-Light", size: 18)
        
        schoolSection.addSubview(schoolIcon)
        schoolSection.addSubview(schoolLabel)
        schoolSection.addSubview(schoolText)
        schoolSection.addConstraintsWithFormat("H:|-10-[v0(25)]-10-[v1]", views: schoolIcon, schoolLabel)
        schoolSection.addConstraintsWithFormat("V:|-10-[v0(25)][v1]", views: schoolLabel, schoolText)
        schoolSection.addConstraintsWithFormat("V:|-10-[v0(25)]", views: schoolIcon)
        schoolSection.addConstraintsWithFormat("H:|-10-[v0(25)]-10-[v1]|", views: schoolIcon, schoolText)
        
        myInfoScroll.addSubview(schoolSection)
        
    }
    
    
    
    //Stuff to do before any segue occurrs
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let navigationPageViewController = segue.destinationViewController as? NavigationPageView {
            navigationPageViewController.pageViewDelegate = self
        }
    }
}

extension MyProfileView: NavigationPageViewControllerDelegate {
    func navigationPageViewController(navigationPageViewController: NavigationPageView,
                                      didUpdatePageCount count: Int) {
        
    }
    
    func navigationPageViewController(navigationPageViewController: NavigationPageView,
                                      didUpdatePageIndex index: Int){
        masterPageIdentificationNum = index
    }
}




