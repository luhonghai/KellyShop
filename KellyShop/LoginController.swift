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
import TOWebViewController
import SwiftSpinner

class LoginController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var btnLogin: FBSDKLoginButton!
    
    @IBOutlet weak var bgBottom: UIImageView!
    
    let waitTime:Double = 1
    
    override func viewDidLoad() {
        btnLogin.delegate = self
        btnLogin.backgroundColor = UIColor.clearColor()
        btnLogin.publishPermissions = ["publish_actions"]
        btnLogin.readPermissions = ["public_profile", "email", "user_friends", "user_birthday"]
        //self.bgBottom.translatesAutoresizingMaskIntoConstraints = true
        self.bgBottom.layer.masksToBounds = true
        weak var weakSelf = self
        if AccountManager.IS_DEBUG {
            weakSelf!.gotoMainPage()
        } else if AccountManager.isLogin() {
            Logger.log("User is login")
            if DeviceManager.isConnectedToNetwork() {
                dispatch_async(dispatch_get_main_queue(),{
                    SwiftSpinner.show("đang xác thực tài khoản, vui lòng chờ trong giây lát ...")
                })
                AccountManager.fetch({ (status) -> Void in
                    delay(weakSelf!.waitTime, closure: {
                        SwiftSpinner.hide()
                        if status {
                            weakSelf!.gotoMainPage()
                        } else {
                            //TODO show login error
                        }
                    })
                })
            } else {
                weakSelf!.gotoMainPage()
            }
            
        } else {
            dispatch_async(dispatch_get_main_queue(),{
                UIView.animateWithDuration(15) { () -> Void in
                    self.bgBottom.frame.origin.x = self.view.frame.width - self.bgBottom.frame.width
                    
                }
            })
        }

    }

    @IBAction func btnPrivacy(sender: AnyObject) {
        let webview = TOWebViewController(URLString: "http://luhonghai.github.io/readme/jenny-shop/privacy-policy.html")
        let padding: CGFloat = 30
        webview.view.frame = CGRectMake(self.view.frame.origin.x + padding, self.view.frame.origin.y + padding, self.view.frame.width - padding  * 2, self.view.frame.height - padding * 2)
        self.presentpopupViewController(webview, animationType: .Fade) { 
            
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        Logger.log("login facebook complete")
        SwiftSpinner.show("đang xác thực tài khoản, vui lòng chờ trong giây lát ...")
        weak var weakSelf = self
        AccountManager.fetch({ (status) -> Void in
            delay(weakSelf!.waitTime, closure: {
                SwiftSpinner.hide()
                if status {
                    weakSelf!.gotoMainPage()
                } else {
                    //TODO show login error
                }

            })
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
