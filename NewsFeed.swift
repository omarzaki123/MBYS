//
//  NewsFeed.swift
//  Mesh
//
//  Created by Daniel Ssemanda on 8/4/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import UIKit
import AVFoundation

let cellId = "cellId"
var navigationLogoImage = UIImage(named:"mesh logo login")!
//let navBar: UINavigationItem = UINavigationItem()
var masterNavBar = UIView()
var posts: [Post] = []
var newsFeedEvents: [Event] = []
var secondBar = UIView()

var cellsIsExpanded: [Int: Bool] = [:]
var cellExpandedSize: [Int: Int] = [:]

var lastScrollOffset: CGFloat = 0

var reminderNumberOfNotifications = 999
var contactNumberOfNotifications = 999
var bigRedMenu = UIView()
let bigRedCollectionView = BigRedCollectionView(collectionViewLayout: UICollectionViewFlowLayout())

var pageViewPanBlocker = UIView()

var scrollViewHeight:CGFloat = 0
var scrollContentSizeHeight:CGFloat = 0
var scrollOffset:CGFloat = 0
var cellSize = CGSize()


class Post{
    var name: String?
    var titleDescription: String?
    var profilePic: UIImage?
    var statusText: String?
    var statusImage: UIImage?
    var location: String?
    var date: NSDate?
    var startTime: NSDate?
    var endTime: NSDate?
}


class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let customCellIdentifier = "customCellIdentifier"
    var bigRedMenuBool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let frame = self.view.frame
        secondBar = UIView(frame: CGRectMake(frame.origin.x, frame.origin.y + 66, view.frame.width, 36))
//        self.navigationController?.navigationBarHidden = true
        secondBar.alpha = 0
        
//        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
//        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        
        //Deals with tapping collectionview and navbar when stuff is open
//        thingsToDoWhenNavBarOrCollectionViewTapped()
        
        //Manually constructing posts
        customCreatedPosts()
        
        //TODO: should school be required when signing up?
//        if currentUser.school != "" {
//            getSchoolEvents(currentUser.school) { (events) in
//                newsFeedEvents = events
//                for event in events {
//                    let post = Post()
//                    post.name = event.company
//                    post.statusText = event.eventDescription
//                    // TODO: get picture
//                    posts.append(post)
//                    dispatch_async(dispatch_get_main_queue()) {
//                        self.collectionView?.reloadData()
//                    }
//                }
//            }
//        }
        
        
//        var events = [Event]()
//        let event1 = Event()
//        event1.company = "The Boston Consulting Group"
//        event1.eventDescription = "We will be visiting Stanford soon at the career fair. Come talk to us!"
//        event1.assignUUID()
//        events.append(event1)
//        let event2 = Event()
//        event2.company = "Goldman Sachs"
//        event2.eventDescription = "There will be a networking mixer at the Graduate School of Business"
//        event2.assignUUID()
//        events.append(event2)
//        for event in events {
//            pushEventToSchools(currentUser.school, event: event)
//        }
        
        
        //Creating the a second NavBar to store search button
        createSecondNavBar()
        
        //removes atomatic space for navbar inherent within collection view
        self.automaticallyAdjustsScrollViewInsets = false
        
        //Quick NavBar Setup stuff
        collectionView?.alwaysBounceVertical = true //Nice bounce effect when scrolling
        //        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.backgroundColor = UIColor.rgb(230, green: 231, blue: 232)
        collectionView?.registerClass(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.delegate = self
        collectionView?.dataSource = self
//        collectionView!.decelerationRate = UIScrollViewDecelerationRateFast
        self.view.addSubview(pageViewPanBlocker)
        
        for i in 0 ..< posts.count {
           cellsIsExpanded.updateValue(false, forKey: i)
           cellExpandedSize.updateValue(250, forKey: i)
        }
    }
    
