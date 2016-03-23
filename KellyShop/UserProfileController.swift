//
//  UserProfileController.swift
//  KellyShop
//
//  Created by Hai Lu on 3/22/16.
//  Copyright © 2016 Hai Lu. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import ImageLoader

class UserProfileController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var imgAvatar: UIImageView!
    
    @IBOutlet weak var lblUsername: UILabel!
    
    @IBOutlet weak var btnLogout: FBSDKLoginButton!
    
    override func viewDidLoad() {
        btnLogout.backgroundColor = UIColor.clearColor()
        btnLogout.delegate = self
        lblUsername.text = AccountManager.current()?.name
        imgAvatar.layer.cornerRadius = imgAvatar.frame.width / 2
        imgAvatar.layer.masksToBounds = true
        if !(AccountManager.current()?.avatar)!.isEmpty {
            imgAvatar.load((AccountManager.current()?.avatar)!)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        Logger.log("user logout")
        AccountManager.logout()
        NSNotificationCenter.defaultCenter().postNotificationName("backToLogin", object: nil)
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
}
