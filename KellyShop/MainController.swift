//
//  MainController.swift
//  KellyShop
//
//  Created by Hai Lu on 3/22/16.
//  Copyright © 2016 Hai Lu. All rights reserved.
//

import UIKit
import RDVTabBarController
import QRCodeReader
import AVFoundation

class TabBarItem {
    
    static let VALUES = [
        TabBarItem(controller: "ProductMainController", selectedImage: "icon_shopping_bag.png", unselectedImage: "icon_shopping_bag_gray.png"),
//        TabBarItem(controller: "ProductEditorController", selectedImage: "icon_shopping_bag.png", unselectedImage: "icon_shopping_bag_gray.png"),
//        TabBarItem(controller: "ProviderMainController", selectedImage: "icon_provider.png", unselectedImage: "icon_provider_gray.png"),
//        TabBarItem(controller: "SimpleCalculator", selectedImage: "icon_calculator.png", unselectedImage: "icon_calculator_gray.png"),
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

class MainController: RDVTabBarController, QRCodeReaderViewControllerDelegate {
    
    var reader:QRCodeReaderViewController!
    
    var btnQRCamera: UIButton!
    
    var btnAdd: UIButton!
    
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
            index += 1
        }
        initObserver()
        if QRCodeReader.isAvailable() {
            addCameraQRCodeButton()
        }
        addNewItemButton()
    }
    
    override func tabBar(tabBar: RDVTabBar!, shouldSelectItemAtIndex index: Int) -> Bool {
        return super.tabBar(tabBar, shouldSelectItemAtIndex: index)
    }
    
    override func tabBar(tabBar: RDVTabBar!, didSelectItemAtIndex index: Int) {
        super.tabBar(tabBar, didSelectItemAtIndex: index)
        let size = self.view.frame.width / 6
        if QRCodeReader.isAvailable() {
            let condition = index == 0
            UIView.animateWithDuration(0.5, animations: {
                self.btnQRCamera.alpha = condition ? 1 : 0
                self.btnQRCamera.frame.origin.y = self.view.frame.height - size * 1.5 - self.tabBar.frame.height - (condition ? 5 : -5)
                }, completion: { (status) in
                    //self.btnQRCamera.hidden = index != 0
            })
            
        }
        UIView.animateWithDuration(0.5, animations: {
            let condition = index == 0 // || index == 1
            self.btnAdd.alpha = condition ? 1 : 0
            self.btnAdd.frame.origin.y = self.view.frame.height - size * 1.5 - self.tabBar.frame.height - (condition ? 5 : -5)
        },
        completion: { (status) in
            //self.btnAdd.hidden = index != 2
        })
    }
    
    func reader(reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        print("QRCode \(result.value)")
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
    
    func readerDidCancel(reader: QRCodeReaderViewController) {
        self.dismissViewControllerAnimated(true) {
            
        }
    }
    
    
    @IBAction func tapQRCameraButton(sender: UIButton!) {
        if reader == nil {
            reader = QRCodeReaderViewController(cancelButtonTitle: "đóng", metadataObjectTypes: [AVMetadataObjectTypeQRCode])
            reader.modalPresentationStyle = .FormSheet
            reader.delegate = self
        }
        self.presentViewController(reader, animated: true, completion: nil)
    }
    
    @IBAction func tapAddButton(sender: UIButton!) {
        var identifier = ""
        switch self.selectedIndex {
        case 0:
            identifier = "ProductEditorController"
            break
        case 1:
            identifier = "ProviderEditorController"
            break
        default:
            break
        }
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier(identifier)
//        let padding:CGFloat = 20
//        controller!.view.frame = CGRectMake(self.view.frame.origin.x + padding, self.view.frame.origin.y + padding, self.view.frame.width - padding * 2, self.view.frame.height - padding * 2)
        self.presentViewController(controller!, animated: true) {
            
        }
    }
    
    func addNewItemButton() {
        let size = self.view.frame.width / 6
        btnAdd = UIButton(type: UIButtonType.Custom)
        btnAdd.frame =  CGRectMake(self.view.frame.width - size * 1.5, self.view.frame.height - size * 1.5 - self.tabBar.frame.height, size, size)
        btnAdd.setImage(ImageHelper.imageWithImage(image: UIImage(named: "icon_add")!, w: size, h: size), forState: UIControlState.Normal)
        btnAdd.backgroundColor = UIColor.clearColor()
        btnAdd.addTarget(self, action: #selector(MainController.tapAddButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btnAdd)

    }
    
    func addCameraQRCodeButton() {
        let size = self.view.frame.width / 6
        btnQRCamera = UIButton(type: UIButtonType.Custom)
        btnQRCamera.frame = CGRectMake(self.view.frame.width - size * 1.5, self.view.frame.height - size * 2.6 - self.tabBar.frame.height, size, size)
        btnQRCamera.setImage(ImageHelper.imageWithImage(image: UIImage(named: "icon_camera_qr_code")!, w: size, h: size), forState: UIControlState.Normal)
        btnQRCamera.backgroundColor = UIColor.clearColor()
        btnQRCamera.addTarget(self, action: #selector(MainController.tapQRCameraButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btnQRCamera)
    }
    
    func initObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainController.backToLogin(_:)), name: "backToLogin", object: nil)
    }
    
    
    func backToLogin(notification: NSNotification)
    {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
}
