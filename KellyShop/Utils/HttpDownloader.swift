//
//  HttpDownloader.swift
//  AccentEasy
//
//  Created by CMG on 20/01/2016.
//  Copyright © 2016 Hai Lu. All rights reserved.
//

import Foundation

class HttpDownloader {
    
    class func loadFileSync(url: NSURL, skipCache: Bool = false, destPath: String = "", completion:(path:String, error:NSError!) -> Void) {
        FileHelper.getFilePath("downloads", directory: true)
        let destinationUrl = destPath.isEmpty
            ? NSURL(fileURLWithPath: FileHelper.getFilePath("downloads/\(StringHelper.md5(string: url.absoluteString))"))
            : NSURL(fileURLWithPath: destPath)
        if NSFileManager().fileExistsAtPath(destinationUrl.path!) && !skipCache {
            Logger.log("file already exists [\(destinationUrl.path!)]")
            completion(path: destinationUrl.path!, error:nil)
        } else if let dataFromURL = NSData(contentsOfURL: url){
            if dataFromURL.writeToURL(destinationUrl, atomically: true) {
                Logger.log("file saved [\(destinationUrl.path!)]")
                completion(path: destinationUrl.path!, error:nil)
            } else {
                Logger.log("error saving file")
                let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
                completion(path: destinationUrl.path!, error:error)
            }
        } else {
            let error = NSError(domain:"Error downloading file", code:1002, userInfo:nil)
            completion(path: destinationUrl.path!, error:error)
        }
    }
    
    class func loadFileAsync(url: NSURL, skipCache: Bool = false, destPath: String = "", completion:(path:String, error:NSError!) -> Void) {
        FileHelper.getFilePath("downloads", directory: true)
        let destinationUrl = destPath.isEmpty
            ? NSURL(fileURLWithPath: FileHelper.getFilePath("downloads/\(StringHelper.md5(string: url.absoluteString))"))
            : NSURL(fileURLWithPath: destPath)
        if NSFileManager().fileExistsAtPath(destinationUrl.path!)  && !skipCache {
            Logger.log("file already exists [\(destinationUrl.path!)]")
            completion(path: destinationUrl.path!, error:nil)
        } else {
            let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                if (error == nil) {
                    if let response = response as? NSHTTPURLResponse {
                        Logger.log("response=\(response)")
                        if response.statusCode == 200 {
                            if data!.writeToURL(destinationUrl, atomically: true) {
                                Logger.log("file saved [\(destinationUrl.path!)]")
                                completion(path: destinationUrl.path!, error:error)
                            } else {
                                Logger.log("error saving file")
                                let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
                                completion(path: destinationUrl.path!, error:error)
                            }
                        }
                    }
                }
                else {
                    Logger.log("Failure: \(error!.localizedDescription)");
                    completion(path: destinationUrl.path!, error:error)
                }
            })
            task.resume()
        }
    }
}