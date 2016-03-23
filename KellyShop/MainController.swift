//
//  MainController.swift
//  KellyShop
//
//  Created by Hai Lu on 3/22/16.
//  Copyright © 2016 Hai Lu. All rights reserved.
//

import UIKit
import RDVTabBarController

class TabBarItem {
    
    static let VALUES = [
        TabBarItem(controller: "ProductMainController", selectedImage: "icon_search.png", unselectedImage: "icon_search_gray.png"),
        TabBarItem(controller: "ProductEditorController", selectedImage: "icon_shopping_bag.png", unselectedImage: "icon_shopping_bag_gray.png"),
        TabBarItem(controller: "UserProfileController", selectedImage: "icon_profile.png", unselectedImage: "icon_profile_gray.png")
    ]
    
    var controller: String!
    var selectedImage: String!
    var unselectedImage: String!
    
    init(controller: String!, selectedImage: String!, unselectedImage: String!) {
        self.controller = controller
        self.selectedImage = selectedImage
        self.unselectedImage = unselectedImage
    }
}

class MainController: RDVTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var vcs = Array<UIViewController>()
        for tabbarItem in TabBarItem.VALUES {
            vcs.append(self.storyboard!.instantiateViewControllerWithIdentifier(tabbarItem.controller))
        }
        self.viewControllers = vcs
        let tabBar = self.tabBar
        tabBar.backgroundColor = ColorHelper.APP_DEFAULT
        let tabBarHeight: CGFloat = 50
        tabBar.frame = CGRectMake(CGRectGetMinX(tabBar.frame), CGRectGetMinY(tabBar.frame), CGRectGetWidth(tabBar.frame), tabBarHeight)
        var index = 0
        Logger.log("Tabbar item size \(tabBar.items.count)")
        for item in tabBar.items as! [RDVTabBarItem] {
            item.setBackgroundSelectedImage(UIImage(named: "bg_tabbar.png"), withUnselectedImage: UIImage(named: "bg_tabbar.png"))
            let selectedImg = TabBarItem.VALUES[index].selectedImage
            let unselectedImg = TabBarItem.VALUES[index].unselectedImage
            let selectedImage = ImageHelper.imageWithImage(UIImage(named: selectedImg)!, scaledToSize: CGSize(width: tabBarHeight, height: tabBarHeight))
            let unselectedImage = ImageHelper.imageWithImage(UIImage(named: unselectedImg)!, scaledToSize: CGSize(width: tabBarHeight, height: tabBarHeight))
            item.setFinishedSelectedImage(selectedImage,
                withFinishedUnselectedImage: unselectedImage)
            index++
        }
        
        initObserver()
    }
    
    func initObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "backToLogin:", name: "backToLogin", object: nil)
    }
    
    
    func backToLogin(notification: NSNotification)
    {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
}
