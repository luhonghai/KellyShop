//
//  JSProduct.swift
//  KellyShop
//
//  Created by Hai Lu on 3/23/16.
//  Copyright © 2016 Hai Lu. All rights reserved.
//

import Foundation
import RealmSwift

class JSProduct : JSBaseEntity {
    dynamic var id = ""
    dynamic var name = ""
    dynamic var basePrice = 0
    dynamic var transferPrice = 0
    dynamic var sellPrice = 0
    dynamic var detail = ""
    dynamic var creator: JSUser!
    dynamic var search = ""
    dynamic var provider: JSProvider!
    dynamic var category: JSCategory?
    let photos = List<JSPhoto>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
