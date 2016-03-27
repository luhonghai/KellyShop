//
//  JSShop.swift
//  KellyShop
//
//  Created by Hai Lu on 3/25/16.
//  Copyright © 2016 Hai Lu. All rights reserved.
//

import Foundation
import RealmSwift

class JSShop: JSBaseEntity {
    dynamic var id = ""
    dynamic var facebookId = ""
    dynamic var name = ""
    dynamic var address = ""
    dynamic var website = ""
    dynamic var contact = ""
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var instance: JSShop!
    
    static func defaultShop() -> JSShop {
        return JSShop(value: [
            "id" : "jennyshop",
            "facebookId" : "623469177687623",
            "name" : "Jenny's shop",
            "address" : "",
            "website" : "facebook.com/lovely.jenny.shop",
            "contact" : "liên hệ 01688.084.099 - 0913.998.692"
            ])
    }
    
    static func getInstance() -> JSShop {
        if instance == nil {
            let realm = try! Realm()
            instance = JSShop()
            let obj = realm.objects(JSShop).first!
            instance.name = obj.name
            instance.address = obj.address
            instance.facebookId = obj.facebookId
            instance.contact = obj.contact
            instance.website = obj.website
        }
        return instance
    }
}