//
//  UploadViewController.swift
//  VakilsearchDropbox
//
//  Created by KavinKumar on 04/06/16.
//  Copyright © 2016 KavinKumar. All rights reserved.
//

import UIKit
import SystemConfiguration
import SwiftyDropbox

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    @IBOutlet var ImageView: UIImageView!
   
    override func viewDidLoad()
    {
               
    }
    @IBAction func PickImagePress(sender: AnyObject)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.allowsEditing = false
        self.presentViewController(imagePicker, animated: true, completion: nil)

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
    {
      self.ImageView.image = image
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   
    @IBAction func UploadBtnPress(sender: AnyObject)
    {
        if ImageView.image == nil
        {
            print("No Image Selected")
            let myAlert = UIAlertController(title: "Alert", message: "Please Select File To Upload", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated: true, completion: nil)
            return
        }
        else
        {
            print("Image Selected")
            let client = Dropbox.authorizedClient
            let fileData = UIImageJPEGRepresentation(self.ImageView.image!, 1)
            let path = "/\(self.ImageView.image!).jpg"
            client!.files.upload(path: path, mode: .Overwrite, autorename: true, body: fileData!).response
                { response, error in
                    if let _ = response
                    {
                        print("OK")
                        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let MainVC : UIViewController = Storyboard.instantiateViewControllerWithIdentifier("FolderViewController")
                        self.presentViewController(MainVC, animated: true, completion: nil)
                    }
                    else
                    {
                        print("Error Uploading Files")
                        let myAlert = UIAlertController(title: "Alert", message: "File Not Uploaded Successfully", preferredStyle: UIAlertControllerStyle.Alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                        myAlert.addAction(okAction)
                        self.presentViewController(myAlert, animated: true, completion: nil)
                        //return
                        self.ImageView.image = nil
                    }
            }
        }
    }
}
