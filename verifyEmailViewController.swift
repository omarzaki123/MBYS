//
//  ViewController.swift
//  verifyStudentEmail
//
//  Created by Akash Wadawadigi on 9/20/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class verifyEmailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Setting background color
        self.view.backgroundColor = UIColor(red: 248/255, green: 40/255, blue: 54/255, alpha: 0.85)
        
        verificationButton.layer.cornerRadius = 5
        
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(verifyEmailViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }

    @IBOutlet weak var sendVerification: UIButton!
    @IBOutlet weak var verificationButton: UIButton!
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

