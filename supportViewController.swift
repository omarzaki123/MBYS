//
//  ViewController.swift
//  MeshSupport
//
//  Created by Akash Wadawadigi on 9/20/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class supportViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Setting background color
        self.view.backgroundColor = UIColor(red: 248/255, green: 40/255, blue: 54/255, alpha: 0.85)
        
        submitButton.layer.cornerRadius = 5
        self.inquiryBox.layer.cornerRadius = 5
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(supportViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }
    @IBOutlet weak var submitButton: UIButton!

    @IBOutlet weak var inquiryBox: UITextView!
    @IBAction func submitSupportInquiry(sender: AnyObject) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


}

