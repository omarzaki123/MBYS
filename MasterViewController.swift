//
//  MasterViewController.swift
//  Mesh
//
//  Created by Daniel Ssemanda on 8/21/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import Foundation
import UIKit

var masterPageIdentificationNum = 0
let scanner = QRCodeScanner()
let settingsPage = UIStoryboard(name: "Settings", bundle: nil).instantiateViewControllerWithIdentifier("SettingsPage")
let pageView = NavigationPageView(transitionStyle:.Scroll, navigationOrientation: .Horizontal, options: nil)
let addContactPopUp = UIStoryboard(name: "AddNearby", bundle: nil).instantiateViewControllerWithIdentifier("AddNearby")
let addEventVC = UIStoryboard(name: "NewEvent", bundle: nil).instantiateViewControllerWithIdentifier("NewEvent") as! NewEvent
let addContactManuallyVC = UIStoryboard(name: "AddContact", bundle: nil).instantiateViewControllerWithIdentifier("AddContact") as! AddContactManuallyViewController
let reminderSettingsVC = UIStoryboard(name: "reminderSettings", bundle: nil).instantiateViewControllerWithIdentifier("ReminderSettings")
let calendarSettingsVC = UIStoryboard(name: "calendarSettings", bundle: nil).instantiateViewControllerWithIdentifier("CalendarSettings")

//Stuff for Corner Menu
var cornerMenuBool = false
var cornerQuickAccessButton = UIButton()
var dimming = UIView()
var addManuallyContactLabelPic = UIButton()
var addNearbyContactLabelPic = UIButton()
var addNearbyContactIcon = UIButton()
var scanQRCodeLabelPic = UIButton()
var scanQRCodeIcon = UIButton()
var myQRCodeLabelPic = UIButton()
var myQRCodeIcon = UIButton()
var addManuallyContactIcon = UIButton()
var addManuallyContactLabel = UIButton()
var barNameLabel = UILabel()
var bigRedMenuBool = false
var clearView = UIView()
var qrCodeDisplay = UIView()
var qrCodeDisplayMask = UIView()
var adjustmentView = UIView()
var wholeView = UIView()
var grayLine = UIView()

