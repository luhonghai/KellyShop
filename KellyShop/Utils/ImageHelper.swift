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
}