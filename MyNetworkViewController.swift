//
//  MyNetworkViewController.swift
//  Mesh
//
//  Created by Kevin Kusch on 8/21/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import UIKit

class MockUser {
    var name: String?
    var company: String?
    var position: String?
    var profilePic: UIImage?
    var isFavorite: Bool?
    var isReminded: Bool?
    var email: String?
    var phone: String?
    var calendar: String?
    var resume: String?
}

class Mesh {
    var members: [User] = []
    var name: String?
    var image: UIImage?
}

enum MyNetworkState {
    case myContacts
    case myMeshes
}

class MyNetworkViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var contactsCellData:MyContactsCellData = MyContactsCellData()
    
    var viewState = MyNetworkState.myMeshes { //contacts or meshes
        didSet {
            if viewState != oldValue {
                if viewState == MyNetworkState.myContacts {
                    myContactsCollectionView.hidden = false
                    myMeshesCollectionView.hidden = true
                    myContactsCollectionView.reloadData()
                    // TODO Add code to show/move arrows on tabs
                } else {
                    myContactsCollectionView.hidden = true
                    myMeshesCollectionView.hidden = false
                    myMeshesCollectionView.reloadData()
                    // TODO Add code to show/move arrows on tabs
                }
            }
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var myContactsCollectionView: UICollectionView!
    var filteredMyContacts: [User] = []
    let cellId = "myContactsCellId"
    let selectedCellId = "myContactsExpandedCellId"
    
    @IBOutlet weak var myMeshesCollectionView: UICollectionView!
    var myMeshes: [Mesh] = []
    var filteredMyMeshes: [Mesh] = []
    let meshesCellId = "myMeshesCellId"
    let meshesSelectedCellId = "myMeshesExpandedCellId"
    
    var selectedProfileIndexPath: NSIndexPath? { //keeps track of who is selected. Tapping a cell expands view
        didSet {
            var indexPaths = [NSIndexPath]()
            if selectedProfileIndexPath != nil {
                indexPaths.append(selectedProfileIndexPath!)
            }
            if oldValue != nil {
                indexPaths.append(oldValue!)
            }
            myContactsCollectionView.performBatchUpdates({
                self.myContactsCollectionView?.reloadItemsAtIndexPaths(indexPaths)
                return
            }) {
                completed in
                if self.selectedProfileIndexPath != nil {
                    self.myContactsCollectionView?.scrollToItemAtIndexPath(self.selectedProfileIndexPath!, atScrollPosition: .CenteredVertically, animated: true)
                }
            }
        }
    }
    
    var selectedMeshIndexPath: NSIndexPath? { //same as above, but for my meshes
        didSet {
            var indexPaths = [NSIndexPath]()
            if selectedMeshIndexPath != nil {
                indexPaths.append(selectedMeshIndexPath!)
            }
            if oldValue != nil {
                indexPaths.append(oldValue!)
            }
            myMeshesCollectionView.performBatchUpdates({
                self.myMeshesCollectionView?.reloadItemsAtIndexPaths(indexPaths)
                return
            }) {
                completed in
                if self.selectedMeshIndexPath != nil {
                    self.myMeshesCollectionView?.scrollToItemAtIndexPath(self.selectedMeshIndexPath!, atScrollPosition: .CenteredVertically, animated: true)
                }
            }
        }
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if viewState == MyNetworkState.myContacts {
            if searchText.isEmpty {
                filteredMyContacts = currentUser.connections
            } else {
                filteredMyContacts = currentUser.connections.filter({(dataItem: User) -> Bool in
                    let userFullName = "\(dataItem.firstName) \(dataItem.lastName)"
                    return userFullName.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
                })
            }
            myContactsCollectionView.reloadData()
        } else {
            if searchText.isEmpty {
                filteredMyMeshes = myMeshes
            } else {
                filteredMyMeshes = myMeshes.filter({(dataItem: Mesh) -> Bool in
                    return dataItem.name!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
                })
            }
            myContactsCollectionView.reloadData()
        }
    }

    /*lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MyNetworkViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()*/
    
    // Reload the view if we just added a contact
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        filteredMyContacts = currentUser.connections
        if viewState == MyNetworkState.myContacts {
            myContactsCollectionView.reloadData()
        } else {
            myMeshesCollectionView.reloadData()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewState = MyNetworkState.myContacts
        filteredMyContacts = currentUser.connections
//        getConnections({ (users) in
//            for user in users {
//                getUserInformation(user.userId) { allUser in
//                    if let allUser = allUser {
//                        self.myContacts.append(allUser)
//                        self.filteredMyContacts.append(allUser)
//                    }
//                    self.myContactsCollectionView.reloadData()
//                }
//            }
//        })

        getMeshGroups({ (meshNames) in
            for meshName in meshNames {
                let mesh = Mesh()
                mesh.name = meshName
                getConnectionsFromGroup(meshName, callback: { (userIds) in
                    for userId in userIds {
                        getUserInformation(userId, callback: { (user) in
                            mesh.members.append(user!)
                        })
                    }
                })
            }
            self.filteredMyMeshes = self.myMeshes
            self.myMeshesCollectionView.reloadData()
        })
        
        myMeshesCollectionView.delegate = self
        myMeshesCollectionView.dataSource = self
        myMeshesCollectionView?.alwaysBounceVertical = true
        
        myContactsCollectionView.delegate = self
        myContactsCollectionView.dataSource = self
        myContactsCollectionView?.alwaysBounceVertical = true
        
        searchBar.delegate = self
    }
    
    func makeFakeInfo() {
        let user1 = MockUser()
        user1.name = "Jim Thomas"
        user1.company = "E Corp"
        user1.position = "Marketing"
        user1.isFavorite = true
        user1.isReminded = true
        user1.phone = ""
        user1.email = ""
        user1.calendar = ""
        user1.profilePic = UIImage(named: "Hillary")
//        myContacts.append(user1)
        
        let user2 = MockUser()
        user2.name = "Cindy Williams"
        user2.company = "Yale"
        user2.position = "Advisor"
        user2.isFavorite = false
        user2.isReminded = false
        user2.email = ""
        user2.resume = ""
        user2.profilePic = UIImage(named: "Hillary")
//        myContacts.append(user2)
        
        let user3 = MockUser()
        user3.name = "John Doe"
        user3.company = "Mobius"
        user3.position = "Developer"
        user3.isFavorite = true
        user3.isReminded = false
        user3.phone = ""
        user3.email = ""
        user3.profilePic = UIImage(named: "Hillary")
//        myContacts.append(user3)
        
        let mesh1 = Mesh()
        mesh1.name = "Mesh Testers"
//        mesh1.members = [user1, user2, user3]
        mesh1.image = UIImage(named: "Hillary")
        myMeshes.append(mesh1)
        
        let mesh2 = Mesh()
        mesh2.name = "Mobius VCs"
//        mesh2.members = [user2, user3]
        mesh2.image = UIImage(named: "Hillary")
        myMeshes.append(mesh2)
    }
    
    
    @IBAction func myContactsTabOnClick(sender: UIButton) {
        if viewState != MyNetworkState.myContacts {
            viewState = MyNetworkState.myContacts
        }
    }
    
    @IBAction func myMeshesTabOnClick(sender: UIButton) {
        if viewState != MyNetworkState.myMeshes {
            viewState = MyNetworkState.myMeshes
        }
    }
    
    /*func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
     
        self.networkTableView.reloadData()
        refreshControl.endRefreshing()
    }*/
    
    override func viewDidAppear(animated: Bool) {
        masterPageIdentificationNum = 1

        let cell0 = bigRedCollectionView.collectionView!.cellForItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        
        let cell1 = bigRedCollectionView.collectionView!.cellForItemAtIndexPath(NSIndexPath(forRow: 1, inSection: 0))
        
        let cell2 = bigRedCollectionView.collectionView!.cellForItemAtIndexPath(NSIndexPath(forRow: 2, inSection: 0))
        
        cell0?.contentView.backgroundColor = UIColor.meshRed()
        
        cell1?.contentView.backgroundColor = UIColor.lightGrayColor()
        
        cell2?.contentView.backgroundColor = UIColor.meshRed()
        
        barNameLabel.text = "Network"
        
        UIView.animateWithDuration(0.3, animations: {
            cornerQuickAccessButton.alpha = 1
        })
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewState == MyNetworkState.myContacts {
            return filteredMyContacts.count
        } else {
            return filteredMyMeshes.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView == myContactsCollectionView {
            if indexPath == selectedProfileIndexPath {
                let cell =  collectionView.dequeueReusableCellWithReuseIdentifier(self.selectedCellId, forIndexPath: indexPath) as! MyContactsExpandedCollectionViewCell
                
                cell.user = filteredMyContacts[indexPath.row]
                cell.cellData = self.contactsCellData
                return cell
            } else {
                let cell =  collectionView.dequeueReusableCellWithReuseIdentifier(self.cellId, forIndexPath: indexPath) as! MyContactsCollectionViewCell
                
                cell.user = filteredMyContacts[indexPath.row]
                return cell
            }
        } else {
            if indexPath == selectedMeshIndexPath {
                let cell =  collectionView.dequeueReusableCellWithReuseIdentifier(self.meshesSelectedCellId, forIndexPath: indexPath) as! MyMeshesExpandedCollectionViewCell
                
                cell.mesh = filteredMyMeshes[indexPath.row]
                cell.collapseImageView.frame = CGRectMake(cell.frame.width - 18, cell.frame.height - 17, 12.0, 12.0)
                return cell
            } else {
                let cell =  collectionView.dequeueReusableCellWithReuseIdentifier(self.meshesCellId, forIndexPath: indexPath) as! MyMeshesCollectionViewCell
                if indexPath.row >= filteredMyMeshes.count {
                    print("Not sure why this is happening") // Look into this
                } else {
                    cell.mesh = filteredMyMeshes[indexPath.row]
                }
                return cell
            }
        }
    }
    
    // TODO: Lots of magic numbers here
    func collectionView(collectionView: UICollectionView, layout collectViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if viewState == MyNetworkState.myContacts {
            var cellHeight = 60
            if indexPath == selectedProfileIndexPath {
                cellHeight = 100
            }
            return CGSizeMake(view.frame.width, CGFloat(cellHeight))
        } else {
            var cellHeight = 60
            if indexPath == selectedMeshIndexPath {
                cellHeight += 45*myMeshes[indexPath.row].members.count + 15
            }
            return CGSizeMake(view.frame.width, CGFloat(cellHeight))
        }
    }
    
    func collectionView(collectionView: UICollectionView,
                        shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        if viewState == MyNetworkState.myContacts {
            if selectedProfileIndexPath == indexPath {
                selectedProfileIndexPath = nil //collapse cell that was already expanded
            }
            else {
                selectedProfileIndexPath = indexPath
            }
            return false
        } else {
            if selectedMeshIndexPath == indexPath {
                selectedMeshIndexPath = nil
            }
            else {
                selectedMeshIndexPath = indexPath
            }
            return false
        }
    }
}

class MyContactsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var isRemindedImageView: UIImageView! //show or hide based on reminders
    
    var user: User? {
        didSet {
            nameLabel.text = " \(user!.firstName) \(user!.lastName)"
            companyLabel.text = user?.company
            positionLabel.text = user?.position
            if let profilePicture = user?.profilePicture {
                profileImageView.image = profilePicture
            } else {
                profileImageView.image = UIImage(named: "default profile picture")
            }
//            getPicture((user?.userId)!) { (image) in
//                self.profileImageView.image = image
//            }
            
//            if let reminded = user?.isReminded {
//                isRemindedImageView.hidden = !reminded
//            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

class MyContactsExpandedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var isRemindedImageView: UIImageView!
    
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var reminderButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    
    var cellData: MyContactsCellData?
//    var reminders: [User] = []
    
    var user: User? {
        didSet {
            nameLabel.text = " \(user!.firstName) \(user!.lastName)"
            companyLabel.text = user?.company
            positionLabel.text = user?.position
            if let profilePicture = user?.profilePicture {
                profileImageView.image = profilePicture
            } else {
                profileImageView.image = UIImage(named: "default profile picture")
            }
//            getPicture((user?.userId)!) { (image) in
//                self.profileImageView.image = image
//            }
            
//            reloadReminderButton()
            reloadFavoriteButton()
            reloadPhoneButton()
            reloadEmailButton()
//            reloadCalendarButton()
//            reloadResumeButton()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func phoneButtonClick(sender: UIButton) {
        if user?.phoneNumber != "" {
            // TODO: Call user
        }
    }
    
    func reloadPhoneButton() {
        if user?.phoneNumber != "" {
            phoneButton.setImage(UIImage(named: "icon phone"), forState: UIControlState.Normal)
        } else {
            phoneButton.setImage(UIImage(named: "icon phone grey"), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func emailButtonClick(sender: UIButton) {
        if user?.primaryEmail != "" {
            // TODO: start email draft to user
        }
    }
    
    func reloadEmailButton() {
        if user?.primaryEmail != "" {
            emailButton.setImage(UIImage(named: "icon mail"), forState: UIControlState.Normal)
        } else {
            emailButton.setImage(UIImage(named: "icon mail grey"), forState: UIControlState.Normal)
        }
    }
    
//    @IBAction func calendarButtonClick(sender: UIButton) {
//        if user?.calendar != nil {
//            // TODO open calendar event with this user
//        } else {
//            // Should clicking the calendar button when
//            // event does not exist open dialog to create
//            // an event with this user?
//        }
//    }
//    
//    func reloadCalendarButton() {
//        if user?.calendar != nil {
//            calendarButton.setImage(UIImage(named: "icon calendar red"), forState: UIControlState.Normal)
//        } else {
//            calendarButton.setImage(UIImage(named: "icon Calendar Notification"), forState: UIControlState.Normal)
//        }
//    }
    
//    @IBAction func resumeButtonClick(sender: UIButton) {
//        if user?.resume != nil {
//            // TODO open user's resume
//        }
//    }
//    func reloadResumeButton() {
//        if user?.resume != nil {
//            resumeButton.setImage(UIImage(named: "icon resume red"), forState: UIControlState.Normal)
//        } else {
//            resumeButton.setImage(UIImage(named: "icon resume grey"), forState: UIControlState.Normal)
//        }
//    }
    
    @IBAction func reminderButtonClick(sender: UIButton) {
        // TODO: Launch remind screen
        
    }
//
//    func reloadReminderButton() {
//        if let reminded = user?.isReminded {
//            isRemindedImageView.hidden = !reminded
//            if reminded {
//                reminderButton.setImage(UIImage(named: "icon reminder red"), forState: UIControlState.Normal)
//            } else {
//                reminderButton.setImage(UIImage(named: "icon reminder"), forState: UIControlState.Normal)
//            }
//        }
//    }
    
    @IBAction func favoriteButtonClick(sender: UIButton) {
        if cellData!.favorites.contains((user?.userId)!) {
            removeFavorite(user!)
        } else {
            addFavorite(user!)
        }
        cellData!.updateFavorites({
            self.reloadFavoriteButton()
        })
    }
    
    func reloadFavoriteButton() {
        if cellData != nil {
            if cellData!.favorites.contains((user?.userId)!) {
                favoriteButton.setImage(UIImage(named: "icon favorite filled"), forState: UIControlState.Normal)
            } else {
                favoriteButton.setImage(UIImage(named: "icon star grey"), forState: UIControlState.Normal)
            }
        }
    }
}

class MyContactsCellData {
    var favorites: [String] = []
    
    init() {
        updateFavorites({})
    }
    
    func updateFavorites(callback: () -> Void) {
        getFavorites { (favs) in
            print(favs)
            self.favorites = favs
            callback()
        }
    }
}

class MyMeshesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var meshNameLabel: UILabel!
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var meshImageView: UIImageView!
    var numberOfReminders: Int = 0
    var remindersLabel: UILabel = UILabel()
    
    var mesh: Mesh? {
        didSet {
            meshNameLabel.text = mesh?.name
            peopleLabel.text = "\(mesh!.members.count) people"
            meshImageView.image = mesh?.image
            
            remindersLabel.removeFromSuperview()
            numberOfReminders = 0
            for member in mesh!.members {
//                if member.isReminded! {
//                    numberOfReminders += 1
//                }
            }
            
            reload()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        reload()
    }
    
    func reload() { // notification for reminder on picture
        if numberOfReminders > 0 {
            remindersLabel = UILabel()
            remindersLabel.backgroundColor = UIColor.meshRed()
            let remindersAttributes = [NSFontAttributeName: UIFont(name: "Calibri-Light", size: 12)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
            let remindersText = NSAttributedString(string: " \(numberOfReminders)", attributes: remindersAttributes)
            remindersLabel.attributedText = remindersText
            remindersLabel.layer.cornerRadius = 5
            remindersLabel.clipsToBounds = true
            let remindersBounds = remindersText.boundingRectWithSize(CGSize(width: self.frame.width, height: remindersLabel.font.pointSize), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
            remindersLabel.frame = CGRectMake(3, 3, remindersBounds.width+4, remindersBounds.height+4)
            self.contentView.addSubview(remindersLabel)
            self.contentView.bringSubviewToFront(remindersLabel)
        }
    }
}

class MyMeshesExpandedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var meshNameLabel: UILabel!
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var meshImageView: UIImageView!
    var collapseImageView: UIImageView  = {
        let imageView = UIImageView(image: UIImage(named: "icon collapse diag up"))
        return imageView
    }()
    var remindersLabel: UILabel = UILabel()
    var memberReminders: [Bool] = [] //has reminders for uses
    var memberImageButtons: [UIButton] = []
    var memberNameLabels: [UILabel] = []
    var memberPositionLabels: [UILabel] = []
    var numberOfReminders: Int = 0
    
    var mesh: Mesh? {
        didSet {
            meshNameLabel.text = mesh?.name
            peopleLabel.text = "\(mesh!.members.count) people"
            meshImageView.image = mesh?.image
            
            remindersLabel.removeFromSuperview()
            numberOfReminders = 0
            memberReminders = []
            
            //remove all old info
            for button in memberImageButtons {
                button.removeFromSuperview()
            }
            memberImageButtons = []
            
            for label in memberNameLabels {
                label.removeFromSuperview()
            }
            memberNameLabels = []
            
            for label in memberPositionLabels {
                label.removeFromSuperview()
            }
            memberPositionLabels = []
            
            for member in mesh!.members {
//                if member.isReminded! {
//                    memberReminders.append(true)
//                    numberOfReminders += 1
//                } else {
//                    memberReminders.append(false)
//                }
                
                let button = UIButton()
                getPicture(member.userId, callback: { (image) in
                    button.setImage(image, forState: UIControlState.Normal)
                })
                button.layer.cornerRadius = 5
                button.clipsToBounds = true
                memberImageButtons.append(button)
                
                let nameLabel = UILabel()
                let nameAttributes = [NSFontAttributeName: UIFont(name: "Calibri-Light", size: 21)!]
                let nameText = NSAttributedString(string: "\(member.firstName) \(member.lastName)", attributes: nameAttributes)
                nameLabel.attributedText = nameText
                memberNameLabels.append(nameLabel)
                
                let positionLabel = UILabel()
                let positionAttributes = [NSFontAttributeName: UIFont(name: "Calibri-Light", size: 17)!, NSForegroundColorAttributeName: UIColor.meshRed()]
                let positionText = NSAttributedString(string: member.position, attributes: positionAttributes)
                positionLabel.attributedText = positionText
                memberPositionLabels.append(positionLabel)
            }
            
            reload()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.contentView.addSubview(collapseImageView)
        reload()
    }
    
    // TODO: Split up into smaller functions
    func reload() {
        for (index, button) in memberImageButtons.enumerate() {
            button.frame = CGRectMake(6, CGFloat(index*45+75), 40, 40)
            button.addTarget(self, action: #selector(memberImageButtonClick), forControlEvents: .TouchUpInside)
            self.contentView.addSubview(button)
        }
        
        for (index, bool) in memberReminders.enumerate() {
            if bool {
                let image = UIImageView(image: UIImage(named: "icon reminder red"))
                image.frame = CGRect(x: 30, y: CGFloat(index*45+105), width: 12.7, height: 7)
                self.contentView.addSubview(image)
                self.contentView.bringSubviewToFront(image)
            }
        }
        
        if numberOfReminders > 0 {
            remindersLabel = UILabel()
            remindersLabel.backgroundColor = UIColor.meshRed()
            let remindersAttributes = [NSFontAttributeName: UIFont(name: "Calibri-Light", size: 12)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
            let remindersText = NSAttributedString(string: " \(numberOfReminders)", attributes: remindersAttributes)
            remindersLabel.attributedText = remindersText
            remindersLabel.layer.cornerRadius = 5
            remindersLabel.clipsToBounds = true
            let remindersBounds = remindersText.boundingRectWithSize(CGSize(width: self.frame.width, height: remindersLabel.font.pointSize), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
            remindersLabel.frame = CGRectMake(3, 3, remindersBounds.width+4, remindersBounds.height+4)
            self.contentView.addSubview(remindersLabel)
            self.contentView.bringSubviewToFront(remindersLabel)
        }
        
        var nameBounds: [CGRect] = []
        
        for (index, nameLabel) in memberNameLabels.enumerate() {
            let bounds = nameLabel.attributedText?.boundingRectWithSize(CGSize(width: self.frame.width, height: 40), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
            nameBounds.append(bounds!)
            nameLabel.frame = CGRectMake(52, CGFloat(index*45+80), bounds!.width, bounds!.height)
            self.contentView.addSubview(nameLabel)
        }
        
        for (index, positionLabel) in memberPositionLabels.enumerate() {
            let bounds = positionLabel.attributedText?.boundingRectWithSize(CGSize(width: self.frame.width - nameBounds[index].width, height: 40), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
            positionLabel.frame = CGRectMake(56 + nameBounds[index].width, CGFloat(index*45+83), (bounds?.width)!, (bounds?.height)!)
            self.contentView.addSubview(positionLabel)
        }
    }
    
    @IBAction func addMemberButtonClick(sender: UIButton) {
        // TODO bring up dialog to add a member to this mesh
    }
    
    func memberImageButtonClick(sender: UIImageView) {
        // TODO go to user's profile/location in my contacts???
    }
}
