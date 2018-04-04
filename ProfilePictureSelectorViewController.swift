//
//  ProfilePictureSelectorViewController.swift
//  Mesh
//
//  Created by Paa Adu on 9/8/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import UIKit

class ProfilePictureSelectorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var spinner = UIActivityIndicatorView() // Spins when we are uploading  picture to firebase
    private var sendingRequest = false // true if sending request to firebase. This prevents multiple requests from being sent at the same time
    @IBOutlet weak var cameraRollImageView: UIImageView!
    @IBOutlet weak var takeAPictureImageView: UIImageView!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var googleDriveImageView: UIImageView!
    
    var profilePicture: UIImage?
    var pictureSet = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Load existing profile picture if we already have one.
        // This case can happen if we press back from the resume screen
        if let existingPicture = currentUser.profilePicture {
            profilePictureImageView.image = existingPicture
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.center = self.view.center
        spinner.color = UIColor.whiteColor()
        self.view.addSubview(spinner)
        // Make the image view handle touches
        let googleDriveImageTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfilePictureSelectorViewController.googleDriveTapped))
        googleDriveImageView.addGestureRecognizer(googleDriveImageTapped)
        googleDriveImageView.userInteractionEnabled = true
        let takeAPictureTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfilePictureSelectorViewController.takePictureTapped))
        takeAPictureImageView.addGestureRecognizer(takeAPictureTapped)
        takeAPictureImageView.userInteractionEnabled = true
        let cameraRollTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfilePictureSelectorViewController.cameraRollTapped))
        cameraRollImageView.addGestureRecognizer(cameraRollTapped)
        cameraRollImageView.userInteractionEnabled = true
        // Try to load the profile picture if we passed it in from Google Drive
        if let profilePicture = profilePicture {
            profilePictureImageView.image = profilePicture
            pictureSet = true
        } else {
            // load default profile picture
            profilePictureImageView.image = UIImage(named: "default profile picture")
        }
    }

    func cameraRollTapped(sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    
    // NOTE: This function will not work in the simulator since there is no camera.
    func takePictureTapped(sender: UIButton) {
        let picker =  UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .Camera
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func googleDriveTapped(sender: AnyObject) {
        performSegueWithIdentifier("selectPictureFromGoogleDrive", sender: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            pictureSet = true
            profilePictureImageView.image = selectedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        pictureSet = false
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func continueButtonTapped(sender: UIButton) {
        if pictureSet {
            if sendingRequest {
                return
            }
            sendingRequest = true
            spinner.startAnimating()
            currentUser.profilePicture = profilePictureImageView.image
            currentUser.save()
            savePicture(currentUser.userId, picture: profilePictureImageView.image!) { (savedPicture) in
              // TODO: handle case where we couldn't save pic to firebase
                self.spinner.stopAnimating()
                self.sendingRequest = false
                self.performSegueWithIdentifier("selectResume", sender: nil)
            }
        } else {
            performSegueWithIdentifier("selectResume", sender: nil)
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationvc = segue.destinationViewController
        if let identifier = segue.identifier {
            switch identifier {
            case "selectPictureFromGoogleDrive":
                if let  navigationController = destinationvc as? UINavigationController {
                    if let googleDriveViewController = navigationController.viewControllers[0] as? GoogleDriveViewController {
                        googleDriveViewController.fileType = .picture
                    }
                }
            default:
                break
            }
        }
    }

}
