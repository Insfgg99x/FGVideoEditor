//
//  FGVideoInfo.swift
//  FGVideoEditor
//
//  Created by xgf on 2018/3/27.
//  Copyright © 2018年 xgf. All rights reserved.
//

import UIKit

public class FGVideoInfo: NSObject {
    /**第一帧的图片*/
    open var image:UIImage?
    /**资源路径*/
    open var url:URL = URL.init(fileURLWithPath: "file:///")
    /**视频宽度*/
    open var width:CGFloat = 200
    /**视频高度*/
    open var height:CGFloat = 100
    /**视频的时长*/
    open var duration:CGFloat = 0.0
}
