//
//  JSBaseEntity.swift
//  KellyShop
//
//  Created by Hai Lu on 3/26/16.
//  Copyright © 2016 Hai Lu. All rights reserved.
//

import Foundation
import RealmSwift

class JSBaseEntity : Object {
    dynamic var createdDate = NSDate()
    dynamic var modifiedDate = NSDate()
    dynamic var isSync = false
    dynamic var timestamp: Double = 0
}
