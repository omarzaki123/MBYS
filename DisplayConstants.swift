//
//  Constants.swift
//  Company Profile
//
//  Created by Arjun Tambe on 9/8/16.
//  Copyright © 2016 Arjun Tambe. All rights reserved.
//

import Foundation
import UIKit

//background color
let tableBackgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)

//text color - red for titles, dark gray for others (Descriptions, etc)
let titleTextColor = UIColor.redColor()
let altTextColor = UIColor.darkGrayColor()

//tracks index of expanded row
var indexOfExpandedRow = -1

//size of the icons for calendar and clock
var iconHeight: CGFloat = 20.0


//constants for TimelineTableView
let timelineTableRowHeight: CGFloat = 54.0

//font constants for timeline
let timelineEventTitleFont = UIFont(descriptor: UIFontDescriptor(name: "Calibri", size: 24.0), size: 24.0)
let timelineEventDescriptionFont = UIFont(descriptor: UIFontDescriptor(name: "Calibri", size: 16.0), size: 16.0)
let timelineEventDateFont = UIFont(descriptor: UIFontDescriptor(name: "Calibri", size: 16.0), size: 16.0)


extension NSTimeInterval {
    var stringValue: String {
        let interval = Int(self)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

var timelineContainerFrameHeight: CGFloat?
