//
//  CreateEvent.swift
//  Mesh
//
//  Created by Ariel Bong on 8/12/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import Foundation
import Firebase

class CreateEvent: UIViewController {
    
    
    @IBOutlet weak var eventName: UITextField!
    
    @IBOutlet weak var school: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateEvent.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @IBAction func createEventActionForSchool(sender: AnyObject) {
        
        let event = Event()
        event.title = eventName.text!
        event.eventDescription = "mass test"
    
        getUserInformation(getCurrentUserId(), callback: { (user)in
            if let user = user {
                event.company = user.company

            }
        
        })
        pushEventToSchool(school.text!, event: event)
        
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

}