//    override func viewDidAppear(animated: Bool) {
//        masterPageIdentificationNum = 0
//        let cell0 = bigRedCollectionView.collectionView!.cellForItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
//        cell0?.contentView.backgroundColor = UIColor.lightGrayColor()
//        
//        let cell1 = bigRedCollectionView.collectionView!.cellForItemAtIndexPath(NSIndexPath(forRow: 1, inSection: 0))
//        cell1?.contentView.backgroundColor = UIColor.meshRed()
//        
//        let cell2 = bigRedCollectionView.collectionView!.cellForItemAtIndexPath(NSIndexPath(forRow: 2, inSection: 0))
//        cell2?.contentView.backgroundColor = UIColor.meshRed()
//        
//        let cell3 = bigRedCollectionView.collectionView!.cellForItemAtIndexPath(NSIndexPath(forRow: 3, inSection: 0))
//        cell3?.contentView.backgroundColor = UIColor.meshRed()
//        
//        barNameLabel.text = "News Feed"
//        
//        UIView.animateWithDuration(0.3, animations: {
//            cornerQuickAccessButton.alpha = 1
//        })
//        secondBar.alpha = 1
//    }
//    
    //Manually constructing posts
    func customCreatedPosts(){
        let postDan = Post()
        postDan.name = "The Boston Consulting Group"
        postDan.titleDescription = "Booth Will be Open at Yale Career Fair"
        postDan.profilePic = UIImage(named: "bcg_Logo")
        postDan.statusText = "There will be a booth for people come speak to recruiters from multiple different companies. Get there early, the event will be packed."
       postDan.statusImage = UIImage(named: "accenture")
       postDan.location = "Office of Career Strategy"
        
        
        
        let postMawi = Post()
        postMawi.name = "Omar Zaki"
        postMawi.titleDescription = "Ls will be taken"
        postMawi.profilePic = UIImage(named: "Hillary")
        
        //Adding manually constructed posts to Array
        posts.append(postDan)
        posts.append(postMawi)
        posts.append(postMawi)
        posts.append(postMawi)
        posts.append(postMawi)
        posts.append(postMawi)
        posts.append(postDan)
        posts.append(postMawi)
        posts.append(postDan)
        posts.append(postDan)
        posts.append(postMawi)
        posts.append(postDan)
        posts.append(postMawi)
        posts.append(postDan)
        posts.append(postMawi)
        posts.append(postDan)
    }
    
    
    //Setting where the collectionView will be located and its size
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let frame = self.view.frame
        self.collectionView!.frame = CGRectMake(frame.origin.x, frame.origin.y + 66, frame.size.width, frame.size.height - 66)
    }
    
    //How many total cells will be displayed
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    
//    func addEvent(sender: UIGestureRecognizer) {
//        let touch = sender.locationInView(collectionView)
//        let indexPath = collectionView?.indexPathForItemAtPoint(touch)
//        if let path = indexPath {
//            let event = newsFeedEvents[path.item]
//            addEventVC.companyEvent = event
//            // TODO: There is a bug when presenting this event that causes the newsfeed to disappear after addEventVC is presented
//            //self.presentViewController(addEventVC, animated: true, completion: nil)
//            
//        }
//    }
    
    

    //Sets the distance between cells and the top of the view
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    let frame : CGRect = self.view.frame
    let margin  = (frame.width - 90 * 3) / 6.0
    return UIEdgeInsetsMake(36, margin, 10, margin)  //First number sets distance from the top
    
    }
    
    //Function to handle the effects of screen rotation
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    //Keeps track of scrolling up or down and whether at top or bottom
    override func scrollViewDidScroll(scrollView: UIScrollView) {
         scrollViewHeight = scrollView.frame.size.height
         scrollContentSizeHeight = scrollView.contentSize.height
         scrollOffset = scrollView.contentOffset.y
        
        if (lastScrollOffset > scrollOffset && scrollOffset != 0 && (scrollOffset + scrollViewHeight <= scrollContentSizeHeight)){
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                secondBar.alpha = 1
                }, completion: nil)
      
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                cornerQuickAccessButton.alpha = 1
                }, completion: nil)
        }
        else if (lastScrollOffset < scrollOffset && (scrollOffset + scrollViewHeight != scrollContentSizeHeight) && scrollOffset >= 0){
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                secondBar.alpha = 0
                }, completion: nil)
            
        }
        
        lastScrollOffset = scrollOffset
        
        if (scrollOffset == 0)
        {
            print("Im at the top")
            secondBar.alpha = 1
            
            
        }
        else if (scrollOffset + scrollViewHeight == scrollContentSizeHeight)
        {
            print("Im at the bottom!!!")
            secondBar.alpha = 0
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                cornerQuickAccessButton.alpha = 0.2
                }, completion: nil)
        }
        
    }
 
       //Creating the a second NavBar to store search button
    func createSecondNavBar() {
//        let frame = self.view.frame
        secondBar.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(secondBar)
        
        let frame = self.view.frame
        pageViewPanBlocker = UIView(frame: CGRectMake(0, 102, frame.width, frame.height - 66))
        pageViewPanBlocker.backgroundColor = UIColor.clearColor()
        pageViewPanBlocker.alpha = 0
        let panPreventer = UIPanGestureRecognizer(target: self, action: #selector(doesNothing))
        let tappedPanBlocker = UITapGestureRecognizer(target: self, action: #selector(releaseSearchBar))
        pageViewPanBlocker.addGestureRecognizer(tappedPanBlocker)
        pageViewPanBlocker.addGestureRecognizer(panPreventer)
        
        

        searchBox.delegate = searchBarWorking
        
        searchBox.layer.borderWidth = 1.0
        searchBox.layer.borderColor = UIColor.blackColor().CGColor
        searchBox.placeholder = "Type a company name"
        searchBox.layer.cornerRadius = 5
        searchBox.barTintColor = UIColor.rgb(230, green: 231, blue: 232)
        searchBoxTextField = (searchBox.valueForKey("searchField") as? UITextField)!
        searchBoxTextField.backgroundColor = UIColor.rgb(230, green: 231, blue: 232)
        
        secondBar.addSubview(searchBox)
        secondBar.addConstraintsWithFormat("V:|-6-[v0(24)]", views: searchBox)
        secondBar.addConstraintsWithFormat("H:|-2-[v0]-2-|", views: searchBox)
        
        
        let tappedCollectionView = UITapGestureRecognizer(target: self, action: #selector(touchedNewsFeed))
        collectionView?.addGestureRecognizer(tappedCollectionView)
        
    }
    
    func releaseSearchBar(){
        searchBox.resignFirstResponder()
    }
    
    func doesNothing() {
        //Don't delete this, it is necessary to block pageView's panning in some instances
    }
    
    func touchedNewsFeed(gesture: UITapGestureRecognizer){
        searchBox.resignFirstResponder()
    }

    //When you touch the searchbox, the field changes to this color
    func touchedSearchBox(gesture: UITapGestureRecognizer) {
        searchBox.backgroundColor = UIColor.rgb(176, green: 238, blue: 237)
    }
    
    //Stuff to do before any segue occurrs
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let navigationPageViewController = segue.destinationViewController as? NavigationPageView {
            navigationPageViewController.pageViewDelegate = self
        }
    }
    
    //Sets the cize of each cell
    func collectionView(collectionView: UICollectionView, layout collectViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if cellsIsExpanded[indexPath.item]! {
            return CGSizeMake(collectionView.frame.width, CGFloat(cellExpandedSize[indexPath.item]!))
        }
        else {
            return CGSizeMake(collectionView.frame.width, 60)
        }
    }
    
    
    //Things that are true for all cells
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //Stuff that is true for all cells
        let feedCell =  collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! FeedCell
        
        feedCell.contentView.backgroundColor = UIColor.darkGrayColor()
        feedCell.layoutIfNeeded()
        
        feedCell.post = posts[indexPath.item]
        feedCell.index = indexPath.item
        
        let post = posts[indexPath.item]
        
        if (post.location == nil && post.date == nil && post.startTime == nil){
            feedCell.addEventViewButton.alpha = 0
        }
        else { feedCell.addEventViewButton.alpha = 1 }
        
        feedCell.frame.origin.x = 0
        return feedCell
    }
    
}


