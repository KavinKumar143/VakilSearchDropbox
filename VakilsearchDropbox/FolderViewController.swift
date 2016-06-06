//
//  FolderViewController.swift
//  VakilsearchDropbox
//
//  Created by KavinKumar on 01/06/16.
//  Copyright © 2016 KavinKumar. All rights reserved.
//

import UIKit
import SystemConfiguration
import SwiftyDropbox

class FolderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    //Level1 Process
    @IBOutlet var tableview: UITableView!
    @IBOutlet var TempFileName: UILabel!
    @IBOutlet var ImageView: UIImageView!
    @IBOutlet var SignOutBtn: UIButton!
    @IBOutlet var CloseBtnPress: UIButton!
    @IBOutlet var FilenameLabel: UILabel!
    @IBOutlet var SelectedFile: UILabel!
    @IBOutlet var PhotoImage: UIImageView!
    
    var filename: String?
    var filenames: Array<String>?
 
    var FilesArray = [FileItem]()
    var i = 0
    
    override func viewDidLoad()
    {

        self.TempFileName.hidden = true
        self.filenames = []
        // List contents of app folder
        let client = Dropbox.authorizedClient
        client!.files.listFolder(path: "").response { response, error in
            if let result = response
            {
                for entry in result.entries
                {
                    // Add photo!
                    self.filenames?.append(entry.name)
                    print(entry.name)
                    self.TempFileName.text = ""
                    self.TempFileName.text = "\(entry.name)"
                    self.filedeclaration()
                }
            }
        }
    }
    @IBAction func logoutButtonPressed(sender: AnyObject)
    {
        // Unlink from Dropbox
        Dropbox.unlinkClient()
        
        // Dismiss view controller to show login screen
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //tableview
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.FilesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        var friend : FileItem
        friend = self.FilesArray[indexPath.row]
        cell.textLabel?.text = friend.name
        print("Cell Image Value: \(friend.name)")
        
        //Displaying Image
        if friend.name.hasSuffix(".jpg") || friend.name.hasSuffix(".png")
        {
            cell.imageView?.image = UIImage(named: "image_icon.png")
        }
        else if friend.name.hasSuffix(".pdf")
        {
            cell.imageView?.image = UIImage(named: "pdf.png")
        }
        else
        {
            cell.imageView?.image = UIImage(named: "folder.png")
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var friend : FileItem
        friend = self.FilesArray[indexPath.row]
        print(friend.name)
        print("Selected File Name: \(friend.name)")
        self.SelectedFile.text = friend.name

        // Database Operations
        let SelectedFieldNameText = SelectedFile.text
        NSUserDefaults.standardUserDefaults().setObject(SelectedFieldNameText, forKey: "SelectedFieldName")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        // Check that file is a photo (by file extension)
        if friend.name.hasSuffix(".jpg") || friend.name.hasSuffix(".png")
        {
            print("Selected File Is An Photo")
            //Moving To ImageViewController Storyboard
            dispatch_async(dispatch_get_main_queue())
            {
                let Storyboard = UIStoryboard(name: "Main", bundle: nil)
                let MainVC : UIViewController = Storyboard.instantiateViewControllerWithIdentifier("ImageViewController")
                self.presentViewController(MainVC, animated: true, completion: nil)
            }
        }
        else if friend.name.hasSuffix(".pdf")
        {
            print("Selected File Is An Pdf")
            //Moving To Next StoryBoard
            dispatch_async(dispatch_get_main_queue())
            {
                let Storyboard = UIStoryboard(name: "Main", bundle: nil)
                let MainVC : UIViewController = Storyboard.instantiateViewControllerWithIdentifier("PdfViewController")
                self.presentViewController(MainVC, animated: true, completion: nil)
            }
        }
        else
        {
            //Moving To Next StoryBoard
            dispatch_async(dispatch_get_main_queue())
            {
                let Storyboard = UIStoryboard(name: "Main", bundle: nil)
                let MainVC : UIViewController = Storyboard.instantiateViewControllerWithIdentifier("FolderViewController2")
                self.presentViewController(MainVC, animated: true, completion: nil)
            }
        }
    }

    //File Declaration
    func filedeclaration()
    {
        print("Declaring Files")
        self.FilesArray += [FileItem(name: "\(TempFileName.text!)")]
        //self.tableView.reloadData()
        self.tableview.performSelectorOnMainThread(#selector(UITableView.reloadData), withObject: nil, waitUntilDone: true)
    }
    
    //Image Resize
    private func resizeImage(image: UIImage) -> UIImage {
        
        // Resize and crop to fit Apple watch (square for now, because it's easy)
        let maxSize: CGFloat = 200.0
        var size: CGSize?
        
        if image.size.width >= image.size.height {
            size = CGSizeMake((maxSize / image.size.height) * image.size.width, maxSize)
        } else {
            size = CGSizeMake(maxSize, (maxSize / image.size.width) * image.size.height)
        }
        
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size!, !hasAlpha, scale)
        
        let rect = CGRect(origin: CGPointZero, size: size!)
        UIRectClip(rect)
        image.drawInRect(rect)
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}