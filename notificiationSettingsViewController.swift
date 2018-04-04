//
//  ViewController.swift
//  notificationSettings
//
//  Created by Akash Wadawadigi on 8/28/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class notificationSettingsViewController: UIViewController {

    @IBOutlet weak var notificationSettingBox: UIButton!
    
    @IBOutlet weak var vibrateSettingBox: UIButton!
    
    @IBOutlet weak var soundSettingBox: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Setting background color
        self.view.backgroundColor = UIColor(red: 248/255, green: 40/255, blue: 54/255, alpha: 0.85)
        
        setupLocalSettings()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func saveNotificationSettings(sender: AnyObject) {
        if(notificationSettingBox.titleLabel!.text == "✓"){
            setSendNotificationSetting(true)
        } else if (notificationSettingBox.titleLabel!.text == " "){
            setSendNotificationSetting(false)
        }
        
        if(vibrateSettingBox.titleLabel!.text == "✓"){
            setVibrationSetting(true)
        } else if (vibrateSettingBox.titleLabel!.text == " "){
            setVibrationSetting(false)
        }
        
        if(soundSettingBox.titleLabel!.text == "✓"){
            setSoundSetting(true)
        } else if (soundSettingBox.titleLabel!.text == " "){
            setSoundSetting(false)
        }
        userDefaults.synchronize()
    }
    @IBOutlet weak var saveSettings: UIButton!
    @IBAction func toggleCheckBox(sender: AnyObject) {
        if(sender.titleLabel?!.text == "✓"){
            sender.setTitle(" ", forState: .Normal)
        } else if (sender.titleLabel?!.text == " "){
            sender.setTitle("✓", forState: .Normal)
        }
    }
    
    @IBAction func vibrateCheckBox(sender: AnyObject) {
        toggleCheckBox(sender)
    }
    
    @IBAction func soundCheckBox(sender: AnyObject) {
        toggleCheckBox(sender)
    }
    
    func setupLocalSettings() {
        if getSendNotificationSetting() {
            notificationSettingBox.setTitle("✓", forState: .Normal)
        } else {
            notificationSettingBox.setTitle(" ", forState: .Normal)
        }
        
        if getVibrationSetting() {
            vibrateSettingBox.setTitle("✓", forState: .Normal)
        } else {
            vibrateSettingBox.setTitle(" ", forState: .Normal)
        }
        
        if getSoundSetting() {
            soundSettingBox.setTitle("✓", forState: .Normal)
        } else {
            vibrateSettingBox.setTitle(" ", forState: .Normal)
        }
    }
}

