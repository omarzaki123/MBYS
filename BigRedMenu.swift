//
//  RedSideMenu.swift
//  Mesh
//
//  Created by Daniel Ssemanda on 8/14/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import UIKit
import Foundation

let redMenuCellId = "cellId"
var redMenuPostsArray: [RedMenuPost] = []
let masterView: MasterViewController = UIStoryboard(name: "NewsFeed", bundle: nil).instantiateViewControllerWithIdentifier("MasterView") as! MasterViewController

class RedMenuPost{
    var title: String?
    var icon: UIImage?
    var idNum: Int?
}

class BigRedCollectionView: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let customCellIdentifier = "customCellIdentifier"
    
     override func viewDidLoad() {
        collectionView?.scrollEnabled = false
        collectionView?.backgroundColor = UIColor.meshRed()
        collectionView?.registerClass(RedMenuCell.self, forCellWithReuseIdentifier: redMenuCellId)
        createTheRedMenuPosts()
        
    }
    
    func createTheRedMenuPosts(){
//        let newsFeedRedMenuPost = RedMenuPost()
//        newsFeedRedMenuPost.title = "News Feed"
//        newsFeedRedMenuPost.idNum = 0
//        newsFeedRedMenuPost.icon = UIImage(named: "mesh logo small white")
        
        
        let myProfileRedMenuPost = RedMenuPost()
        myProfileRedMenuPost.title = "My Profile"
        myProfileRedMenuPost.idNum = 0
        myProfileRedMenuPost.icon = UIImage(named: "icon profile")
        
        let myNetworkRedMenuPost = RedMenuPost()
        myNetworkRedMenuPost.title = "Network"
        myNetworkRedMenuPost.idNum = 1
        myNetworkRedMenuPost.icon = UIImage(named: "icon setup three people")
        
        let calendarRedMenuPost = RedMenuPost()
        calendarRedMenuPost.title = "Calendar"
        calendarRedMenuPost.idNum = 2
        calendarRedMenuPost.icon = UIImage(named: "icon sidebar calendar")
        
        
//        let remindersRedMenuPost = RedMenuPost()
//        remindersRedMenuPost.title = "Reminders"
//        remindersRedMenuPost.idNum = 4
//        remindersRedMenuPost.icon = UIImage(named: "icon sidebar reminder")
        
        
//        redMenuPostsArray.append(newsFeedRedMenuPost)
        redMenuPostsArray.append(myProfileRedMenuPost)
        redMenuPostsArray.append(myNetworkRedMenuPost)
        redMenuPostsArray.append(calendarRedMenuPost)
//        redMenuPostsArray.append(remindersRedMenuPost)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return redMenuPostsArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        masterView.removeBigRedMenu()
//        print("sdhadhjadjhasjhdahjshjasdahj the item selected: \(indexPath.item)")
//        print("sdhadhjadjhasjhdahjshjasdahj current masterPageIdentificationNum  \(masterPageIdentificationNum)")
        if (indexPath.item != masterPageIdentificationNum){
          pageView.scrollToViewController(index: indexPath.item)
          clearView.removeFromSuperview()
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let frame : CGRect = self.view.frame
        let margin  = (frame.width - 90 * 3) / 6.0
        return UIEdgeInsetsMake(10, margin, 10, margin)  //First number sets distance from the top
        
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.width, 70)
    }
    
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let redMenuCell =  collectionView.dequeueReusableCellWithReuseIdentifier(redMenuCellId, forIndexPath: indexPath)
    
        redMenuCell.contentView.backgroundColor = UIColor.meshRed()
        let cellInfo = redMenuPostsArray[indexPath.item]
        
        let sectionImage: UIImageView = {
            let imageView = UIImageView()
            imageView.image = cellInfo.icon
            return imageView
        }()
        
        let sectionName: UILabel = {
            let label = UILabel()
            let stringFormat = NSMutableAttributedString(string: cellInfo.title!, attributes: [NSFontAttributeName: UIFont(name: "Calibri-Light", size: 24)!, NSForegroundColorAttributeName: UIColor.whiteColor()])
            label.attributedText = stringFormat
            return label
        }()
        
        let cellIdentifier = cellInfo.idNum!
        
        redMenuCell.addSubview(sectionImage)
        redMenuCell.addSubview(sectionName)
        
        if ( cellIdentifier == masterPageIdentificationNum){
            redMenuCell.contentView.backgroundColor = UIColor.lightGrayColor()
        }
        
        if (cellIdentifier == 1) {
            redMenuCell.addConstraintsWithFormat("H:|-20-[v0(30)]-10-[v1]", views: sectionImage, sectionName)
            redMenuCell.addConstraintsWithFormat("V:|-23-[v0(21)]|", views: sectionImage)
            redMenuCell.addConstraintsWithFormat("V:|[v0]|", views: sectionName)
            
        }
        else {
            redMenuCell.addConstraintsWithFormat("H:|-20-[v0(30)]-10-[v1]", views: sectionImage, sectionName)
            redMenuCell.addConstraintsWithFormat("V:|-20-[v0(30)]|", views: sectionImage)
            redMenuCell.addConstraintsWithFormat("V:|[v0]|", views: sectionName)
        }
        return redMenuCell
    }
    
}

class RedMenuCell: UICollectionViewCell {
    
}

