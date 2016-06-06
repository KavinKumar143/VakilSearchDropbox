//
//  PdfViewController.swift
//  VakilsearchDropbox
//
//  Created by KavinKumar on 03/06/16.
//  Copyright © 2016 KavinKumar. All rights reserved.
//

import UIKit
import SystemConfiguration
import SwiftyDropbox

class PdfViewController: UIViewController
{
    
    @IBOutlet var FileName: UILabel!
    var SelectedFileName = String()
    @IBOutlet var webview: UIWebView!
    
    
    override func viewDidLoad()
    {
        //SelectedFieldName
        let SelectedFieldNameKey = NSUserDefaults.standardUserDefaults()
        FileName.text = SelectedFieldNameKey.stringForKey("SelectedFieldName")

        let url : NSURL! = NSURL(string: "https://www.dropbox.com/s/2uhg1mefa363828/dropbox_for_business_user_guide.pdf?dl=0")
        self.webview.loadRequest(NSURLRequest(URL: url))
        
                
    }
    
    @IBAction func BackBtnPress(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
