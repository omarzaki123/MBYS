//
//  QRCodeScanner.swift
//  Mesh
//
//  Created by Daniel Ssemanda on 8/21/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import AVFoundation
import UIKit

let meshQrPrefix = "MESHQRCODE" // This prefix will identify a qr code as a mesh qr code

class QRCodeScanner:  UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    private var spinner = UIActivityIndicatorView() // Spins when we are loading info from firebase
    private var sendingRequest = false // True if we are already sending a request to firebase
    private var userFromQrCode = User() // Stores are user if we can get one from a qr code and firebase
    private var lock = NSLock()
    private var displayingNotification = false
    var objCaptureSession: AVCaptureSession?
    var objCaptureVideoPreviewLayer: AVCaptureVideoPreviewLayer?
    var vwQRCode: UIView?
    var qrMenuBool = false
    var qrCodeDisplay = UIView()
    var contactAdded = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        sendingRequest = false
        // Check if we added a contact and we have returned to the scanner screen
        if contactAdded {
            let lastAddedUser = currentUser.connections.last!
            let text = "You have added \(lastAddedUser.firstName) \(lastAddedUser.lastName)"
            displayNotification(text)
            contactAdded = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVideoCapture()
        addVideoPreviewLayer()
        initializeQRView()
        
        let transform = CGAffineTransformMakeScale(3.0, 3.0)
        spinner.transform = transform;
        spinner.center = self.view.center
        spinner.color = UIColor.redColor() // TODO: replace with mesh logo color
        self.view.addSubview(spinner)
        //Must Be last thing here
        makeButtons()
    }
    
    func makeButtons(){
        let frame = self.view.frame
        let goBackToNewsFeed = UIButton(frame: CGRectMake(40, frame.height - 95, 45, 45))
        goBackToNewsFeed.setImage(UIImage(named: "icon camera homebutton"), forState: UIControlState.Normal)
        goBackToNewsFeed.addTarget(self, action: #selector(goBackToMainView), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(goBackToNewsFeed)
        
        let qrCodeDisplayButton = UIButton(frame: CGRectMake(frame.width - 80, frame.height - 93, 45, 45))
        qrCodeDisplayButton.setImage(UIImage(named: "icon camera switchQR"), forState: UIControlState.Normal)
        qrCodeDisplayButton.addTarget(self, action: #selector(toggleShowingQRCode), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(qrCodeDisplayButton)
    }
    
    func configureVideoCapture(){
        let objCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error: NSError?
        let objCaptureDeviceInput: AnyObject!
        do{
            objCaptureDeviceInput = try AVCaptureDeviceInput(device: objCaptureDevice) as AVCaptureDeviceInput
        } catch let error1 as NSError {
            error = error1
            objCaptureDeviceInput = nil
        }
        if (error != nil) {
            let alertView: UIAlertController = UIAlertController(title: "Device Error", message: "Device not supported for this Application", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertView.addAction(defaultAction)
            presentViewController(alertView, animated: true, completion: nil)
            return
        }
        objCaptureSession = AVCaptureSession()
        objCaptureSession?.addInput(objCaptureDeviceInput as! AVCaptureInput)
        let objCaptureMetadataOutput = AVCaptureMetadataOutput()
        objCaptureSession?.addOutput(objCaptureMetadataOutput)
        objCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        objCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
    }
    
    func addVideoPreviewLayer(){
        objCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: objCaptureSession)
        objCaptureVideoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        objCaptureVideoPreviewLayer?.frame = view.layer.bounds
        self.view.layer.addSublayer(objCaptureVideoPreviewLayer!) //Unwrapped the PreviewLayer
        objCaptureSession?.startRunning()
        let pullDown = UISwipeGestureRecognizer(target: self, action: #selector(goBackToMainView))
        pullDown.direction = .Down
        let cover = UIView()
        cover.frame = view.layer.bounds
        cover.backgroundColor = UIColor.clearColor()
        cover.addGestureRecognizer(pullDown)
        self.view.addSubview(cover)
    }
    
    func goBackToMainView() {
        scanner.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func toggleShowingQRCode(){
        let frame = self.view.frame
        if (!qrMenuBool){
            
            qrCodeDisplay = UIView(frame: CGRectMake(floor(frame.width/2) - 125, floor(frame.height/2) - 175, 250, 250))
            qrCodeDisplay.layer.cornerRadius = 10
            qrCodeDisplay.backgroundColor = UIColor.rgb(229, green: 38, blue: 54)
            qrCodeDisplay.alpha = 0.8
            
            let qrImage = generateQRCode(currentUser.userId)
            let qrView = UIImageView(image: qrImage)
            let colorMask = UIView()
            colorMask.backgroundColor = UIColor.rgb(229, green: 38, blue: 54)
            colorMask.alpha = 0.6
            
            qrCodeDisplay.addSubview(qrView)
            qrCodeDisplay.addSubview(colorMask)
            qrCodeDisplay.addConstraintsWithFormat("H:|[v0]|", views: qrView)
            qrCodeDisplay.addConstraintsWithFormat("V:|[v0]|", views: qrView)
            qrCodeDisplay.addConstraintsWithFormat("H:|[v0(250)]|", views: colorMask)
            qrCodeDisplay.addConstraintsWithFormat("V:|[v0(250)]|", views: colorMask)
            view.addSubview(qrCodeDisplay)
            qrMenuBool = true
            UIView.animateWithDuration(0.4, animations: {
                self.qrCodeDisplay.alpha = 0.6
            })
        }
        else {
            UIView.animateWithDuration(0.4, animations: {
                self.qrCodeDisplay.alpha = 0
                }, completion: { finished in
                    self.qrCodeDisplay.removeFromSuperview()
            })
            qrMenuBool = false
        }
        
    }
    
    func initializeQRView(){
        vwQRCode = UIView()
        self.view.addSubview(vwQRCode!)
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0{
            vwQRCode?.frame = CGRectZero
            return
        }
        
        let objMetadataMachineReadableCodeObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if objMetadataMachineReadableCodeObject.type == AVMetadataObjectTypeQRCode{
            let objBarCode = objCaptureVideoPreviewLayer?.transformedMetadataObjectForMetadataObject(objMetadataMachineReadableCodeObject as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            vwQRCode?.frame = objBarCode.bounds;
            if let qrString = objMetadataMachineReadableCodeObject.stringValue {
                
                // Check if the qr code is a  mesh qr code
                if !qrString.hasPrefix(meshQrPrefix) {
                    if !displayingNotification {
                        displayingNotification = true
                        displayNotification("This is not a Mesh QR Code")
                    }
                    return
                }
                
                // This next block uses a lock to avoid some race conditions since the callbacks
                // can happen on different threads. This method is also not on the main thread
                lock.lock()
                if !sendingRequest {
                    sendingRequest = true
                    spinner.startAnimating()
                    // Get range of all characters after the qrPrefix
                    let range = qrString.startIndex.advancedBy(meshQrPrefix.characters.count)..<qrString.endIndex
                    let userId = qrString[range]
                    getUserInformation(userId) { (user) in
                        if let user = user {
                            self.userFromQrCode = user
                            getPicture(userId) { (image) in
                                self.userFromQrCode.profilePicture = image
                                self.spinner.stopAnimating()
                                addContactManuallyVC.userFromQrCode = self.userFromQrCode
                                self.presentViewController(addContactManuallyVC, animated: true, completion: nil)
                            }
                        } else {
                            self.spinner.stopAnimating()
                            self.sendingRequest = false
                            self.displayNotification("Unable to get contact information")
                        }
                        
                    }
                }
                lock.unlock()
                return
            }
        }
    }
    
    func displayNotification(text: String) {
        let frame = self.view.frame
        let notificationOfAddition = UIView(frame: CGRectMake(0, -45, frame.width, 40))
        notificationOfAddition.backgroundColor = UIColor.rgb(229, green: 38, blue: 54)
        notificationOfAddition.alpha = 0.8
        let notificationText = UILabel()
        notificationText.text = text
        notificationText.textColor = UIColor.whiteColor()
        notificationOfAddition.addSubview(notificationText)
        notificationOfAddition.addConstraintsWithFormat("H:|-8-[v0]|", views: notificationText)
        notificationOfAddition.addConstraintsWithFormat("V:[v0(20)]|", views: notificationText)
        
        UIView.animateWithDuration( 0.3, delay: 0.0, options: .CurveEaseIn , animations: {
            self.view.addSubview(notificationOfAddition)
            let down = CGAffineTransformMakeTranslation(0, 45)
            notificationOfAddition.transform = down
            }, completion: {finished in
                UIView.animateWithDuration(0.3, delay: 3, options: .CurveEaseIn , animations: {
                    let up = CGAffineTransformMakeTranslation(0, -45)
                    notificationOfAddition.transform = up
                    }, completion: {finished in
                        notificationOfAddition.removeFromSuperview()
                        self.displayingNotification = false
                })
            }
        )
        
    }
 
}
    func generateQRCode(id: String) -> UIImage? {
        let qrString = meshQrPrefix + id
        let data = qrString.dataUsingEncoding(NSISOLatin1StringEncoding)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("H", forKey: "inputCorrectionLevel")
            let transform = CGAffineTransformMakeScale(10, 10)
            
            if let output = filter.outputImage?.imageByApplyingTransform(transform) {
                return UIImage(CIImage: output)
            }
        }
        
        return nil
    }