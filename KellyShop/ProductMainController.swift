//
//  ProductMainController.swift
//  KellyShop
//
//  Created by Hai Lu on 3/22/16.
//  Copyright © 2016 Hai Lu. All rights reserved.
//

import UIKit
import RealmSearchViewController

class ProductMainController: RealmSearchViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let inset = UIEdgeInsetsMake(20, 0, 0, 0)
        self.tableView.contentInset = inset
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
}
