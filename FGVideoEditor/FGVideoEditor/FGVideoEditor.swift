//
//  FGVideoEditor.swift
//  SkateMoments
//
//  Created by xia on 2018/3/26.
//  Copyright © 2018年 xgf. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import FGHUD
import CoreMedia

public class FGVideoEditor: NSObject {
    open static let shared = FGVideoEditor.init()
    private var videoFolder = ""
    override init() {
        super.init()
       setup()
    }
    private func setup() {
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        videoFolder = docPath + "/FGVideo"
        let exist = FileManager.default.fileExists(atPath: videoFolder)
        if !exist {
            do {
                try FileManager.default.createDirectory(atPath: videoFolder, withIntermediateDirectories: true, attributes: nil)
            } catch {
                videoFolder = docPath
            }
        }
    }
}
//MARK: - Crop
public extension FGVideoEditor {
    public func cropVideo(url: URL, cropRange:CMTimeRange, completion:((_ newUrl: URL, _ newDuration:CGFloat,_ result:Bool) -> ())?) {
        let asset = AVURLAsset.init(url: url, options: nil)
        let duration = CGFloat(CMTimeGetSeconds(asset.duration))
        let newPath = videoFolder + "/FGVideo" + UUID.init().uuidString + ".mov"
        let outputUrl = URL.init(fileURLWithPath: newPath)
        //let presets = AVAssetExportSession.exportPresets(compatibleWith: asset)
        guard let exportSession = AVAssetExportSession.init(asset: asset, presetName: AVAssetExportPresetPassthrough) else {
            if completion != nil {
                completion?(outputUrl,duration,false)
            }
            return
        }
        exportSession.outputURL = outputUrl
        exportSession.outputFileType = .mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.timeRange = cropRange
        exportSession.exportAsynchronously {
            let status = exportSession.status
            switch status {
            case .failed:
                if completion != nil {
                    completion?(outputUrl,duration,false)
                }
                break
            case .cancelled:
                if completion != nil {
                    completion?(outputUrl,duration,false)
                }
                break
            case .completed:
                if completion != nil {
                    completion?(outputUrl,duration,true)
                }
                break
            default:
                break
            }
        }
    }
}
//MARK: - Save
public extension FGVideoEditor {
    public func save(vedio fileUrl:URL, hud:Bool) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileUrl)
        }, completionHandler: { (result, error) in
            if !hud {
                return
            }
            if result {
                UIApplication.shared.keyWindow?.showHUD(.success("保存成功"))
            } else {
                UIApplication.shared.keyWindow?.showHUD(.error("保存失败"))
            }
        })
    }
}
//MARK: - Remove
public extension FGVideoEditor {
    public func removeVideo(at path:String) throws {
        guard path.contains("FGVideo") else {
            return
        }
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch let e{
            throw e
        }
    }
    public func removeAll(completion:(() -> ())?) {
        DispatchQueue.global().async {
            guard let paths = FileManager.default.subpaths(atPath: self.videoFolder) else {
                return
            }
            for p in paths {
                guard p.contains("FGVideo") else {
                    continue
                }
                let fullPath = self.videoFolder + "/" + p
                do {
                    try FileManager.default.removeItem(atPath: fullPath)
                } catch {
                    
                }
            }
            let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            guard let array = FileManager.default.subpaths(atPath: docPath) else {
                return
            }
            for p in array {
                guard p.contains("FGVideo") else {
                    continue
                }
                let fullPath = docPath + "/" + p
                guard p.contains("FGVideo") else {
                    continue
                }
                do {
                    try FileManager.default.removeItem(atPath: fullPath)
                } catch {
                    
                }
            }
        }
        if completion != nil {
            completion?()
        }
    }
    public func removeAll() {
        removeAll(completion: nil)
    }
}
