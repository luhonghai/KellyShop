//
//  ImageHelper.swift
//  ecoSale
//
//  Created by Hai Lu on 3/20/16.
//  Copyright © 2016 Hai Lu. All rights reserved.
//

import Foundation
import UIKit
import QRCode

class ImageHelper {
    
    static let kCacheDir = "image_cache"
    
    class func processImages(images: [UIImage]?, pid: String = "", completion:(imagePaths: [String]) -> Void) {
        if images == nil || images!.count == 0 {
            dispatch_async(dispatch_get_main_queue()) {
                completion(imagePaths: [])
            }
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                var list = Array<String>()
                FileHelper.getFilePath(kCacheDir, directory: true)
                for index in 0...(images!.count-1) {
                    var image = images![index]
                    if !pid.isEmpty {
                        image = generateWatermask(image, pid: pid)
                    }
                    
                    let imagePath = FileHelper.getFilePath("\(kCacheDir)/\(index).jpg")
                    UIImageJPEGRepresentation(image, 100)!.writeToFile(imagePath, atomically: true)
                    list.append(imagePath)
                }
                dispatch_async(dispatch_get_main_queue()) {
                    completion(imagePaths: list)
                }
            }
        }
        
    }
    
    class func generateWatermask(image: UIImage!, pid: String) -> UIImage {
        let imageView = UIImageView(image: image)
        let size = min(imageView.frame.width, imageView.frame.height)
        // Have photo ID. try to generate QR code
        var qrcode = QRCode("\(JSShop.getInstance().website)?rel=QRCode&id=\(pid)")
        qrcode?.color = CIColor(color: ColorHelper.APP_DEFAULT)
        var qrCodeWidth = size / 5
        qrcode?.size = CGSize(width: qrCodeWidth, height: qrCodeWidth)
        let imgQrCode = UIImageView(image: qrcode?.image)
        imageView.addSubview(imgQrCode)
        qrCodeWidth = imgQrCode.frame.width
        let strokeTextAttributes = [
            NSStrokeColorAttributeName : ColorHelper.APP_DEFAULT,
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSStrokeWidthAttributeName : -2.0,
            ]
        // Add product code
        let lblCode = LabelWithAdaptiveTextHeight()
        let lblCodeHeight = qrCodeWidth / 2
        lblCode.frame = CGRectMake(qrCodeWidth + 10, 10, imageView.frame.width - (qrCodeWidth + 10), lblCodeHeight)
        lblCode.adjustsFontSizeToFitWidth = true
        lblCode.textAlignment = NSTextAlignment.Left
        lblCode.attributedText = NSAttributedString(string:  "Mã: \(pid)", attributes: strokeTextAttributes)
        imageView.addSubview(lblCode)
        
        // Add shop logo at top
        let logoTopSize = 2 * qrCodeWidth / 3
        let imgLogoTop = UIImageView(image: imageWithImage(image: UIImage(named: "single-logo-without-background.png")!, w: logoTopSize, h: logoTopSize))
        imgLogoTop.backgroundColor = UIColor.clearColor()
        imgLogoTop.frame = CGRectMake(imageView.frame.width - logoTopSize, 0, logoTopSize, logoTopSize)
        imageView.addSubview(imgLogoTop)
        
        // Add shop facebook address
        let lblFacebook = LabelWithAdaptiveTextHeight()
        let lblFacebookHeight = qrCodeWidth / 4
        lblFacebook.frame = CGRectMake(qrCodeWidth + 10,lblCode.frame.origin.y + lblCode.frame.height  + 10, imageView.frame.width - (qrCodeWidth + 10), lblFacebookHeight)
        lblFacebook.adjustsFontSizeToFitWidth = true
        lblFacebook.textAlignment = NSTextAlignment.Left
        lblFacebook.attributedText = NSAttributedString(string:  JSShop.getInstance().website, attributes: strokeTextAttributes)
        imageView.addSubview(lblFacebook)
        
        
        
        
        // Add shop logo overlay
        let logoWidth = 2 * size / 3
        let imgLogo = UIImageView(image: imageWithImage(image: UIImage(named: "single-logo-without-background.png")!, w: logoWidth, h: logoWidth))
        imgLogo.backgroundColor = UIColor.clearColor()
        imgLogo.center = imageView.center
        imgLogo.alpha = 0.2
        imageView.addSubview(imgLogo)
        
        
        
        // Add phone
        let lblPhone = LabelWithAdaptiveTextHeight()
        let phoneHeight = size / 18
        lblPhone.frame = CGRectMake(0, imageView.frame.height - phoneHeight, imageView.frame.width, phoneHeight)
        lblPhone.adjustsFontSizeToFitWidth = true
        lblPhone.textColor = UIColor.whiteColor()
        lblPhone.textAlignment = NSTextAlignment.Center
        lblPhone.attributedText = NSAttributedString(string:  JSShop.getInstance().contact, attributes: strokeTextAttributes)
        imageView.addSubview(lblPhone)
        
        
        UIGraphicsBeginImageContext(imageView.frame.size)
        imageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
    
    class func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    class func imageWithImage(image image: UIImage, w: CGFloat, h: CGFloat) -> UIImage {
        let newSize = CGSize(width: w, height: h)
        return imageWithImage(image, scaledToSize: newSize)
    }
    
    class func maskImage(image: UIImage, maskImage: UIImage) -> UIImage {
        let imageView = UIImageView(image: image)
        let maskImageView = UIImageView(image: maskImage)
        imageView.addSubview(maskImageView)
        UIGraphicsBeginImageContext(imageView.frame.size)
        imageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
    
    class func multiplyImageByConstantColor(image:UIImage,color:UIColor)->UIImage{
        let backgroundSize = image.size
        UIGraphicsBeginImageContext(backgroundSize)
        
        let ctx = UIGraphicsGetCurrentContext()
        
        var backgroundRect=CGRect()
        backgroundRect.size = backgroundSize
        backgroundRect.origin.x = 0
        backgroundRect.origin.y = 0
        let ciColor = CoreImage.CIColor(color: color)
        let r = ciColor.red
        let g = ciColor.green
        let b = ciColor.blue
        let a = ciColor.alpha
        CGContextSetRGBFillColor(ctx, r, g, b, a)
        CGContextFillRect(ctx, backgroundRect)
        
        var imageRect=CGRect()
        imageRect.size = image.size
        imageRect.origin.x = (backgroundSize.width - image.size.width)/2
        imageRect.origin.y = (backgroundSize.height - image.size.height)/2
        
        // Unflip the image
        CGContextTranslateCTM(ctx, 0, backgroundSize.height)
        CGContextScaleCTM(ctx, 1.0, -1.0)
        
        CGContextSetBlendMode(ctx, .Multiply)
        CGContextDrawImage(ctx, imageRect, image.CGImage)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
