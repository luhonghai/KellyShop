//
//  JSCategory.swift
//  KellyShop
//
//  Created by Hai Lu on 3/23/16.
//  Copyright © 2016 Hai Lu. All rights reserved.
//

import Foundation
import RealmSwift

class JSCategory : JSBaseEntity {
    
    dynamic var id = ""
    dynamic var name = ""
    dynamic var code = ""
    dynamic var icon = ""
    dynamic var counter = 0
    dynamic var shop: JSShop?
    
    let products = List<JSProduct>()
    
    let providers = List<JSProvider>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    class func validateDatabase() {
        let categories = [
            JSCategory(value: [
                "id": "bag",
                "name": "Túi xách",
                "code": "B",
                "icon": "icon_bag.png"
                ]),
            JSCategory(value: [
                "id": "shoes",
                "name": "Giầy dép",
                "code": "S",
                "icon": "icon_shoes.png"
                ]),
            JSCategory(value: [
                "id": "glasses",
                "name": "Kính",
                "code": "G",
                "icon": "icon_glasses.png"
                ]),
            JSCategory(value: [
                "id": "clothes",
                "name": "Quần áo",
                "code": "C",
                "icon": "icon_clothes.png"
                ]),
            JSCategory(value: [
                "id": "watch",
                "name": "Đồng hồ",
                "code": "W",
                "icon": "icon_watch.png"
                ])

        ]
        let realm = try! Realm()
        try! realm.write({
            var shop: JSShop!
            if realm.objects(JSShop).count > 0  {
                shop = realm.objects(JSShop).first
            } else {
                shop = JSShop.defaultShop()
                realm.add(shop)
            }
            for category in categories {
                if let oldCategory = realm.objects(JSCategory).filter(NSPredicate(format: "id == %@", category.id)).first {
                    //Logger.log("Update category \(category.name) \(category.id)")
                    category.counter = oldCategory.counter
                    realm.add(category, update: true)
                } else {
                    //Logger.log("Create category \(category.name) \(category.id)")
                    category.shop = shop
                    realm.add(category)
                }
            }
            
        })
        JSShop.getInstance()
    }
}