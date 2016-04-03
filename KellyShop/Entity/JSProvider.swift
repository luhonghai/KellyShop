//
//  JSProvider.swift
//  KellyShop
//
//  Created by Hai Lu on 3/25/16.
//  Copyright © 2016 Hai Lu. All rights reserved.
//

import Foundation
import RealmSwift

class JSProvider : JSBaseEntity {
    dynamic var id = ""
    dynamic var name = ""
    dynamic var address = ""
    dynamic var phone = ""
    dynamic var detail = ""
    dynamic var search = ""
    dynamic var isEnable = true
    let photos = List<JSPhoto>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}