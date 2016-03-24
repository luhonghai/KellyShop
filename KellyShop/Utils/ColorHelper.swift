//
//  ColorHelper.swift
//  AccentEasy
//
//  Created by Hai Lu on 04/02/2016.
//  Copyright © 2016 Hai Lu. All rights reserved.
//

import Foundation
import UIKit

public class ColorHelper {
    
    static let APP_DEFAULT = ColorHelper.colorWithHexString("#01b262")
    
    static let APP_DEFAULT_HEX:UInt = 0x01b262
    
    static let APP_DEFAULT_GRAY = ColorHelper.colorWithHexString("#95d0b5")
    
    static let APP_DEFAULT_GRAY_HEX:UInt = 0x95d0b5
    
    static let APP_RED = ColorHelper.colorWithHexString("#cb2228")
    
    static let APP_RED_HEX:UInt = 0xcb2228
    
    static let APP_BLUE = ColorHelper.colorWithHexString("#00b4eb")
    
    static let APP_BLUE_HEX:UInt = 0x00b4eb
    
    static let APP_WHITE_HEX:UInt = 0xffffff
    
    class func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    class func generateGradientColor(color1:UIColor, color2: UIColor, radio: CGFloat) -> UIColor {
        let ciColor1 = CoreImage.CIColor(color: color1)
        let ciColor2 = CoreImage.CIColor(color: color2)
        let red = radio * ciColor1.red + (1.0 - radio) * ciColor2.red
        let green = radio * ciColor1.green + (1.0 - radio) * ciColor2.green
        let blue = radio * ciColor1.blue + (1.0 - radio) * ciColor2.blue
        let alpha = radio * ciColor1.alpha + (1.0 - radio) * ciColor2.alpha
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}