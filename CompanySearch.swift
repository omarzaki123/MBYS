//
//  CompanySearch.swift
//  Mesh
//
//  Created by Daniel Ssemanda on 8/23/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import UIKit

var searchBox = UISearchBar()
var searchBoxTextField = UITextField()
var searchBoxBool = false
var searchTableView = UITableView()
let searchBarWorking = SearchBar()
var resultsArea = UIView()
var filtered = [Company]()
let  searchTableViewId = "cell"

struct Company {
    let name: String
    let icon: UIImage
}


class SearchBar: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    //    var data = ["hello world" , "morgan's world", "morgan stanley", "Walmart"]
    var data = [
        Company(name: "The Boston Consulting Group", icon: UIImage(named: "bcg_Logo")!),
        Company(name: "Morgan Stanley", icon: UIImage(named: "morgan-stanley-logo")!),
        Company(name: "Google", icon: UIImage(named: "Google_icon_2015")!),
        Company(name: "Facebook", icon: UIImage(named: "F_icon.svg")!),
        Company(name: "Apple", icon: UIImage(named: "apple-classic-logo-icon-23")!),
        Company(name: "Goldman Sachs", icon: UIImage(named: "goldman-sachs-logo-ICON")!),
        Company(name: "J.P. Morgan", icon: UIImage(named: "jpMorgan")!),
        Company(name: "Bain and Company", icon: UIImage(named: "Bain")!),
        Company(name: "McKinsey and Company", icon: UIImage(named: "McKinsey")!),
        Company(name: "Accenture", icon: UIImage(named: "accenture")!),
        Company(name: "IBM", icon: UIImage(named: "ibm-logo")!),
        Company(name: "Microsoft", icon: UIImage(named: "Microsoft_New_Logo")!)
    ]
    
    var filtered: [Company] = []
    var lastSearchText = ""
    var noResultsBool = false
    var image = UIImageView()
    var cell = UITableViewCell()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableView.registerClass(SearchTableViewCell.self, forCellReuseIdentifier: searchTableViewId)
        searchTableView.delegate      =   self
        searchTableView.dataSource    =   self
        
        searchTableView.rowHeight = 65.0
        
        self.view.addSubview(searchTableView)
        
        self.view.addConstraintsWithFormat("H:|[v0]|", views: searchTableView)
        self.view.addConstraintsWithFormat("V:|[v0]|", views: searchTableView)
        
    }
    
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBoxBool = true
        grayLine.alpha = 0
        pageViewPanBlocker.alpha = 1
        searchBox.barTintColor = UIColor.rgb(176, green: 238, blue: 237)
        searchBoxTextField.backgroundColor = UIColor.rgb(176, green: 238, blue: 237)
        newsFeedView.view.bringSubviewToFront(secondBar)
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseIn , animations: {
            //        let frame = self.view.frame
            newsFeedView.view.layer.needsDisplayOnBoundsChange = true
            let up = CGAffineTransformMakeTranslation(0, -70)
            adjustmentView.transform = up
            newsFeedView.view.transform = up
            newsFeedView.view.frame.size.height += 140
            newsFeedView.collectionView?.alpha = 0.5
            }, completion: {finished in
                secondBar.alpha = 1
        })
        let frame = newsFeedView.view.frame
        resultsArea = UIView(frame:  CGRectMake(0, 102, frame.width, 0))
        resultsArea.backgroundColor = UIColor.whiteColor()
        newsFeedView.view.addSubview(resultsArea)
        newsFeedView.view.bringSubviewToFront(resultsArea)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBoxBool = false
        pageViewPanBlocker.alpha = 0
        searchBox.barTintColor = UIColor.rgb(230, green: 231, blue: 232)
        searchBoxTextField.backgroundColor = UIColor.rgb(230, green: 231, blue: 232)
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseIn , animations: {
            //        let frame = self.view.frame
            //        newsFeedView.view.layer.needsDisplayOnBoundsChange = true
            grayLine.alpha = 1
            let down = CGAffineTransformMakeTranslation(0, 0)
            adjustmentView.transform = down
            newsFeedView.view.transform = down
            newsFeedView.view.frame.size.height -= 140
            newsFeedView.collectionView?.alpha = 1
            if (resultsArea.frame.size.height >= 187){
                resultsArea.frame.size.height -= 185
            }
            }, completion: {finished in
                resultsArea.removeFromSuperview()
                resultsArea.alpha = 0
        })
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBoxBool = false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBoxBool = false
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        image.removeFromSuperview()
        let heightCheck = resultsArea.frame.size.height
        if (searchText.characters.count == 1 && (lastSearchText.characters.count < searchText.characters.count) ){
            //            let frame = newsFeedView.view.frame
            UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseIn , animations: {
                resultsArea.frame.size.height += 185
                }, completion: {finished in
                    //                self.view.backgroundColor = UIColor.greenColor()
                    resultsArea.addSubview(self.view)
                    resultsArea.addConstraintsWithFormat("H:|[v0]|", views: self.view)
                    resultsArea.addConstraintsWithFormat("V:|[v0]|", views: self.view)
                    
            })
        }
        else if (searchText.characters.count >= 1 && heightCheck < 185){
            UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseIn , animations: {
                resultsArea.frame.size.height += 185
                }, completion: {finished in
                    //                    self.view.backgroundColor = UIColor.greenColor()
                    resultsArea.addSubview(self.view)
                    resultsArea.addConstraintsWithFormat("H:|[v0]|", views: self.view)
                    resultsArea.addConstraintsWithFormat("V:|[v0]|", views: self.view)
            })
        }
        else if (searchText.characters.count == 0 && heightCheck >= 185){
            UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseIn , animations: {
                resultsArea.frame.size.height -= 185
                }, completion: nil)
        }
        
        filtered = data.filter({ (company: Company) -> Bool in
            return isWordInString(company.name, searchWord: searchText)
        })
        if(filtered.count == 0){
            searchBoxBool = false
        } else {
            searchBoxBool = true
        }
        searchTableView.reloadData()
        lastSearchText = searchText
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noResultsBool = false
        if ( filtered.count != 0 ){
            return filtered.count
        }
        else {
            noResultsBool = true
            return 1
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        cell = tableView.dequeueReusableCellWithIdentifier(searchTableViewId)! as UITableViewCell
        
        
        if (noResultsBool){
            cell.textLabel?.text = "Sorry can't find that company"
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.backgroundColor = UIColor.rgb(255, green: 153, blue: 153)
            image = UIImageView(frame: CGRectMake(15, 10, 45, 45))
            image.image = UIImage(named: "mesh logo small white")
            let background1 = UIView(frame: CGRectMake(15, 10, 45, 45))
            background1.backgroundColor = UIColor.rgb(255, green: 153, blue: 153)
            cell.contentView.addSubview(background1)
            cell.contentView.addSubview(image)
            cell.indentationLevel = 5
            
        }
        else {
            
            cell.textLabel?.text = filtered[indexPath.row].name
            cell.backgroundColor = UIColor.whiteColor()
            let background = UIView(frame: CGRectMake(15, 10, 45, 45))
            background.backgroundColor = UIColor.whiteColor()
            image = UIImageView(frame: CGRectMake(15, 10, 45, 45))
            image.image = filtered[indexPath.row].icon
            cell.contentView.addSubview(background)
            cell.contentView.addSubview(image)
            cell.textLabel?.textColor = UIColor.blackColor()
            cell.indentationLevel = 5
        }
        
        return cell
    }
    
}


class SearchTableViewCell: UITableViewCell {
    
}