//
//  JSProductPhoto.swift
//  KellyShop
//
//  Created by Hai Lu on 3/23/16.
//  Copyright © 2016 Hai Lu. All rights reserved.
//

import Foundation
import RealmSwift

class JSProductPhoto: Object {
    dynamic var name = ""
    dynamic var localPath = ""
    dynamic var remotePath = ""
    dynamic var createdDate = NSDate()
    dynamic var product: JSProduct?
    
}