extension FeedController: NavigationPageViewControllerDelegate {
    func navigationPageViewController(navigationPageViewController: NavigationPageView,
                                      didUpdatePageCount count: Int) {
        
    }
    
    func navigationPageViewController(navigationPageViewController: NavigationPageView,
                                      didUpdatePageIndex index: Int){
        masterPageIdentificationNum = index
    }
}

class FeedCell: UICollectionViewCell {
    
//    var collectionView: UICollectionViewController? {
//        // Allow the add event button to register taps
//        didSet {
//            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: collectionView, action: #selector(self.addEvent))
//            addEventViewButton.addGestureRecognizer(tap)
//        }
//    }
    
    func addEvent() {
        print(post?.titleDescription)
    }
    
    //Stuff that is unique to a cell
    var post: Post? {
        didSet {
            clearOldContent()
            
            let nameAttributedText = NSMutableAttributedString(string: "", attributes: [NSFontAttributeName: UIFont(name: "Calibri-Light", size: 14)!,
                NSForegroundColorAttributeName: UIColor.rgb(65, green: 64, blue: 66)])
            if let name = post?.name {
                nameAttributedText.appendAttributedString(NSAttributedString(string: name, attributes: [NSFontAttributeName: UIFont(name: "Calibri-Light", size: 14)!,
                    NSForegroundColorAttributeName: UIColor.blackColor()]))
                }
            
            let timeSincePost = 999
            var timeSincePostMessage = ""
            if (timeSincePost < 1){
                timeSincePostMessage = "Right Now"
            }
            else if (timeSincePost < 60) {
                timeSincePostMessage = "\(timeSincePost)m ago"
            }
            else if (timeSincePost < 1440) {
                let hours = timeSincePost / 60
                timeSincePostMessage = "\(hours)hrs ago"
            }
            else if (timeSincePost < 10080 ) {
                let days = timeSincePost / 1440
                if (days == 1) {
                    timeSincePostMessage = "yesterday"
                }
                else{ timeSincePostMessage = "\(days) days ago" }
            }
            else if (timeSincePost >= 10080 ) {
                let weeks = timeSincePost / 10080
                timeSincePostMessage = "\(weeks) weeks ago"
            }
            
            nameAttributedText.appendAttributedString(NSAttributedString(string: "  \(timeSincePostMessage)", attributes: [NSFontAttributeName: UIFont(name: "Calibri-Light", size: 8)!, NSForegroundColorAttributeName: UIColor.rgb(88, green: 89, blue: 91)]))
            
            companyNameLabel.attributedText = nameAttributedText
            
            if let titleText = post?.titleDescription{
               let titleTextSize = getMinimumFontSizeNeededCalibri(titleText, numberOfLines: 2, width: frame.width - 60, fontSizeStart: 14)
               let titleAtt = NSMutableAttributedString(string: titleText, attributes: [NSFontAttributeName: UIFont(name: "Calibri-Light", size: titleTextSize)!,
                    NSForegroundColorAttributeName: UIColor.darkGrayColor()])
                eventTitleLabel.attributedText = titleAtt
            }
            
            if let status = post?.statusText{
                let statusAtt = NSMutableAttributedString(string: status, attributes: [NSFontAttributeName: UIFont(name: "Calibri-Light", size: 14)!,
                    NSForegroundColorAttributeName: UIColor.darkGrayColor()])
                eventDescription.attributedText = statusAtt
            }
            
            if let statusImage = post?.statusImage{ //the image
                eventImage.image = statusImage
            }
            
            if let profileImage = post?.profilePic{
                profileImageView.setImage(profileImage, forState: .Normal)
            }
            
            let wholeWidth = UIScreen.mainScreen().bounds.width
            
            let locationLabel = UILabel()
            if let location = post?.location{
                let locationAttributefText = NSMutableAttributedString(string: "Location: ", attributes: [NSFontAttributeName: UIFont(name: "Calibri-Light", size: 12)!, NSForegroundColorAttributeName: UIColor.meshRed()])
                
                let minLocS = getMinimumFontSizeNeededCalibri(location, numberOfLines: 1, width: wholeWidth - 105, fontSizeStart: 12)
                
                let locationInfoAttributedText = NSMutableAttributedString(string: location, attributes: [NSFontAttributeName: UIFont(name: "Calibri-Light", size: minLocS)!, NSForegroundColorAttributeName: UIColor.rgb(65, green: 64, blue: 66)])
                locationAttributefText.appendAttributedString(locationInfoAttributedText)
                locationLabel.attributedText = locationAttributefText
            }
            
            let eventLabel = UILabel()
            let dateTimeLabel = UILabel()
            if (locationLabel.attributedText != nil){
            let eventAttributedText = NSMutableAttributedString(string: "Event", attributes: [NSFontAttributeName: UIFont(name: "Calibri-Light", size: 16)!, NSForegroundColorAttributeName: UIColor.meshRed(), NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue])
            eventLabel.attributedText = eventAttributedText
                
            let dateText = "Tuesday, August 9th 2pm - 5pm"
            
            let minS = getMinimumFontSizeNeededCalibri(dateText, numberOfLines: 1, width: wholeWidth - 93, fontSizeStart: 14)
            let dateAttributedText = NSMutableAttributedString(string: dateText, attributes: [NSFontAttributeName: UIFont(name: "Calibri-Light", size: minS)!, NSForegroundColorAttributeName: UIColor.rgb(65, green: 64, blue: 66)])
            dateTimeLabel.attributedText = dateAttributedText
            }
            
            eventTimeAndLocView.addSubview(eventLabel)
            eventTimeAndLocView.addSubview(dateTimeLabel)
            eventTimeAndLocView.addSubview(locationLabel)
            eventTimeAndLocView.addConstraintsWithFormat("V:[v0]-5-[v1]-3-[v2]|", views: eventLabel, dateTimeLabel, locationLabel)
            eventTimeAndLocView.addConstraintsWithFormat("H:|[v0]", views: eventLabel)
            eventTimeAndLocView.addConstraintsWithFormat("H:|[v0]", views: dateTimeLabel)
            eventTimeAndLocView.addConstraintsWithFormat("H:|[v0]", views: locationLabel)
                
            
    
            
        }
        
    }
    
