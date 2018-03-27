//
//  UIColor+Hex.swift
//  FGToolKit
//
//  Created by xgf on 2018/1/26.
//  Copyright © 2018年 xgf. All rights reserved.
//

import Foundation
import UIKit

public func hexcolor(_ hex:UInt) -> UIColor {
    return UIColor.init(hex: hex)
}

//hex value color
public extension UIColor {
    convenience init(hex:UInt) {
        let b = CGFloat(hex & 0xff) / CGFloat(255.0)
        let g = CGFloat((hex >> 8) & 0xff) / (255.0)
        let r = CGFloat((hex >> 16) & 0xff) / CGFloat(255.0)
        let a = hex > 0xffffff ? CGFloat((hex >> 24) & 0xff) / CGFloat(255.0) : 1.0
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    //hex string value color
    convenience init(hex:String) {
        var value = String.init(stringLiteral: hex)
        if hex.lowercased().hasPrefix("0x") {
            value = String(hex[hex.index(hex.startIndex, offsetBy: 2)...])
        }
        var tmp:UInt32 = 0
        let ret = Scanner.init(string: value).scanHexInt32(&tmp)
        guard ret else {
            self.init()
            return
        }
        self.init(hex: UInt(tmp))
    }
    class func hex(_ value:UInt) -> UIColor {
        return UIColor.init(hex: value)
    }
    class func hex(_ value:String) -> UIColor {
        return UIColor.init(hex: value)
    }
}
private var UIViewHexBackgroundColorKey = "UIViewHexBackgroundColorKey"
public extension UIView {
    var hex:UInt? {
        get{
            return objc_getAssociatedObject(self, &UIViewHexBackgroundColorKey) as? UInt
        }set(new){
            objc_setAssociatedObject(self, &UIViewHexBackgroundColorKey, new, .OBJC_ASSOCIATION_ASSIGN)
            if new != nil {
                backgroundColor = UIColor.init(hex: new!)
            }
        }
    }
}
