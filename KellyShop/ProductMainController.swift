//
//  ProductMainController.swift
//  KellyShop
//
//  Created by Hai Lu on 3/22/16.
//  Copyright © 2016 Hai Lu. All rights reserved.
//

import UIKit
import RealmSearchViewController
import RealmSwift

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet var imgProduct: UIImageView!
    
    @IBOutlet var imgCategory: UIImageView!
    
    @IBOutlet var lblCode: UILabel!
    
    @IBOutlet var txtName: UITextView!
    
    @IBOutlet var lblPrice: UILabel!
    
    @IBOutlet var container: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(10, 10, 10, 10))
    }
}


class ProductMainController: RealmSearchViewController {
    
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
        if let product = anObject as? JSProduct {
            Logger.log("select product code \(product.id)")
        }
    }
    
    override func searchViewController(controller: RealmSearchViewController, cellForObject object: Object, atIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("productCell", forIndexPath: indexPath) as! ProductTableViewCell
        cell.imgProduct.layer.cornerRadius = kCornerRadius
        cell.imgProduct.clipsToBounds = true
        cell.container.layer.cornerRadius = kCornerRadius
        
        if let product = object as? JSProduct {
            let category = product.category
            cell.lblCode.text = "Mã: \(product.id)"
            cell.lblPrice.text = "\(String(product.sellPrice))k - \(String(product.transferPrice))k"
            cell.txtName.text = product.name
            cell.imgCategory.image = UIImage(named: (category?.icon)!)
            if product.photos.count > 0 {
                let filePath = FileHelper.getFilePath(product.photos.first!.localPath)
                if FileHelper.isExists(filePath) {
                    cell.imgProduct.image = UIImage(contentsOfFile: filePath)
                } else {
                    cell.imgProduct.image = UIImage(named: (category?.icon)!)
                }
            } else {
                cell.imgProduct.image = UIImage(named: (category?.icon)!)
            }
        }
        return cell
    }
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .Normal, title: "Chia sẻ") { action, index in
            Logger.log("Share button tapped")
        }
        more.backgroundColor = UIColor.lightGrayColor()
        
        let favorite = UITableViewRowAction(style: .Normal, title: "Sửa") { action, index in
            Logger.log("Edit button tapped")
        }
        favorite.backgroundColor = UIColor.orangeColor()
        
        let share = UITableViewRowAction(style: .Normal, title: "Xóa") { action, index in
            Logger.log("Delete button tapped")
        }
        share.backgroundColor = UIColor.blueColor()
        
        return [share, favorite, more]
    }
}
