//
//  ViewController.swift
//  KellyShop
//
//  Created by Hai Lu on 3/21/16.
//  Copyright © 2016 Hai Lu. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import ImagePicker

class ViewController: UIViewController, FBSDKLoginButtonDelegate, ImagePickerDelegate, FBSDKSharingDelegate {

    @IBAction func clickShare(sender: AnyObject) {
        showImagePicker()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let fbLogin = FBSDKLoginButton()
        fbLogin.publishPermissions = ["publish_actions"]
        fbLogin.readPermissions = ["public_profile", "email", "user_friends", "user_birthday"]
        fbLogin.center = self.view.center
        fbLogin.delegate = self
        self.view.addSubview(fbLogin)
        if let token = FBSDKAccessToken.currentAccessToken() {
            Logger.log("User is login")
            self.requestProfile()
            showImagePicker()
        }
    }
    
    
    func requestProfile() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me?fields=id,name,email,birthday", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                //Handle error
                Logger.log(error)
            } else {
                Logger.log(result)
                
            }
        })
    }
    
    
    func showImagePicker() {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        Logger.log("login facebook complete")
        showImagePicker()
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        Logger.log("Did logout facebook")
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        Logger.log("Facebook will login")
        return true
    }
    
    func wrapperDidPress(images: [UIImage]) {
        
    }
    
    func cancelButtonDidPress() {
        
    }
    
    func doneButtonDidPress(images: [UIImage]) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
        if images.count > 0 {
            var photos = Array<FBSDKSharePhoto>()
            for image in images {
                let facebookShare = FBSDKSharePhoto()
                facebookShare.image = image
                facebookShare.userGenerated = true
                facebookShare.caption = ""
                photos.append(facebookShare)
            }
            let dic:[NSObject : AnyObject]! = [
                "og:type": "jennyshop:bag",
                "og:title": "All new Bags for SALE",
                "og:description": "Take a look at all new bags for SALE",
            ]
            let object = FBSDKShareOpenGraphObject(properties: dic)
            let action = FBSDKShareOpenGraphAction()
            action.actionType = "jennyshop:sell"
            action.setObject(object, forKey: "bag")
            action.setArray(photos, forKey: "image")
            action.setString(
                "true", forKey: "fb:explicitly_shared")
            action.setString("All new bads for sale", forKey: "message")
            let content = FBSDKShareOpenGraphContent()
            content.action = action
            content.previewPropertyName = "bag"

            
            let sharePhotos = FBSDKSharePhotoContent()
            sharePhotos.photos = photos
            
//           let shareDialog = FBSDKShareDialog()
//            shareDialog.fromViewController = self
//            shareDialog.shareContent = content
//            shareDialog.mode = FBSDKShareDialogMode.Native
//
//            shareDialog.show()
            
            FBSDKShareAPI.shareWithContent(content, delegate: self)
            
           //FBSDKShareDialog.showFromViewController(self, withContent: sharePhotos, delegate: self)
        }
    }
    
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        Logger.log("share didCompleteWithResults")
    }
    
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        Logger.log("share didFailWithError \(error)")
    }
    
    func sharerDidCancel(sharer: FBSDKSharing!) {
        Logger.log("share did cancel")
    }
}

