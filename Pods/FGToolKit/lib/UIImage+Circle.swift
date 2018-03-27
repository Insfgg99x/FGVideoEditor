//
//  UIImage+Circle.swift
//  FGToolKit
//
//  Created by xgf on 2018/1/26.
//  Copyright © 2018年 xgf. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    //MARK: -
    //MARK: 高性能圆形图片
    func cirled() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        let path = UIBezierPath.init(ovalIn: .init(x: 0, y: 0, width: self.size.width, height: self.size.height))
        path.addClip()
        self.draw(at: .zero)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    class func cirle(image named:String) -> UIImage? {
        return self.init(named:named)?.cirled()
    }
    class func circle(image file:String) -> UIImage? {
        return UIImage.init(contentsOfFile: file)?.cirled()
    }
}
