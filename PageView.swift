//
//  SwipeView.swift
//  Mesh
//
//  Created by Daniel Ssemanda on 8/19/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import UIKit

let newsFeedView = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
let profileView = MyProfileView()
let MyNetwork = UIStoryboard(name: "MyNetwork", bundle: nil).instantiateViewControllerWithIdentifier("MyNetworkViewController")
let calendarView = UIStoryboard(name: "Calendar", bundle: nil).instantiateViewControllerWithIdentifier("Calendar") as! Calendar


class NavigationPageView: UIPageViewController {
    
    weak var pageViewDelegate: NavigationPageViewControllerDelegate?
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        // The view controllers will be shown in this order
        //return [newsFeedView, profileView, MyNetwork, calendarView]
        return [profileView, MyNetwork, calendarView]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        pageViewDelegate?.navigationPageViewController(self, didUpdatePageCount: orderedViewControllers.count)
        
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .Forward,
                               animated: true,
                               completion: nil)
        }
        
    }
   
//     Scrolls to the next view controller.
    
    func scrollToNextViewController() {
        if let visibleViewController = viewControllers?.first,
            let nextViewController = pageViewController(self,
                                                        viewControllerAfterViewController: visibleViewController) {
            scrollToViewController(nextViewController)
        }
    }
    
    
//     Scrolls to the view controller at the given index. Automatically calculates
//     the direction.
//     
//     - parameter newIndex: the new index to scroll to
 
    func scrollToViewController(index newIndex: Int) {
        if let firstViewController = viewControllers?.first,
            let currentIndex = orderedViewControllers.indexOf(firstViewController) {
            let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .Forward : .Reverse
            let nextViewController = orderedViewControllers[newIndex]
            scrollToViewController(nextViewController, direction: direction)
        }
    }
    
//     Scrolls to the given 'viewController' page.
//     
//     - parameter viewController: the view controller to show.
    
    private func scrollToViewController(viewController: UIViewController,
                                        direction: UIPageViewControllerNavigationDirection = .Forward) {
        setViewControllers([viewController],
                           direction: direction,
                           animated: true,
                           completion: { (finished) -> Void in
                            // Setting the view controller programmatically does not fire
                            // any delegate methods, so we have to manually notify the
                            // 'tutorialDelegate' of the new index.
                            self.notifyNavigationDelegateOfNewIndex()
        })
    }
    
    
//     Notifies '_tutorialDelegate' that the current page index was updated.
    
    private func notifyNavigationDelegateOfNewIndex() {
        if let firstViewController = viewControllers?.first,
            let index = orderedViewControllers.indexOf(firstViewController) {
            pageViewDelegate?.navigationPageViewController(self,
                                                         didUpdatePageIndex: index)
        }
    }
    



    
}

// MARK: UIPageViewControllerDataSource

extension NavigationPageView: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
}

extension NavigationPageView: UIPageViewControllerDelegate {
    
    func pageViewController(pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                                               previousViewControllers: [UIViewController],
                                               transitionCompleted completed: Bool) {
        if (finished && completed){
//            print("here is the index of something: \(orderedViewControllers.indexOf((viewControllers?.first)!))")
        }
        if let firstViewController = viewControllers?.first,
            let index = orderedViewControllers.indexOf(firstViewController) {
            pageViewDelegate?.navigationPageViewController(self,
                                                         didUpdatePageIndex: index)
        }
    }

    
    
}

protocol NavigationPageViewControllerDelegate: class {
    
    /**
     Called when the number of pages is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter count: the total number of pages.
     */
    func navigationPageViewController(navigationPageViewController: NavigationPageView,
                                    didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func navigationPageViewController(navigationPageViewController: NavigationPageView,
                                    didUpdatePageIndex index: Int)
    
}
