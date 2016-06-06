//
//  ViewController.swift
//  VakilsearchDropbox
//
//  Created by KavinKumar on 31/05/16.
//  Copyright © 2016 KavinKumar. All rights reserved.
//

import UIKit
import SwiftyDropbox

class ViewController: UIViewController
{
    
    var filenames: Array<String>?
    
    
    override func viewDidAppear(animated: Bool) {
        self.filenames = []
        
        // Check if the user is logged in
        // If so, display photo view controller
        if let client = Dropbox.authorizedClient
        {
            
            //If User Logged Successfully Move To Next Storyboard
            let backgroundViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TabViewController") as UIViewController!
            self.presentViewController(backgroundViewController, animated: false, completion: nil)
            
            
            // List contents of app folder
            client.files.listFolder(path: "").response
                {
                    response, error in
                if let result = response
                {
                   // print("Folder contents:")
                    for entry in result.entries
                    {
                        //print(entry.name)
                        
                        // Check that file is a photo (by file extension)
                        if entry.name.hasSuffix(".jpg") || entry.name.hasSuffix(".png")
                        {
                            // Add photo!
                            self.filenames?.append(entry.name)
                        }
                    }
                    
                }
                else
                {
                    print("Error: \(error!)")
                }
            }
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        // Number of pages is number of photos
        return self.filenames!.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    @IBAction func linkButtonPressed(sender: AnyObject) {
        // Present view to log in
        Dropbox.authorizeFromController(self)
    }
}

