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
import SCLAlertView

class UserProfileController: UIViewController {
    
    @IBOutlet weak var imgAvatar: UIImageView!
    
    @IBOutlet weak var lblUsername: UILabel!
    
    @IBOutlet weak var btnLogout: UIView!
    
    @IBOutlet weak var imgLogout: UIImageView!
    
    override func viewDidLoad() {
        //btnLogout.backgroundColor = UIColor.clearColor()
        //btnLogout.delegate = self
        lblUsername.text = AccountManager.current()?.name
        imgAvatar.layer.cornerRadius = imgAvatar.frame.width / 2
        imgAvatar.layer.masksToBounds = true
        if !(AccountManager.current()?.avatar)!.isEmpty {
            imgAvatar.load((AccountManager.current()?.avatar)!)
        }
        
        btnLogout.layer.cornerRadius = btnLogout.frame.height / 2
        btnLogout.layer.masksToBounds = true
        imgLogout.layer.cornerRadius = imgLogout.frame.width / 2
        imgLogout.layer.masksToBounds = true
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    @IBAction func doLogout(sender: AnyObject) {
        let alert = SCLAlertView()
        alert.addButton("đồng ý") {
            Logger.log("user logout")
            let manager = FBSDKLoginManager()
            manager.logOut()
            AccountManager.logout()
            NSNotificationCenter.defaultCenter().postNotificationName("backToLogin", object: nil)
        }
    
        alert.showInfo("đăng xuất", subTitle: "thoát khỏi tài khoản facebook ngay bây giờ?", closeButtonTitle: "không", duration: 0, colorStyle: 0xcb2228, colorTextButton: 0xffffff, circleIconImage: UIImage(named: "icon_logout_large.png"))
    
    }
}
