//
//  GoogleDriveViewController.swift
//  Mesh
//
//  Created by Paa Adu on 8/17/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import GoogleAPIClient
import GTMOAuth2
import UIKit

class GoogleDriveViewController: UITableViewController {
    
    private let kKeychainItemName = "Drive API"
    private let kClientID = "603684900334-gfu149alkd77l8t2coj6ja72b0ae42ij.apps.googleusercontent.com"
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLAuthScopeDriveReadonly]
    private let service = GTLServiceDrive()
    private var googleDrivefiles = [GTLDriveFile]()
    private var filesLoaded = false // Indicateds whether we have loaded a list of files from google drive
    private var spinner = UIActivityIndicatorView() // Spins when file is being downloaded
    private var downloadingFile = false
    private var fileData: NSData? // will eventually contain a resume or picture
    var fileType = file.document  // This viewcontroller can be used for getting documents (resumes) and pictures (for profile pictures). We will default to documents

    enum file {
        case document // for pdfs
        case picture // for jpg and jpeg
    }
    
    @IBAction func backBarButtonTapped(sender: UIBarButtonItem) {
        switch fileType {
        case .document:
            // Go back to the add resume screen
            self.performSegueWithIdentifier("addResume", sender: nil)
        case .picture:
            // Go back to the select a profile picture screen
            self.performSegueWithIdentifier("profilePicture", sender: nil)
        }
    }
    

    // Initialize the Drive API service
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.center = self.view.center
        spinner.color = UIColor.redColor() // TODO: replace with mesh logo color
        self.view.addSubview(spinner)
        if let auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName(
            kKeychainItemName,
            clientID: kClientID,
            clientSecret: nil) {
            service.authorizer = auth
        }
        
    }
    
    // When the view appears, ensure that the Drive API service is authorized
    // and perform API calls
    override func viewDidAppear(animated: Bool) {
        if let authorizer = service.authorizer,
            canAuth = authorizer.canAuthorize where canAuth {
            if !filesLoaded {
                fetchFiles()
                filesLoaded = true
            }
        } else {
            presentViewController(createAuthController(), animated: true, completion: nil)
        }
    }
    
    // Construct a query to get names and IDs of 250 files using the Google Drive API
    func fetchFiles() {
        let query = GTLQueryDrive.queryForFilesList()
        switch fileType {
        case .document:
            query.q = "name contains '.pdf'"

        case .picture:
            query.q = "name contains '.jpg' or name contains '.jpeg' or name contains '.png'"
        }
        query.pageSize = 250
        query.fields = "nextPageToken, files(id, name)"
        service.executeQuery(
            query,
            delegate: self,
            didFinishSelector: #selector(GoogleDriveViewController.displayResultWithTicket(_:finishedWithObject:error:))
        )
    }
    
    // Parse results and display
    func displayResultWithTicket(ticket : GTLServiceTicket,
                                 finishedWithObject response : GTLDriveFileList,
                                                    error : NSError?) {

        if let error = error {
            showAlert("Error", message: error.localizedDescription)
            return
        }
        
        if let files = response.files where !files.isEmpty {
            for file in files as! [GTLDriveFile] {
                googleDrivefiles.append(file)
            }
            googleDrivefiles.sortInPlace({$0.name.lowercaseString < $1.name.lowercaseString})
            self.tableView.reloadData()
        } else {
           // No files found.
            showAlert("Error", message: "No files found")
        }
    }
    
    
    // Creates the auth controller for authorizing access to Drive API
    private func createAuthController() -> GTMOAuth2ViewControllerTouch {
        let scopeString = scopes.joinWithSeparator(" ")
        return GTMOAuth2ViewControllerTouch(
            scope: scopeString,
            clientID: kClientID,
            clientSecret: nil,
            keychainItemName: kKeychainItemName,
            delegate: self,
            finishedSelector: #selector(GoogleDriveViewController.viewController(_:finishedWithAuth:error:))
        )
    }
    
    // Handle completion of the authorization process, and update the Drive API
    // with the new credentials.
    func viewController(vc : UIViewController,
                        finishedWithAuth authResult : GTMOAuth2Authentication, error : NSError?) {
        
        if let error = error {
            service.authorizer = nil
            showAlert("Authentication Error", message: error.localizedDescription)
            return
        }
        
        service.authorizer = authResult
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert
        )

        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.Default,
            handler: nil
        )
        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return googleDrivefiles.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = googleDrivefiles[indexPath.row].name
        return cell
    }
    
    func downloadFile(file: GTLDriveFile){
        let url = "https://www.googleapis.com/drive/v3/files/\(file.identifier)?alt=media"
        let fetcher = service.fetcherService.fetcherWithURLString(url)
        
        fetcher.beginFetchWithDelegate(
            self,
            didFinishSelector: #selector(GoogleDriveViewController.finishedFileDownload(_:finishedWithData:error:)))
    }
    
    func finishedFileDownload(fetcher: GTMSessionFetcher, finishedWithData data: NSData, error: NSError?){
        if let error = error {
            showAlert("Error", message: error.localizedDescription)
            self.downloadingFile = false
            return
        }
        self.spinner.stopAnimating()
        fileData = data
        self.downloadingFile = false
        switch fileType {
        case .document:
            self.performSegueWithIdentifier("previewResume", sender: nil)
        case .picture:
            self.performSegueWithIdentifier("profilePicture", sender: nil)
        }

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.spinner.startAnimating()
        if (!downloadingFile) {
            downloadingFile = true;
            downloadFile(googleDrivefiles[indexPath.row])
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationvc = segue.destinationViewController
        if let identifier = segue.identifier {
            switch identifier {
            case "previewResume":
                if let resumePreviewViewController = destinationvc as? ResumePreviewViewController {
                    resumePreviewViewController.resume = fileData
                    let indexPath = tableView.indexPathForSelectedRow!
                    resumePreviewViewController.filename = googleDrivefiles[indexPath.row].name
                }
            case "profilePicture":
                if let profilePictureSelectorViewController = destinationvc as? ProfilePictureSelectorViewController, fileData = fileData {
                    profilePictureSelectorViewController.profilePicture = UIImage(data: fileData)
                }
            default:
                break
            }
        }
    }

}
