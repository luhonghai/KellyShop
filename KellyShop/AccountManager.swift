//
//  AccountManager.swift
//  AccentEasy
//
//  Created by Hai Lu on 3/9/16.
//  Copyright © 2016 Hai Lu. All rights reserved.
//

import Foundation
import RealmSwift
import FBSDKCoreKit

class UserProfile: Object {
    dynamic var name = ""
    dynamic var email = ""
    dynamic var id = ""
    dynamic var dob = ""
    dynamic var avatar = ""
    dynamic var token = ""
}

class AccountManager {
    
    static var instance: UserProfile?
    
    class func current() -> UserProfile? {
        if instance == nil {
            let realm = try! Realm()
            let users = realm.objects(UserProfile)
            if users.count > 0 {
                instance = users.first
            }
        }
        return instance
    }
    
    class func save(user: UserProfile) {
        instance = user
        let realm = try! Realm()
        let users = realm.objects(UserProfile)
        if users.count > 0 {
            try! realm.write {
                realm.delete(users.first!)
            }
        }
        try! realm.write {
            realm.add(user)
        }
    }
    
    class func fetch(completion:(status: Bool) -> Void) {
        if isLogin() {
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me?fields=id,name,email,birthday", parameters: nil)
            graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                if ((error) != nil) {
                    Logger.logError(error)
                    completion(status: false)
                } else {
                    Logger.log(result)
                    let id:String =  result.valueForKey("id") as! String
                    let avatar:String = "https://graph.facebook.com/\(id)/picture?type=square&width=320&height=320"
                    let token = FBSDKAccessToken.currentAccessToken().tokenString
                    var username = result.valueForKey("email") as? String
                    if username == nil {
                        username = "\(id)@facebook.com"
                    }
                    let name = result.valueForKey("name") as! String
                    let dob = result.valueForKey("birthday") as? String;
                    let user = UserProfile()
                    user.id = id
                    user.name = name
                    if dob != nil {
                        user.dob = dob!
                    }
                    user.email = username!
                    user.avatar = avatar
                    user.token = token
                    save(user)
                    completion(status: true)
                }
            })
        } else {
            Logger.log("user not login")
            completion(status: false)
        }
    }
    
    class func logout() {
        let realm = try! Realm()
        let users = realm.objects(UserProfile)
        if users.count > 0 {
            try! realm.write {
                realm.delete(users.first!)
            }
        }
        instance = nil
    }
    
    class func isLogin() -> Bool {
        return FBSDKAccessToken.currentAccessToken() != nil //&& current() != nil
    }
}