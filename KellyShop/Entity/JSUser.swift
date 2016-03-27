//
//  JSUser.swift
//  KellyShop
//
//  Created by Hai Lu on 3/25/16.
//  Copyright © 2016 Hai Lu. All rights reserved.
//

import Foundation
import RealmSwift

class JSUser: JSBaseEntity {
    dynamic var id = ""
    dynamic var name = ""
    dynamic var phone = ""
    dynamic var address = ""
    dynamic var email = ""
    dynamic var dob = ""
    dynamic var isBlocked = false
    dynamic var isAdmin = false
    dynamic var isSaler = false
    dynamic var shop: JSShop?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func getFacebookAvatar() -> String {
        return "https://graph.facebook.com/\(id)/picture?type=square&width=320&height=320"
    }
}