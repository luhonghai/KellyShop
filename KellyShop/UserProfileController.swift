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
import SCLAlertView_Objective_C

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
            imgAvatar.load((AccountManager.current()?.avatar)!, placeholder: UIImage(named: "icon_profile.png"))
        }
        
        btnLogout.layer.cornerRadius = kCornerRadius
        btnLogout.layer.masksToBounds = true
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    @IBAction func doLogout(sender: AnyObject) {
        let builder = SCLAlertViewBuilder().addButtonWithActionBlock("đồng ý", {
            Logger.log("user logout")
            let manager = FBSDKLoginManager()
            manager.logOut()
            AccountManager.logout()
            NSNotificationCenter.defaultCenter().postNotificationName("backToLogin", object: nil)
        }).shouldDismissOnTapOutside(true)
        let showBuilder = SCLAlertViewShowBuilder()
            .style(.Custom)
            .title("đăng xuất")
            .subTitle("thoát khỏi tài khoản facebook ngay bây giờ?")
            .color(ColorHelper.APP_RED)
            .image(UIImage(named: "icon_logout_large.png"))
            .closeButtonTitle("không")
    
        
        showBuilder.showAlertView(builder.alertView, onViewController: self)
    }
}