    func clearOldContent() {
        companyNameLabel.attributedText = nil
        eventTitleLabel.attributedText = nil
        eventDescription.attributedText = nil
        eventImage.image = nil
        profileImageView.setImage(nil, forState: .Normal)
        eventTimeAndLocView.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        setupViews()
    }
    
    //Prevents stupid xcode warning/error
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var index = 0
    
    //Name of the poster, actual text of label is set above
    let companyNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    //Short initial title description of the event
    let eventTitleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        return view
    }()
    
    //Profile picture of poster, actual image of button is set above
    var profileImageView: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        return button
    }()
    
    
    //Button to add event
    let addEventViewButton: UIButton = {
        let viewButton = UIButton()
        let bounds = UIScreen.mainScreen().bounds
        //        let attributes = newsFeedView.collectionView?.layoutAttributesForItemAtIndexPath(<#T##indexPath: NSIndexPath##NSIndexPath#>)
        viewButton.setImage(UIImage(named:"Red Calendar")! , forState: .Normal)
        return viewButton

    }()
    
    let eventDescription: UITextView = {
        let description = UITextView()
        description.scrollEnabled = false
        description.editable = false
        description.font = UIFont(name: "Calibri-Light", size: 14)
        description.textColor = UIColor.rgb(65, green: 64, blue: 66)
        description.backgroundColor = UIColor.greenColor()
        return description
    }()
    
    let eventImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.blueColor()
        return imageView
    }()
    
    let eventTimeAndLocView: UIView = {
        let view = UIView()
        return view
    }()
    
    let wholeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        return view
    }()
    
    func expandCell(){
        if cellsIsExpanded[index]! {
            cellsIsExpanded.updateValue(false, forKey: index)
            newsFeedView.collectionView!.reloadData()
            
        }
        else {
            cellsIsExpanded.updateValue(true, forKey: index)
            newsFeedView.collectionView!.reloadData()
        }

    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
          // Stuff that happens as you go from being a standard cell, to a featured one
    
        let featuredHeight = CGFloat(cellExpandedSize[index]!)
        let standardHeight = CGFloat(60)
        
        let delta = (featuredHeight - CGRectGetHeight(frame)) / (featuredHeight - standardHeight)
        
        let minAlpha: CGFloat = 0
        let maxAlpha: CGFloat = 1
        
        let alphaChange = maxAlpha - (delta * (maxAlpha - minAlpha))
        
        if (addEventViewButton.alpha == 1) {
            wholeView.addSubview(eventTimeAndLocView)
            
            wholeView.addConstraintsWithFormat("H:|-8-[v0]|", views: eventTimeAndLocView)
            wholeView.addConstraintsWithFormat("V:[v0]-10-|", views: eventTimeAndLocView)
            
            if (eventImage.image == nil){
                wholeView.addSubview(eventDescription)
                wholeView.addConstraintsWithFormat("V:|-65-[v0]-62-|", views: eventDescription)
                wholeView.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: eventDescription)
            } else {
                
                
                wholeView.addSubview(eventDescription)
                wholeView.addSubview(eventImage)
                wholeView.addConstraintsWithFormat("V:|-65-[v0]-3-[v1]-62-|", views: eventDescription, eventImage)
                wholeView.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: eventDescription)
                wholeView.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: eventImage)
                eventImage.alpha = alphaChange
           }
            
            eventDescription.alpha = alphaChange
            eventTimeAndLocView.alpha = alphaChange
        } else{
            
            
            if (eventImage.image == nil ){
                wholeView.addSubview(eventDescription)
                wholeView.addConstraintsWithFormat("V:|-65-[v0(25)]-5-|", views: eventDescription)
                wholeView.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: eventDescription)
                
            }else {
                wholeView.addSubview(eventDescription)
                wholeView.addSubview(eventImage)
                wholeView.addConstraintsWithFormat("V:|-65-[v0]-3-[v1]-5-|", views: eventDescription, eventImage)
                wholeView.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: eventDescription)
                wholeView.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: eventImage)
                eventImage.alpha = alphaChange
            }
            eventDescription.alpha = alphaChange
        }
        //        self.wholeView.alpha = alphaChange
        
   }



    
    //setting the view of each cell
    func setupViews() {
        
        wholeView.addSubview(eventTitleLabel)
        wholeView.addSubview(companyNameLabel)
        wholeView.addSubview(profileImageView)
        wholeView.addSubview(addEventViewButton)
        
        wholeView.addConstraintsWithFormat("H:|-8-[v0(44)]-8-[v1][v2(25)]-8-|", views: profileImageView, companyNameLabel, addEventViewButton)
        
        wholeView.addConstraintsWithFormat("H:|-8-[v0]-7-[v1][v2(25)]-8-|", views: profileImageView, eventTitleLabel, addEventViewButton)
        
        wholeView.addConstraintsWithFormat("V:[v0(25)]-15-|", views: addEventViewButton)
        
        wholeView.addConstraintsWithFormat("V:|-6-[v0][v1(30)]", views: companyNameLabel, eventTitleLabel)
        wholeView.addConstraintsWithFormat("V:|-8-[v0(44)]", views: profileImageView)
        
        addSubview(wholeView)
        addConstraintsWithFormat("H:|[v0]|", views: wholeView)
        addConstraintsWithFormat("V:|[v0]|", views: wholeView)
        
        let tappedView = UITapGestureRecognizer(target: self, action: #selector(expandCell))
        wholeView.addGestureRecognizer(tappedView)
    }
    
}








