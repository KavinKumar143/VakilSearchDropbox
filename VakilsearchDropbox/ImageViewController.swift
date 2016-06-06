//
//  ImageViewController.swift
//  VakilsearchDropbox
//
//  Created by KavinKumar on 03/06/16.
//  Copyright © 2016 KavinKumar. All rights reserved.
//
import UIKit
import SystemConfiguration
import SwiftyDropbox

class ImageViewController: UIViewController
{

    @IBOutlet var FileName: UILabel!
    var SelectedFileName = String()
    @IBOutlet var ImageView: UIImageView!
    
    override func viewDidLoad()
    {
        //SelectedFieldName
        let SelectedFieldNameKey = NSUserDefaults.standardUserDefaults()
        FileName.text = SelectedFieldNameKey.stringForKey("SelectedFieldName")
        
        //Getting Image UIViewController
        let destination : (NSURL, NSHTTPURLResponse) -> NSURL = { temporaryURL, response in
            let fileManager = NSFileManager.defaultManager()
            let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            // generate a unique name for this file in case we've seen it before
            let UUID = NSUUID().UUIDString
            let pathComponent = "\(UUID)-\(response.suggestedFilename!)"
            return directoryURL.URLByAppendingPathComponent(pathComponent)
        }
        
        Dropbox.authorizedClient!.files.getThumbnail(path: "/\(FileName.text!)", format: .Png, size: .W640h480, destination: destination).response
            { response, error in
                if let (metadata, url) = response, data = NSData(contentsOfURL: url), image = UIImage(data: data)
                {
                    
                    print("Dowloaded file name: \(metadata.name)")
                    
                    // Resize image for watch (so it's not huge)
                    let resizedImage = self.resizeImage(image)
                    
                    // Display image
                    self.ImageView.image = resizedImage
                    
                    // Save image to local filesystem app group - allows us to access in the watch
                    //let resizedImageData = UIImageJPEGRepresentation(resizedImage, 1.0)
                    //resizedImageData!.writeToURL(fileURL, atomically: true)
                    
                }
                else
                {
                    print("Error downloading file from Dropbox: \(error!)")
                }
        }


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

    @IBAction func BackBtnPress(sender: AnyObject)
    {
       self.dismissViewControllerAnimated(true, completion: nil)
    }
}