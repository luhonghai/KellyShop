//
//  DeviceManager.swift
//  AccentEasy
//
//  Created by Hai Lu on 3/11/16.
//  Copyright © 2016 Claybourne McGregor Consulting Ltd (CMG Ltd). All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit

class DeviceManager {
    
    class func doIfConnectedToNetwork(completion:() -> Void) {
        if isConnectedToNetwork() {
            completion()
        } else {
           
        }
    }
    
    class func setNavigationBarTransparent(vc: UIViewController) {
        vc.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        vc.navigationController?.navigationBar.shadowImage = UIImage()
        vc.navigationController?.navigationBar.translucent = true
        vc.navigationController?.view.backgroundColor = UIColor.clearColor()
    }
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    class func imei() -> String {
        let newUniqueID = CFUUIDCreate(kCFAllocatorDefault)
        let newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
        let guid = newUniqueIDString as NSString
        return guid.lowercaseString
    }
    
}
