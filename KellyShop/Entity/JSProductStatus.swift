//
//  JSProductStatus.swift
//  KellyShop
//
//  Created by Hai Lu on 3/23/16.
//  Copyright © 2016 Hai Lu. All rights reserved.
//

import Foundation
import RealmSwift

class JSProductStatus : JSBaseEntity {
    dynamic var id = ""
    dynamic var status = false
    dynamic var name = ""
    dynamic var detail = ""
    dynamic var creator: JSUser?
    dynamic var product: JSProduct?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
