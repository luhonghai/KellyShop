//
//  Logger.swift
//  ecoSale
//
//  Created by Hai Lu on 3/20/16.
//  Copyright © 2016 Hai Lu. All rights reserved.
//

import Foundation

public class Logger {
    
    class func log(message: AnyObject!) {
       // LogMessageRaw(message as! String)
        //        NSLog(message as! String)
        //
        print(message)
    }
    
    class func logError(error: ErrorType!) {
        //NSLog("error \(error)")
        print(error)
        
    }
}