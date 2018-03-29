//
//  FGVideoEditTool.swift
//  FGVideoEditor
//
//  Created by xgf on 2018/3/27.
//  Copyright © 2018年 xgf. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia

class FGVideoEditTool: NSObject {
    //MARK - get veido pixel image
    public class func videoInfo(_ with:URL, at:TimeInterval) -> FGVideoInfo {
        let info = FGVideoInfo.init()
        info.url = with
        let asset = AVAsset.init(url: with)
        let duration = CGFloat(CMTimeGetSeconds(asset.duration))
        info.duration = duration
        let generator = AVAssetImageGenerator.init(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.apertureMode = .encodedPixels
        var image:UIImage? = nil
        do {
            let ref = try generator.copyCGImage(at: .init(value: .init(at), timescale: 60), actualTime: nil)
            image = UIImage.init(cgImage: ref)
            info.width = image!.size.width
            info.height = image!.size.height
        } catch let e {
            print(e.localizedDescription)
            info.width = 200
            info.height = 100
        }
        info.image = image
        return info
    }
}
