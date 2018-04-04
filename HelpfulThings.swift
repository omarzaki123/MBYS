//
//  HelpfulThings.swift
//  Mesh
//
//  Created by Daniel Ssemanda on 8/14/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import UIKit
import Foundation

//This file is specifically for helpful things like classes, extention, functions, etc.


//Gives text field text and thier placeholders the right padding
class TextField: UITextField{
    let padding = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 5);
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}

//Makes setting a UIColor easier
extension UIColor{
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static func meshRed() -> UIColor{
       return UIColor.rgb(229, green: 38, blue: 54)
    }
}

//Finds the height of a string of a certain font
extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}

func getMinimumFontSizeNeededCalibri(text: String, numberOfLines: CGFloat, width: CGFloat, fontSizeStart: CGFloat ) -> CGFloat {
    var testedSize = fontSizeStart
    while (text.heightWithConstrainedWidth(width, font: UIFont(name: "Calibri-Light", size: testedSize)!) > (testedSize * numberOfLines)) {
        testedSize = testedSize - 1
    }
    return testedSize
}

//Makes creating constraints much much easier. This one is one of God's greatest blessings lol
extension UIView{
    
    func addConstraintsWithFormat(format: String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerate() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    
    
    
}

//Resize an Image
func imageResize (image:UIImage, sizeChange:CGSize)-> UIImage {
    
    let hasAlpha = true
    let scale: CGFloat = 0.0 // Use scale factor of main screen
    
    UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
    image.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
    
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    return scaledImage!
}

// Creates a UIColor from a Hex string.
func colorWithHexString (hex:String) -> UIColor {
    var cString: String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
    
    if (cString.hasPrefix("#")) {
        let startIndex = cString.startIndex.advancedBy(1)
        cString = cString.substringFromIndex(startIndex)
    }
    
    if (cString.characters.count != 6) { return UIColor.grayColor() }
    
    let endIndexR = cString.endIndex.advancedBy(-4)
    let rString = cString.substringToIndex(endIndexR)
    var gString = cString.substringFromIndex(endIndexR)
    let endIndexG = gString.endIndex.advancedBy(-2)
    gString = gString.substringToIndex(endIndexG)
    let startIndexB = cString.endIndex.advancedBy(-2)
    let bString = cString.substringFromIndex(startIndexB)
    
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    NSScanner(string: rString).scanHexInt(&r)
    NSScanner(string: gString).scanHexInt(&g)
    NSScanner(string: bString).scanHexInt(&b)
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
}


func isWordInString(searchedString: String, searchWord: String) -> Bool {
    let lsearchWord = searchWord.lowercaseString
    let lsearchedString = searchedString.lowercaseString
    
    if (lsearchedString.hasPrefix(lsearchWord) || lsearchedString.containsString(" \(lsearchWord)")) {
     return true
    }
    else {
    return false
    }
}
