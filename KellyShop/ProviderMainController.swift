//
//  ProviderMainController.swift
//  KellyShop
//
//  Created by Hai Lu on 3/26/16.
//  Copyright © 2016 Hai Lu. All rights reserved.
//

import Foundation
import RealmSearchViewController
import RealmSwift

class ProviderTableViewCell: UITableViewCell {
    
    @IBOutlet var imgCall: UIImageView!
    
    @IBOutlet var imgCategory: UIImageView!
    
    @IBOutlet var lblName: UILabel!
    
    @IBOutlet var txtAddress: UITextView!
    
    @IBOutlet var lblPhone: UILabel!
    
    @IBOutlet var container: UIView!
    
}

class ProviderMainController : RealmSearchViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateTableViewLayout()
    }
    
    override func viewDidDisappear(animated: Bool) {
        //Logger.log("view did disapper")
        
    }
    
    func updateTableViewLayout() {
        let inset = UIEdgeInsetsMake(20, 0, 0, 0)
        self.tableView.contentInset = inset
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.searchBar.frame.height, 0,0,0)
        self.tableView.tableHeaderView?.backgroundColor = ColorHelper.APP_DEFAULT
        self.searchBar.backgroundColor = ColorHelper.APP_DEFAULT
        self.searchBar.barTintColor = ColorHelper.APP_DEFAULT
        self.searchBar.tintColor = UIColor.whiteColor()
        self.searchBar.backgroundImage = UIImage()
        let bgView = UIView()
        bgView.frame = self.view.frame
        bgView.backgroundColor = ColorHelper.APP_DEFAULT
        self.tableView.backgroundView = bgView
    }
    
    override func searchViewController(controller: RealmSearchViewController, didSelectObject anObject: Object, atIndexPath indexPath: NSIndexPath) {
        if let provider = anObject as? JSProvider {
            Logger.log("select provider code \(provider.id)")
        }
    }
    
    override func searchViewController(controller: RealmSearchViewController, cellForObject object: Object, atIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("providerCell", forIndexPath: indexPath) as! ProviderTableViewCell
        cell.imgCall.layer.cornerRadius = cell.imgCall.frame.width / 2
        cell.imgCall.clipsToBounds = true
        cell.container.layer.cornerRadius = kCornerRadius
        if let provider = object as? JSProvider {
            cell.lblName.text = provider.name
            cell.lblPhone.text = provider.phone
            cell.txtAddress.text = provider.address

        }
        return cell
    }
}