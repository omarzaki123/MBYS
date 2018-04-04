//
//  ViewController.swift
//  Company Profile
//
//  Created by Arjun Tambe on 9/6/16.
//  Copyright © 2016 Arjun Tambe. All rights reserved.
//

import UIKit

class CompanyProfileViewController: UIViewController {
    
    let newsFeedID = "newsFeedVC"
    let timelineID = "timelineVC"
    let liasonsID = "liasonsVC"
    
    //image and labels connected to the company's logo, name, and short description
    @IBOutlet var companyLogo: UIImageView?
    @IBOutlet var companyName: UILabel?
    @IBOutlet var companyShortDescription: UILabel?
    
    //buttons connected to the News Feed, Timeline, Liasons, and Surveys tabs
    @IBOutlet var tabButtons: UISegmentedControl?
    
    //the container view, below the header, that contains either a news feed, timeline, liasons, or survey view
    @IBOutlet weak var containerView: UIView!
    weak var currentViewController: UIViewController?

    //Loads the view - starts by displaying the news feed view controller in the Container view in the story board. The child subview contained in this container is changed to the appropriate subview when the segmented control buttons are pressed (handled in showTab function)
    override func viewDidLoad() {
        self.currentViewController = self.storyboard?.instantiateViewControllerWithIdentifier(newsFeedID)
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubview(self.currentViewController!.view, toView: self.containerView)
        super.viewDidLoad()
        loadProfileHeader()
        
        //set the container view's frame manually, autolayout is giving me trouble for some reason
        timelineContainerFrameHeight = containerView.frame.height
        containerView.frame = CGRectMake(0, containerView.frame.origin.y, self.view.frame.width, timelineContainerFrameHeight!)
    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        //visual formatting stuff
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
    }

    
    
    //Sets the IBOutlets company name, company logo, and short description in the header
    func loadProfileHeader() {
        //get company info here
        companyLogo!.image = UIImage(named: "goldman-sachs-logo-ICON")
        companyName!.text = "Goldman Sachs"
        companyShortDescription!.text = "Banking Firm"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //These four views are displayed when each of the 3 tabs, newsfeed, timeline, liasons are pressed. They change the child view contained in the ContainerViewController, the subview underneath the header.
    @IBAction func showTab(sender: AnyObject!) {
        switch sender.selectedSegmentIndex {
        case 0:
            let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier(newsFeedID)
            newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
            self.currentViewController = newViewController
        case 1:
            let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier(timelineID)
            newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
            self.currentViewController = newViewController
        case 2:
            let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier(liasonsID)
            newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
            self.currentViewController = newViewController
        default:
            print ("?")
        }
    }
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMoveToParentViewController(nil)
        self.addChildViewController(newViewController)
        self.addSubview(newViewController.view, toView:self.containerView!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animateWithDuration(0.5, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
            },
                                   completion: { finished in
                                    oldViewController.view.removeFromSuperview()
                                    oldViewController.removeFromParentViewController()
                                    newViewController.didMoveToParentViewController(self)
        })
    }



}

