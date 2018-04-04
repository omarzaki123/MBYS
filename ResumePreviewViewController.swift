//
//  ResumePreviewViewController.swift
//  Mesh
//
//  Created by Paa Adu on 9/7/16.
//  Copyright © 2016 Mobius. All rights reserved.
//

import UIKit

class ResumePreviewViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var resume: NSData?
    var filename = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = filename

        if let resume = resume {
            webView.loadData(resume, MIMEType: "application/pdf", textEncodingName: "utf-8", baseURL: NSURL())
            webView.scalesPageToFit = true // support pinch to zoom
        }
        // TODO: save resume locally and in firebase if user selects it
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
