//
//  FileHelper.swift
//  AccentEasy
//
//  Created by CMG on 29/01/2016.
//  Copyright © 2016 Hai Lu. All rights reserved.
//

import Foundation

class FileHelper {
        
    class func getFilePath(path: String, directory: Bool = false) -> String {
        let fileManager = NSFileManager.defaultManager()
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let folderPath = documentsDirectory.stringByAppendingPathComponent(path)
        if (directory) {
            do {
                var isDir = ObjCBool(true)
                if !fileManager.fileExistsAtPath(folderPath, isDirectory: &isDir) {
                    try fileManager.createDirectoryAtPath(folderPath, withIntermediateDirectories: false, attributes: nil)
                }
            } catch let error as NSError {
                Logger.log(error.localizedDescription);
            }
        }
        return folderPath;
    }
    
    class func isExists(path: String, directory: Bool = false) -> Bool {
        let fileManager = NSFileManager.defaultManager()
        if (directory) {
            var isDir = ObjCBool(true)
            return fileManager.fileExistsAtPath(path, isDirectory: &isDir)
        } else {
            return fileManager.fileExistsAtPath(path);
        }
    }
    
    class func writeFile(path: String, content: String) throws {
        do {
            try content.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
        } catch let e as NSError {
            throw e;
        }
    }
    
    class func readFile(path: String) throws -> String {
        do {
            return try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
        } catch let e as NSError {
            throw e;
        }
    }
    
    class func copyFile(fromPath: String, toPath: String) {
        do {
            try NSFileManager.defaultManager().copyItemAtPath(fromPath, toPath: toPath)
        } catch {
            
        }
    }
    
    class func deleteFile(path: String) {
        do {
            try NSFileManager.defaultManager().removeItemAtPath(path)
        } catch {
            
        }
    }
    
    class func readFileBundle(name: String!, type: String!) -> String {
        do {
            return try readFile(NSBundle.mainBundle().pathForResource(name, ofType: type)!)
        } catch {
            
        }
        return ""
    }
}