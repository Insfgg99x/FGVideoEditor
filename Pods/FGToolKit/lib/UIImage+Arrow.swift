//
//  UIImage+Arrow.swift
//  Fate
//
//  Created by xgf on 2017/11/1.
//  Copyright © 2017年 sencent. All rights reserved.
//

import Foundation
import UIKit

 public enum UIImageArrowDirection {
     case left
     case right
 }

private let arrowWidth:CGFloat=6;
private let arrowHeight:CGFloat=10;
private let arrowTopMargin:CGFloat=13;//距离顶部距离

public extension UIImage{
    func arrowed(_ direction:UIImageArrowDirection, resizeTo:CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(resizeTo, false, 0.0)
        if direction == .left {
            let path=UIBezierPath.init(roundedRect: CGRect(x: arrowWidth, y: 0, width: resizeTo.width-arrowWidth, height: resizeTo.height), cornerRadius: 6)
            path.move(to: CGPoint.init(x: arrowWidth, y: 0))
            path.addLine(to: CGPoint.init(x: arrowWidth, y: arrowTopMargin))
            path.addLine(to: CGPoint.init(x: 0, y: arrowTopMargin+arrowHeight*0.5))
            path.addLine(to: CGPoint.init(x: arrowWidth, y: arrowTopMargin+arrowHeight))
            path.addClip()
            path.close()
            let context=UIGraphicsGetCurrentContext()
            context?.addPath(path.cgPath)
        }else{
            let path=UIBezierPath.init(roundedRect: CGRect(x: 0, y: 0, width: resizeTo.width-arrowWidth, height: resizeTo.height), cornerRadius: 6)
            path.move(to: CGPoint.init(x: resizeTo.width-arrowWidth, y: 0))
            path.addLine(to: CGPoint.init(x: resizeTo.width-arrowWidth, y: arrowTopMargin))
            path.addLine(to: CGPoint.init(x: resizeTo.width, y: arrowTopMargin+arrowHeight*0.5))
            path.addLine(to: CGPoint.init(x: resizeTo.width-arrowWidth, y: arrowTopMargin+arrowHeight))
            path.addClip()
            path.close()
            let context=UIGraphicsGetCurrentContext()
            context?.addPath(path.cgPath)
        }
        //CGContext.clip(context)
        self.draw(in: CGRect.init(x: 0, y: 0, width: resizeTo.width, height: resizeTo.height))
        let image=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    class func arrow(image:UIImage, direction:UIImageArrowDirection, resizeTo:CGSize) -> UIImage? {
        return image.arrowed(direction, resizeTo: resizeTo)
    }
}
