//
//  FGWebImage.swift
//  FGWebImage Demo
//
//  Created by 风过的夏 on 16/9/12.
//  Copyright © 2016年 风过的夏. All rights reserved.
//
/*
##async image loading like `SDWebImage` with cache in memery an disk
 ```
 fg_setImageWithUrl(url,placeHolder)
```
*/
import Foundation
import UIKit

// 7 days max allowed in disk cache
private let fg_maxCacheCycle:TimeInterval = 7*24*3600
private var fg_imagUrlStringKey="fg_imagUrlStringKey"
private var fg_diskCatahPathNameKey = "fg_diskCatahPathNameKey"
private let fg_imageCache=NSCache<AnyObject,AnyObject>()
private let fg_diskCachePath=NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last!+"/FGGAutomaticScrollViewCache"

public extension UIImageView {
    public func clearMermeryCache() {
        fg_imageCache.removeAllObjects()
    }
    public func clearDiskCache() {
        guard let files=FileManager.default.subpaths(atPath: fg_diskCachePath) else {
            return
        }
        guard files.count > 0 else {
            return
        }
        for file in files {
            do {
                try FileManager.default.removeItem(atPath: file)
            } catch {
                
            }
        }
    }
    public func fg_setImageWithUrl(_ urlString:String?,_ placeHolder:UIImage?) {
        self.image = placeHolder
        guard let link = urlString else {
            return
        }
        objc_setAssociatedObject(self, &fg_imagUrlStringKey, link,.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.createLoacalCacheFolder(path: fg_diskCachePath)
        var cachePath=fg_diskCachePath + "/\(link.hash)"
        objc_setAssociatedObject(self, &fg_diskCatahPathNameKey, cachePath, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        if link.hasPrefix("file://") {//local path
            cachePath = link
        }
        //check the memery chache exist or not(both local and web images)
        var data = fg_imageCache.object(forKey: cachePath as AnyObject) as? Data
        if data != nil {
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        } else {//not in memery cache,check if exist in disk or not
            //local images
            if (link.hasPrefix("file://")) {
                if let url = URL.init(string: link) {
                    do{
                        data = try Data.init(contentsOf: url)
                    } catch {
                        
                    }
                }
                //if local image exist
                if data != nil {
                    fg_imageCache.setObject(data! as AnyObject, forKey: cachePath as AnyObject)
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data!)
                    }
                }
                else{//local image is not exist,just ingnore
                    //ingnore
                }
            } else {//web images
                //check if exist in disk
                let exist=FileManager.default.fileExists(atPath: cachePath)
                if exist {//exist in disk
                    //check if expired
                    var attributes:Dictionary<FileAttributeKey,Any>?
                    do {
                        try attributes=FileManager.default.attributesOfItem(atPath: cachePath)
                    } catch {
                        
                    }
                    let createDate = attributes?[FileAttributeKey.creationDate] as! Date
                    let interval = Date.init().timeIntervalSince(createDate)
                    let expired=(interval > fg_maxCacheCycle)
                    if expired {//expired
                        //download image
                        self.donwloadDataAndRefreshImageView()
                    } else {//not expired
                        //load from disk
                        if let url = URL.init(string: link) {
                            do {
                                data = try Data.init(contentsOf: url)
                            } catch {
                                
                            }
                        }
                        if data != nil {//if has data
                            //cached in memery
                            fg_imageCache.setObject(data! as AnyObject, forKey: cachePath as AnyObject)
                            DispatchQueue.main.async {
                                self.image=UIImage(data: data!)
                            }
                        } else{//has not data
                            //donwload
                            self.donwloadDataAndRefreshImageView()
                        }
                    }
                } else {//not exist in disk
                    //download image
                    self.donwloadDataAndRefreshImageView()
                }
            }
        }
    }
}
private extension UIImageView {
    //MARK:create a cache area to cache web images
    private func createLoacalCacheFolder(path:String) {
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                
            } catch {
                
            }
        }
    }
}
private extension UIImageView {
    //async download image
    private func donwloadDataAndRefreshImageView() {
        guard let link = objc_getAssociatedObject(self, &fg_imagUrlStringKey) as? String else {
            return
        }
        let cachePath = objc_getAssociatedObject(self, &fg_diskCatahPathNameKey) as? String
        if cachePath != nil {
            do {
                try FileManager.default.removeItem(atPath: cachePath!)
            } catch {
                
            }
        }
        //download data
        guard let url=URL.init(string: link) else {
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { (resultData, _, _) in
            guard let data =  resultData  else {
                return
            }
            let fileUrl=URL.init(fileURLWithPath: cachePath!)
            do {
                try data.write(to: fileUrl, options:.atomic)
            } catch {
                
            }
            fg_imageCache.setObject(data as AnyObject, forKey: cachePath as AnyObject)
            DispatchQueue.main.async{
                self.image=UIImage(data: data)
            }
        }).resume()
    }
}