class MasterViewController: UIViewController, UIPopoverPresentationControllerDelegate, calendarDelegate  {
    
    
    
    
    override func viewDidLoad() {
        let frame = self.view.frame
        calendarView.delegate = self
        
        wholeView = UIView(frame: CGRectMake(0, 0, frame.width, frame.height))
        view.addSubview(wholeView)
        wholeView.addSubview(pageView.view)
        wholeView.addConstraintsWithFormat("H:|[v0]|", views: pageView.view)
        wholeView.addConstraintsWithFormat("V:|-23-[v0]|", views: pageView.view)
        wholeView.bringSubviewToFront(pageView.view)
        
        //Creating the NavBar
        createAndAddButtonsToNavBar()
        
        //Makes bottom right corner button
        createCornerButton()
        
       
        
    }
    
    
    //Creating the NavBar
    func createAndAddButtonsToNavBar() {
        //Creating Buttons to be stored on left and right side of NavBar
        let bounds = UIScreen.mainScreen().bounds
        let width = bounds.size.width
        //        let height = bounds.size.height
        
        adjustmentView = UIView(frame: CGRectMake(0, 0, width, 75))
        adjustmentView.backgroundColor = UIColor.whiteColor()
        
        masterNavBar = UIView(frame: CGRectMake(0, 0, width, 65))
        grayLine = UIView(frame: CGRectMake(0, 88, width, 1))
        grayLine.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(grayLine)
        
        let leftSideView = UIView()
        leftSideView.frame = CGRectMake(0, 0, 55, 80)
        //        leftSideView.backgroundColor = UIColor.blueColor()
        
        let logoButton: UIButton = {
            let button = UIButton()
            button.setImage(navigationLogoImage, forState: .Normal)
            button.addTarget(self, action: #selector(bringOutTheBigRedMenu), forControlEvents: UIControlEvents.TouchUpInside)
            button.frame = CGRectMake(0, 0, 40, 40)
            return button
        }()
        
        let collapseRight = UIImage(named: "icon collapse right")!
        
        let collapseRightButton : UIButton = {
            let button = UIButton()
            button.setImage(collapseRight, forState: .Normal)
            button.frame = CGRectMake(0, 0, 40, 40)
            button.addTarget(self, action: #selector(bringOutTheBigRedMenu), forControlEvents: UIControlEvents.TouchUpInside)
            return button
        }()
        
        //        let newsFeedBarButton = UIBarButtonItem(title: "News Feed", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        //        newsFeedBarButton.tintColor = UIColor.rgb(228, green: 40, blue: 54)
        //        let font = UIFont(name: "Calibri-Light", size: 20)
        //        newsFeedBarButton.setTitleTextAttributes([NSFontAttributeName: font!], forState: UIControlState.Normal )
        barNameLabel = UILabel()
        barNameLabel.text = "My Profile"
        barNameLabel.font = UIFont(name: "Calibri-Light", size: 25)
        barNameLabel.textColor = UIColor.meshRed()
        
        //        let tappingTwice = UITapGestureRecognizer(target: self, action: #selector(tappedNewsFeedLabelTwice))
        //        tappingTwice.numberOfTapsRequired = 2
        //        masterNavBar.addGestureRecognizer(tappingTwice)
        
        //        let tappingNavBar = UITapGestureRecognizer(target: self, action: #selector(removeBigRedMenu2))
        //        masterNavBar.addGestureRecognizer(tappingNavBar)
        
        leftSideView.addSubview(logoButton)
        leftSideView.addSubview(collapseRightButton)
        leftSideView.addSubview(barNameLabel)
        leftSideView.addConstraintsWithFormat("H:|[v0(40)]-0-[v1(8)]-7-[v2]", views: logoButton, collapseRightButton, barNameLabel)
        leftSideView.addConstraintsWithFormat("V:|-19-[v0(40)]", views: logoButton)
        leftSideView.addConstraintsWithFormat("V:|-44-[v0(15)]", views: collapseRightButton)
        leftSideView.addConstraintsWithFormat("V:|-32-[v0]", views: barNameLabel)
        
        //        let leftSideButtons = UIBarButtonItem(customView: leftSideView)
        
        
        masterNavBar.addSubview(leftSideView)
        
        //        navigationItem.leftBarButtonItems = [ leftSideButtons, newsFeedBarButton]
        
        
        
        let rightSideView = UIView()
        rightSideView.frame = CGRectMake(0, 0, 100, 80)
        
        
        let reminderButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named:"icon reminder")!, forState: .Normal)
            button.frame = CGRectMake(0, 0, 40, 40)
            button.addTarget(self, action: #selector(reminderButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
            return button
        }()
        
        let contactButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named:"icon Calendar Notification")!, forState: .Normal)
            button.frame = CGRectMake(0, 0, 40, 40)
            button.addTarget(self, action: #selector(contactButtonAction), forControlEvents: UIControlEvents.TouchUpInside)
            return button
        }()
        
        let contactNumberBubble = UIImageView(image: UIImage(named: "icon number bubble"))
        
        
        
        let reminderNumberBubble = UIView()
        reminderNumberBubble.backgroundColor = UIColor.meshRed()
        
        
        
        //        rightSideView.backgroundColor = UIColor.blueColor()
        
        let contactNotificationsLabel = UILabel()
        contactNotificationsLabel.text = "\(contactNumberOfNotifications)"
        contactNotificationsLabel.textColor = UIColor.whiteColor()
        contactNotificationsLabel.font = UIFont.boldSystemFontOfSize(10)
        
        let reminderNotificationsLabel = UILabel()
        reminderNotificationsLabel.text = "\(reminderNumberOfNotifications)"
        reminderNotificationsLabel.textColor = UIColor.whiteColor()
        reminderNotificationsLabel.font = UIFont.boldSystemFontOfSize(10)
        
        rightSideView.addSubview(reminderButton)
        rightSideView.addSubview(contactButton)
        rightSideView.addSubview(contactNumberBubble)
        rightSideView.addSubview(contactNotificationsLabel)
        rightSideView.addSubview(reminderNotificationsLabel)
        
        rightSideView.addConstraintsWithFormat("H:[v0(40)]-20-[v1(35)]|", views: reminderButton,contactButton)
        rightSideView.addConstraintsWithFormat("V:|-29-[v0(22)]", views: reminderButton)
        rightSideView.addConstraintsWithFormat("V:|-23-[v0(33)]", views: contactButton)
        if (contactNumberOfNotifications == 0){
            contactNumberBubble.alpha = 0
            contactNotificationsLabel.alpha = 0
        }
        else if (contactNumberOfNotifications < 10) {
            rightSideView.addConstraintsWithFormat("H:[v0(15)]-26-|", views: contactNumberBubble)
            rightSideView.addConstraintsWithFormat("V:|-45-[v0(15)]", views: contactNumberBubble)
            rightSideView.addConstraintsWithFormat("H:[v0(15)]-25-|", views: contactNotificationsLabel)
            rightSideView.addConstraintsWithFormat("V:|-45-[v0(15)]", views: contactNotificationsLabel)
            contactNotificationsLabel.text = " \(contactNumberOfNotifications)"
        }
        else if (contactNumberOfNotifications >= 10 && contactNumberOfNotifications < 100){
            rightSideView.addConstraintsWithFormat("H:[v0(15)]-26-|", views: contactNumberBubble)
            rightSideView.addConstraintsWithFormat("V:|-45-[v0(15)]", views: contactNumberBubble)
            rightSideView.addConstraintsWithFormat("H:[v0(15)]-25-|", views: contactNotificationsLabel)
            rightSideView.addConstraintsWithFormat("V:|-45-[v0(15)]", views: contactNotificationsLabel)
        }
        else if (contactNumberOfNotifications >= 100 ){
            if (contactNumberOfNotifications >= 1000){
                contactNotificationsLabel.text = String(currentUser.events.count)
            }
            rightSideView.addConstraintsWithFormat("H:[v0(20)]-26-|", views: contactNumberBubble)
            rightSideView.addConstraintsWithFormat("V:|-41-[v0(20)]", views: contactNumberBubble)
            rightSideView.addConstraintsWithFormat("H:[v0(21)]-25-|", views: contactNotificationsLabel)
            rightSideView.addConstraintsWithFormat("V:|-41-[v0(20)]", views: contactNotificationsLabel)
        }
        
        
        
        if (reminderNumberOfNotifications == 0){
            reminderNumberBubble.alpha = 0
            reminderNotificationsLabel.alpha = 0
        }
        else if (reminderNumberOfNotifications < 10){
            reminderNumberBubble.layer.cornerRadius = 2.5
            rightSideView.addSubview(reminderNumberBubble)
            
            rightSideView.bringSubviewToFront(reminderNotificationsLabel)
            rightSideView.addConstraintsWithFormat("H:[v0(15)]-86-|", views: reminderNumberBubble)
            rightSideView.addConstraintsWithFormat("V:|-45-[v0(15)]", views: reminderNumberBubble)
            rightSideView.addConstraintsWithFormat("H:[v0(15)]-85-|", views: reminderNotificationsLabel)
            rightSideView.addConstraintsWithFormat("V:|-45-[v0(15)]", views: reminderNotificationsLabel)
            reminderNotificationsLabel.text = " \(reminderNumberOfNotifications)"
        }
        else if (reminderNumberOfNotifications >= 10 && reminderNumberOfNotifications < 100){
            reminderNumberBubble.layer.cornerRadius = 2.5
            rightSideView.addSubview(reminderNumberBubble)
            
            rightSideView.bringSubviewToFront(reminderNotificationsLabel)
            rightSideView.addConstraintsWithFormat("H:[v0(15)]-86-|", views: reminderNumberBubble)
            rightSideView.addConstraintsWithFormat("V:|-45-[v0(15)]", views: reminderNumberBubble)
            rightSideView.addConstraintsWithFormat("H:[v0(15)]-85-|", views: reminderNotificationsLabel)
            rightSideView.addConstraintsWithFormat("V:|-45-[v0(15)]", views: reminderNotificationsLabel)
        }
        else if (reminderNumberOfNotifications >= 100){
            if (reminderNumberOfNotifications >= 1000){
                reminderNotificationsLabel.text = String(currentUser.reminders.count)
            }
            let wholeReminderBubble = UIView()
            
            let reminderNumberBubble2 = UIView()
            let reminderNumberBubble3 = UIView()
            let reminderNumberBubble4 = UIView()
            
            reminderNumberBubble2.backgroundColor = UIColor.meshRed()
            reminderNumberBubble3.backgroundColor = UIColor.meshRed()
            reminderNumberBubble4.backgroundColor = UIColor.meshRed()
            
            wholeReminderBubble.backgroundColor = UIColor.meshRed()
            wholeReminderBubble.layer.cornerRadius = 3.0
            rightSideView.addSubview(wholeReminderBubble)
            rightSideView.bringSubviewToFront(reminderNotificationsLabel)
            
            rightSideView.addConstraintsWithFormat("H:[v0(20)]-84-|", views: wholeReminderBubble)
            rightSideView.addConstraintsWithFormat("V:|-40-[v0(20)]", views: wholeReminderBubble)
            
            
            rightSideView.addConstraintsWithFormat("H:[v0(21)]-83-|", views: reminderNotificationsLabel)
            rightSideView.addConstraintsWithFormat("V:|-40-[v0(20)]", views: reminderNotificationsLabel)
        }
        
        //        let rightSideButtons = UIBarButtonItem(customView: rightSideView)
        
        masterNavBar.addSubview(rightSideView)
        
        masterNavBar.addConstraintsWithFormat("H:|-10-[v0(55)][v1(100)]-10-|", views: leftSideView, rightSideView)
        masterNavBar.addConstraintsWithFormat("V:|[v0(80)]|", views: leftSideView)
        masterNavBar.addConstraintsWithFormat("V:|[v0(80)]|", views: rightSideView)
        
        masterNavBar.backgroundColor = UIColor.whiteColor()
        masterNavBar.userInteractionEnabled = true
        leftSideView.userInteractionEnabled = true
        rightSideView.userInteractionEnabled = true
        
        let tappedNavBarOnce = UITapGestureRecognizer(target: self, action: #selector(navBarTouched))
        let tappedNavBarTwice = UITapGestureRecognizer(target: self, action: #selector(moveNewsFeedToTop))
        tappedNavBarTwice.numberOfTapsRequired = 2
        masterNavBar.addGestureRecognizer(tappedNavBarOnce)
        masterNavBar.addGestureRecognizer(tappedNavBarTwice)
        
        //        wholeView.addSubview(masterNavBar)
        adjustmentView.addSubview(masterNavBar)
        adjustmentView.addConstraintsWithFormat("V:|-9-[v0]", views: masterNavBar)
        adjustmentView.addConstraintsWithFormat("H:|[v0]|", views: masterNavBar)
        wholeView.addSubview(adjustmentView)
        
        
        //        navigationItem.rightBarButtonItems = [rightSideButtons ]
        
        //Box behind NavBar to ensure correct coloring of NavBar
        //        let frame = self.view.frame
        //        let NavBarColorFixer = UIView(frame: CGRectMake(frame.origin.x, frame.origin.y, view.frame.width, 64))
        //        NavBarColorFixer.backgroundColor = UIColor.whiteColor()
        //        self.view.addSubview(NavBarColorFixer)
    }
    
    //Bringing out the Big Red Menu
    func bringOutTheBigRedMenu(){
        let frame = self.view.frame
        bigRedMenuBool = true
        
        clearView = UIView(frame: CGRectMake(0, 0, frame.width, frame.height))
        clearView.backgroundColor = UIColor.clearColor()
        let tappedClearView = UITapGestureRecognizer(target: self, action: #selector(clearViewTapped))
        clearView.addGestureRecognizer(tappedClearView)
        view.addSubview(clearView)
       
        bigRedMenu = UIView(frame: CGRectMake(frame.origin.x, frame.origin.y, ceil(self.view.frame.width * (2/3))  , frame.height))
        bigRedMenu.backgroundColor = UIColor.meshRed()
        
        
        let slideInFromLeftTransition = CATransition()
        slideInFromLeftTransition.type = kCATransitionPush
        slideInFromLeftTransition.subtype = kCATransitionFromLeft
        slideInFromLeftTransition.duration = 0.3
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromLeftTransition.fillMode = kCAFillModeRemoved
        bigRedMenu.layer.addAnimation(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
        
        let  whiteCollapseLeft = UIButton(type: .Custom)
        whiteCollapseLeft.setImage(UIImage(named: "icon collapse left white"), forState: .Normal)
        whiteCollapseLeft.addTarget(self , action: #selector(removeBigRedMenu), forControlEvents: UIControlEvents.TouchUpInside)
        
        let navigationButton = UIButton(type: .Custom)
        navigationButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        let stringFormat = NSMutableAttributedString(string: "Navigation", attributes: [NSFontAttributeName: UIFont(name: "Calibri-Light", size: 28)!, NSForegroundColorAttributeName: UIColor.whiteColor()])
        navigationButton.setAttributedTitle(stringFormat, forState: .Normal)
        navigationButton.addTarget(self , action: #selector(removeBigRedMenu), forControlEvents: UIControlEvents.TouchUpInside)
        
        let settingsButton = UIButton(type: .Custom)
        settingsButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        let stringFormat2 = NSMutableAttributedString(string: "Settings", attributes: [NSFontAttributeName: UIFont(name: "Calibri-Light", size: 28)!, NSForegroundColorAttributeName: UIColor.whiteColor()])
        settingsButton.setAttributedTitle(stringFormat2, forState: .Normal)
        settingsButton.addTarget(self, action: #selector(settingsClicked), forControlEvents: UIControlEvents.TouchUpInside)
        
        let settingsLogo = UIButton(type: .Custom)
        settingsLogo.setImage(UIImage(named: "icon sidebar settings"), forState: .Normal)
        settingsLogo.addTarget(self, action: #selector(settingsClicked), forControlEvents: UIControlEvents.TouchUpInside)
        
        let whiteLogo = UIButton(type: .Custom)
        whiteLogo.setImage( UIImage(named: "mesh logo small white"), forState: .Normal)
        whiteLogo.addTarget(self, action: #selector(removeBigRedMenu), forControlEvents: UIControlEvents.TouchUpInside)
        bigRedMenu.addSubview(whiteLogo)
        bigRedMenu.addSubview(whiteCollapseLeft)
        bigRedMenu.addSubview(navigationButton)
        bigRedMenu.addSubview(settingsLogo)
        bigRedMenu.addSubview(settingsButton)
        bigRedMenu.addSubview(bigRedCollectionView.view)
        bigRedMenu.addConstraintsWithFormat("H:|-15-[v0(40)][v1(8)]-8-[v2]", views: whiteLogo, whiteCollapseLeft, navigationButton)
        bigRedMenu.addConstraintsWithFormat("V:|-19-[v0(40)]", views: whiteLogo)
        bigRedMenu.addConstraintsWithFormat("V:|-44-[v0(15)]", views: whiteCollapseLeft)
        bigRedMenu.addConstraintsWithFormat("V:|-23-[v0(40)]", views: navigationButton)
        bigRedMenu.addConstraintsWithFormat("V:|-70-[v0]-70-|", views: bigRedCollectionView.view)
        bigRedMenu.addConstraintsWithFormat("H:|[v0]|", views: bigRedCollectionView.view)
        bigRedMenu.addConstraintsWithFormat("H:|-20-[v0(30)]-8-[v1]", views: settingsLogo, settingsButton)
        bigRedMenu.addConstraintsWithFormat("V:[v0(30)]-15-|", views: settingsLogo)
        bigRedMenu.addConstraintsWithFormat("V:[v0]-10-|", views: settingsButton)
        
        let swipeLeftOnMenu = UISwipeGestureRecognizer(target: self, action: #selector(swipedOnMenu))
        swipeLeftOnMenu.direction = UISwipeGestureRecognizerDirection.Left
        bigRedMenu.addGestureRecognizer(swipeLeftOnMenu)
        
        view.addSubview(bigRedMenu)
        view.bringSubviewToFront(bigRedMenu)
        
        
    }
    
    func swipedOnMenu(gesture: UISwipeGestureRecognizer){
        removeBigRedMenu()
    }
    
    func reminderButtonAction() {
        removeCornerMenu()
        let remindersVC = UIStoryboard(name: "Reminders", bundle: nil).instantiateViewControllerWithIdentifier("Reminders")
        remindersVC.modalPresentationStyle = .Popover
        remindersVC.preferredContentSize = CGSize(width: 400, height: 600)
        let popup = remindersVC.popoverPresentationController
        popup?.sourceView = self.view
        popup?.delegate = self //*****
        //masterView.view.bringSubviewToFront(addContactPopUp.view)
        popup?.sourceRect = CGRectMake(0, 0, 50, 50)
        popup?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        self.presentViewController(remindersVC, animated: true, completion: nil)
    }
    
    func contactButtonAction() {
        removeCornerMenu()
        let eventTableVC = UIStoryboard(name: "EventsTable", bundle: nil).instantiateViewControllerWithIdentifier("EventsTable")
        eventTableVC.modalPresentationStyle = .Popover
        eventTableVC.preferredContentSize = CGSize(width: 400, height: 600)
        let popup = eventTableVC.popoverPresentationController
        popup?.sourceView = self.view
        popup?.delegate = self //*****
        //masterView.view.bringSubviewToFront(addContactPopUp.view)
        popup?.sourceRect = CGRectMake(0, 0, 50, 50)
        popup?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        self.presentViewController(eventTableVC, animated: true, completion: nil)
    }
    
    func navBarTouched(gesture: UITapGestureRecognizer) {
        if (masterPageIdentificationNum == 0){
           searchBox.resignFirstResponder()
        }
        if (masterPageIdentificationNum == 1){
            profileView.searchBox.resignFirstResponder()
        }
    }
    
    func moveNewsFeedToTop(gesture: UITapGestureRecognizer) {
        if (masterPageIdentificationNum == 0){
            newsFeedView.collectionView?.setContentOffset(CGPointMake(0, 0), animated: true)
        }
    }
    
    //When area behind RedMenu is touched
    func clearViewTapped(gesture: UITapGestureRecognizer) {
        removeBigRedMenu()
    }
    
    //When the Big Red Menu needs to go away
    func removeBigRedMenu(){
        bigRedMenuBool = false
        clearView.removeFromSuperview()
        let menuWidth = bigRedMenu.bounds.width
        
        let offstageLeft = CGAffineTransformMakeTranslation( -menuWidth, 0)
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            bigRedMenu.transform = offstageLeft
            }, completion: {(finished:Bool) in
                self.finishOffBigRedMenu()
        })
        
    }
    
    func finishOffBigRedMenu() {
        bigRedMenu.removeFromSuperview()
    }
    
    //Makes bottom right corner button
    func createCornerButton(){
        cornerQuickAccessButton = UIButton(frame: CGRectMake(view.frame.width - 75, view.frame.height - 75, 65, 65))
        cornerQuickAccessButton.setImage(UIImage(named: "icon contact add"), forState: .Normal)
        cornerQuickAccessButton.addTarget(self, action: #selector(bringCornerMenu), forControlEvents: .TouchUpInside)
        view.addSubview(cornerQuickAccessButton)
        
    }
    
    //When you hit the lower right hand corner button
    func bringCornerMenu() {
        if (!cornerMenuBool){
            cornerMenuBool = true
            
            UIView.animateWithDuration(0.3, animations: {
                cornerQuickAccessButton.alpha = 1
            })
            
            let frame = self.view.frame
            dimming = UIView(frame: CGRectMake(frame.origin.x, frame.origin.y, view.frame.width, view.frame.height))
            dimming.backgroundColor = UIColor.whiteColor()
            dimming.alpha = 0.5
            
            let slideInFromBottomTransition = CATransition()
            slideInFromBottomTransition.type = kCATransitionPush
            slideInFromBottomTransition.subtype = kCATransitionFromBottom
            slideInFromBottomTransition.duration = 0.3
            slideInFromBottomTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            slideInFromBottomTransition.fillMode = kCAFillModeRemoved
            
            addNearbyContactLabelPic = UIButton(frame: CGRectMake(view.frame.width - 170, view.frame.height - 116, 103, 35))
            addNearbyContactLabelPic.setImage( UIImage(named: "add nearby"), forState: .Normal)
            addNearbyContactLabelPic.layer.addAnimation(slideInFromBottomTransition, forKey: "slideInFromBottomTransition")
            addNearbyContactLabelPic.addTarget(self, action: #selector(addNearbyAction), forControlEvents: .TouchUpInside)
            
            addNearbyContactIcon = UIButton(frame: CGRectMake(view.frame.width - 65, view.frame.height - 125, 50, 50))
            addNearbyContactIcon.setImage( UIImage(named: "icon add nearby"), forState: .Normal)
            addNearbyContactIcon.layer.addAnimation(slideInFromBottomTransition, forKey: "slideInFromBottomTransition")
            addNearbyContactIcon.addTarget(self, action: #selector(addNearbyAction), forControlEvents: .TouchUpInside)
            
            scanQRCodeLabelPic = UIButton(frame: CGRectMake(view.frame.width - 170, view.frame.height - 166, 103, 35))
            scanQRCodeLabelPic.setImage( UIImage(named: "scan QR"), forState: .Normal)
            scanQRCodeLabelPic.layer.addAnimation(slideInFromBottomTransition, forKey: "slideInFromBottomTransition")
            scanQRCodeLabelPic.addTarget(self, action: #selector(scanQRCodeAction), forControlEvents: .TouchUpInside)
            
            scanQRCodeIcon = UIButton(frame: CGRectMake(view.frame.width - 65, view.frame.height - 175, 50, 50))
            scanQRCodeIcon.setImage( UIImage(named: "icon scan QR"), forState: .Normal)
            scanQRCodeIcon.layer.addAnimation(slideInFromBottomTransition, forKey: "slideInFromBottomTransition")
            scanQRCodeIcon.addTarget(self, action: #selector(scanQRCodeAction), forControlEvents: .TouchUpInside)
            
            myQRCodeLabelPic = UIButton(frame: CGRectMake(view.frame.width - 170, view.frame.height - 216, 103, 35))
            myQRCodeLabelPic.setImage( UIImage(named: "background my QR code"), forState: .Normal)
            myQRCodeLabelPic.layer.addAnimation(slideInFromBottomTransition, forKey: "slideInFromBottomTransition")
            myQRCodeLabelPic.addTarget(self, action: #selector(myQRCodeAction), forControlEvents: .TouchUpInside)
            
            myQRCodeIcon = UIButton(frame: CGRectMake(view.frame.width - 65, view.frame.height - 225, 50, 50))
            myQRCodeIcon.setImage( UIImage(named: "icon qr bubble"), forState: .Normal)
            myQRCodeIcon.layer.addAnimation(slideInFromBottomTransition, forKey: "slideInFromBottomTransition")
            myQRCodeIcon.addTarget(self, action: #selector(myQRCodeAction), forControlEvents: .TouchUpInside)
            
            addManuallyContactLabelPic = UIButton(frame: CGRectMake(view.frame.width - 170, view.frame.height - 266, 103, 35))
            addManuallyContactLabelPic.setImage( UIImage(named: "Add contact bubble text button"), forState: .Normal)
            addManuallyContactLabelPic.layer.addAnimation(slideInFromBottomTransition, forKey: "slideInFromBottomTransition")
            addManuallyContactLabelPic.addTarget(self, action: #selector(addManuallyAction), forControlEvents: .TouchUpInside)
            
            addManuallyContactIcon = UIButton(frame: CGRectMake(view.frame.width - 65, view.frame.height - 275, 50, 50))
            addManuallyContactIcon.setImage( UIImage(named: "Icon add manually"), forState: .Normal)
            addManuallyContactIcon.layer.addAnimation(slideInFromBottomTransition, forKey: "slideInFromBottomTransition")
            addManuallyContactIcon.addTarget(self, action: #selector(addManuallyAction), forControlEvents: .TouchUpInside)
            
            cornerQuickAccessButton.removeFromSuperview()
            view.addSubview(dimming)
            view.addSubview(cornerQuickAccessButton)
            view.addSubview(addNearbyContactLabelPic)
            view.addSubview(addNearbyContactIcon)
            view.addSubview(scanQRCodeLabelPic)
            view.addSubview(scanQRCodeIcon)
            view.addSubview(myQRCodeLabelPic)
            view.addSubview(myQRCodeIcon)
            view.addSubview(addManuallyContactLabelPic)
            view.addSubview(addManuallyContactIcon)
            cornerQuickAccessButton.alpha = 1
            
            
            
            let tapDimmingView = UITapGestureRecognizer(target: self, action: #selector(removeCornerMenu))
            dimming.addGestureRecognizer(tapDimmingView)
            
        }
        else{
            removeCornerMenu()
        }
        
    }
    
    
    //when "Add contact" is selected from corner menu
    func addManuallyAction() {
        self.presentViewController(addContactManuallyVC, animated: true, completion: nil)
    }

    
    //when "Add nearby" is selected from corner menu
    func addNearbyAction() {//*****
        removeCornerMenu()
        let addContactPopUpVC = UIStoryboard(name: "AddNearby", bundle: nil).instantiateViewControllerWithIdentifier("AddNearby")
        
        addContactPopUpVC.modalPresentationStyle = .Popover
        addContactPopUpVC.preferredContentSize = CGSize(width: 400, height: 400)
        let popup = addContactPopUpVC.popoverPresentationController
        //let centerX = 300
        //let centerY = 375
        popup?.sourceView = self.view
        popup?.delegate = self //*****
        //masterView.view.bringSubviewToFront(addContactPopUp.view)
        popup?.sourceRect = CGRectMake(0, 0, 50, 50)
        popup?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        self.presentViewController(addContactPopUpVC, animated: true, completion: nil)
    }
    
    //when "Scan QR Code" is selected from corner menu
    func scanQRCodeAction() {
        removeCornerMenu()
        self.presentViewController(scanner, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle { //*****
        // Return no adaptive presentation style, use default presentation behaviour
        return .None
    }
    
    //when "My QR Code" is selected from corner menu
    func myQRCodeAction() {
        let frame = self.view.frame
        removeCornerMenu()
        qrCodeDisplay = UIView(frame: CGRectMake(floor(frame.width/2) - 125, floor(frame.height/2) - 175, 250, 250))
        qrCodeDisplay.layer.cornerRadius = 10
        qrCodeDisplay.backgroundColor = UIColor.meshRed()
        qrCodeDisplay.alpha = 0.8

        let qrImage = generateQRCode(currentUser.userId)
        let qrView = UIImageView(image: qrImage)
        let colorMask = UIView()
        colorMask.backgroundColor = UIColor.meshRed()
        colorMask.alpha = 0.6
        
        qrCodeDisplay.addSubview(qrView)
        qrCodeDisplay.addSubview(colorMask)
        qrCodeDisplay.addConstraintsWithFormat("H:|[v0]|", views: qrView)
        qrCodeDisplay.addConstraintsWithFormat("V:|[v0]|", views: qrView)
        qrCodeDisplay.addConstraintsWithFormat("H:|[v0(250)]|", views: colorMask)
        qrCodeDisplay.addConstraintsWithFormat("V:|[v0(250)]|", views: colorMask)
        view.addSubview(qrCodeDisplay)
        
        qrCodeDisplayMask = UIView(frame: CGRectMake(0, 0, frame.width, frame.height))
        qrCodeDisplayMask.backgroundColor = UIColor.clearColor()
        let tap = UITapGestureRecognizer(target: self, action: #selector(removeTheQRStuff))
        qrCodeDisplayMask.addGestureRecognizer(tap)
        view.addSubview(qrCodeDisplayMask)
        
    }
    
    func removeTheQRStuff(){
        qrCodeDisplayMask.removeFromSuperview()
        qrCodeDisplay.removeFromSuperview()
    }
    
    func settingsClicked() {
      removeBigRedMenu()
      self.presentViewController(settingsPage, animated: true, completion: nil)
    }
    
    func presentAddEventVC() {
        self.presentViewController(addEventVC, animated: true, completion: nil)
    }
    
    //Used to remove corner menu
    func removeCornerMenu(){
        UIView.animateWithDuration(0.3, animations: {
            dimming.alpha = 0
            addManuallyContactLabelPic.alpha = 0
            addNearbyContactLabelPic.alpha = 0
            addNearbyContactIcon.alpha = 0
            scanQRCodeLabelPic.alpha = 0
            scanQRCodeIcon.alpha = 0
            myQRCodeLabelPic.alpha = 0
            myQRCodeIcon.alpha = 0
            addManuallyContactIcon.alpha = 0
            }, completion: {finished in
                dimming.removeFromSuperview()
                addManuallyContactLabelPic.removeFromSuperview()
                addNearbyContactLabelPic.removeFromSuperview()
                addNearbyContactIcon.removeFromSuperview()
                scanQRCodeLabelPic.removeFromSuperview()
                scanQRCodeIcon.removeFromSuperview()
                myQRCodeLabelPic.removeFromSuperview()
                myQRCodeIcon.removeFromSuperview()
                addManuallyContactIcon.removeFromSuperview()
                cornerMenuBool = false
                if (masterPageIdentificationNum == 1){
                    cornerQuickAccessButton.alpha = 0.5
                }
        })
        
        
    }
    

}
