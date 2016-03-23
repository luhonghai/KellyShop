//
//  ImageHelper.swift
//  ecoSale
//
//  Created by Hai Lu on 3/20/16.
//  Copyright © 2016 Hai Lu. All rights reserved.
//

import Foundation
import UIKit

class ImageHelper {
    
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
        let maskRef = maskImage.CGImage;
        let mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
        CGImageGetHeight(maskRef),
        CGImageGetBitsPerComponent(maskRef),
        CGImageGetBitsPerPixel(maskRef),
        CGImageGetBytesPerRow(maskRef),
        CGImageGetDataProvider(maskRef), nil, false)
        let masked = CGImageCreateWithMask(image.CGImage, mask)
        return UIImage(CGImage: masked!)
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
