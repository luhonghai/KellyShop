//
//  LoginController.swift
//  KellyShop
//
//  Created by Hai Lu on 3/22/16.
//  Copyright © 2016 Hai Lu. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var btnLogin: FBSDKLoginButton!
    
    @IBOutlet weak var bgBottom: UIImageView!
    
    override func viewDidLoad() {
        btnLogin.delegate = self
        btnLogin.publishPermissions = ["publish_actions"]
        btnLogin.readPermissions = ["public_profile", "email", "user_friends", "user_birthday"]
        //self.bgBottom.translatesAutoresizingMaskIntoConstraints = true
        self.bgBottom.layer.masksToBounds = true
        weak var weakSelf = self
        if AccountManager.isLogin() {
            Logger.log("User is login")
            AccountManager.fetch({ (status) -> Void in
                if status {
                    weakSelf!.gotoMainPage()
                } else {
                    //TODO show login error
                }
            })
            
        } else {
            dispatch_async(dispatch_get_main_queue(),{
                UIView.animateWithDuration(15) { () -> Void in
                    self.bgBottom.frame.origin.x = self.view.frame.width - self.bgBottom.frame.width
                    
                }
            })
        }

    }

    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        Logger.log("login facebook complete")
        weak var weakSelf = self
        AccountManager.fetch({ (status) -> Void in
            if status {
                weakSelf!.gotoMainPage()
            } else {
                //TODO show login error
            }
        })
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        Logger.log("did logout facebook")
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        Logger.log("Facebook will login")
        return true
    }
    
    func gotoMainPage() {
        dispatch_async(dispatch_get_main_queue(),{
            Logger.log("go to main page")
            self.performSegueWithIdentifier("LoginToMain", sender: self)
        })
    }
}
