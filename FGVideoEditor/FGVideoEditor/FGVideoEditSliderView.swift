//
//  FGVideoEditSliderView.swift
//  SkateMoments
//
//  Created by xgf on 2018/3/27.
//  Copyright © 2018年 xgf. All rights reserved.
//

import UIKit
import AVFoundation

public class FGVideoEditSliderView: UIView {
    var imgw:CGFloat = 50
    var url:URL!
    var cropStart:CGFloat {
        get {
            let xpos = contentView.contentOffset.x + overlay.frame.origin.x
            let start = (xpos / contentView.contentSize.width) * duration
            return start
        }
    }
    var cropDuration:CGFloat {
        get {
            let cropAreaDuration = (overlay.frame.size.width / contentView.contentSize.width) * duration
            return cropAreaDuration
        }
    }
    var cropRange:CMTimeRange {
        get {
            let xpos = contentView.contentOffset.x + overlay.frame.origin.x
            let start = (xpos / contentView.contentSize.width) * duration
            let cropAreaDuration = (overlay.frame.size.width / contentView.contentSize.width) * duration
            let startcm = CMTimeMakeWithSeconds(Float64(start), timescale)
            let durationcm = CMTimeMakeWithSeconds(Float64(cropAreaDuration), timescale)
            let range = CMTimeRangeMake(startcm, durationcm)
            return range
        }
    }
    var cropWidth:CGFloat {
        get {
            return overlay.bounds.size.width
        }
    }
    var indicatorXpos:CGFloat = 0 {
        didSet {
            if overlay != nil {
                overlay.indicatorXpos = indicatorXpos
            }
        }
    }
    private var overlay:FGVideoCropOverlay!
    private var imageGenerator:AVAssetImageGenerator!
    private var duration:CGFloat = 0
    private var timescale:CMTimeScale = 600
    private var maxduration:CGFloat = 0
    private let framesInScreen = 10
    private let imgh:CGFloat = 50
    private var contentView = UIScrollView.init()
    var slidingBeginHandler:(() -> ())?
    var slidingHandler:((FGSlideDirection) -> ())?
    var slidingEndHandler:(() -> ())?
    var contentDidScrollHandler:(() -> ())?
    var dragWillBeginHandler:(() -> ())?
    var dragDidEndHandler:(() -> ())?
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
public extension FGVideoEditSliderView {
    /*!
     @method            init(frame: CGRect, url:URL, imgw:CGFloat)
     @abstract          video edit slider view for given url and imgw per frame.
     @param             frame frame
     @param             url   given asset url or file url
     @param             imgw  width per frame(suggested width: 30)
     @param             maxduration max video crop duration
     @result            Void
     @discussion        通过给定的资源url和每一帧的图片宽度得到一个slider
     */
    public convenience init(frame: CGRect, url:URL, imgw:CGFloat, maxduration:CGFloat) {
        self.init(frame: frame)
        self.url = url
        self.imgw = imgw
        self.maxduration = maxduration
        setup()
        createUI()
    }
}
private extension FGVideoEditSliderView {
    private func setup() {
        let asset = AVAsset.init(url: url)
        imageGenerator = AVAssetImageGenerator.init(asset: asset)
        imageGenerator?.appliesPreferredTrackTransform = true
        imageGenerator?.maximumSize = .init(width: 200.0, height: 200.0)
        imageGenerator?.apertureMode = .encodedPixels
        
        let assetDuration = asset.duration
        timescale = assetDuration.timescale
        duration = CGFloat(CMTimeGetSeconds(assetDuration))
    }
    private func createUI() {
        contentView.delegate = self
        contentView.backgroundColor = UIColor.init(white: 0.0, alpha: 0.7)
        contentView.showsHorizontalScrollIndicator = false
        
        var timegap:CGFloat = 1.0
        if duration > maxduration {
            timegap = 1.0
        } else {
            timegap = duration / CGFloat(framesInScreen)
        }
        var i = 0
        var time:CGFloat = 0.0
        var totalw:CGFloat = 0
        while time <= duration {
            let imv = UIImageView.init()
            imv.contentMode = .scaleAspectFill
            imv.clipsToBounds = true
            contentView.addSubview(imv)
            var w = imgw
            if time + timegap > duration {
                w = (timegap - (duration - time)) / timegap * imgw
            }
            imv.snp.makeConstraints({ (make) in
                make.left.equalToSuperview().offset(CGFloat(i) * imgw)
                make.top.equalToSuperview()
                make.size.equalTo(CGSize.init(width: w, height: imgh))
            })
            DispatchQueue.global().async {
                let image = self.imageFromVideo(at: time)
                DispatchQueue.main.async {
                    imv.image = image
                }
            }
            time += timegap
            i += 1
            totalw += w
        }
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(imgh)
        }
        contentView.contentSize = .init(width: totalw, height: imgh)
        
        //overlay
        var sliderDuration:CGFloat = 0
        let sliderW = bounds.size.width
        if duration > maxduration {
            sliderDuration = maxduration
        } else {
            sliderDuration = duration
        }
        
        overlay = FGVideoCropOverlay.init(frame: bounds)
        overlay.minWidth = (minvideoduration / sliderDuration * sliderW)
        addSubview(overlay)
        
        weak var wkself = self
        overlay.slidingBeginHandler = {
            if wkself?.slidingBeginHandler != nil {
               wkself?.slidingBeginHandler?()
            }
        }
        overlay.slidingHandler = { (direction) in
            if wkself?.slidingHandler != nil {
                wkself?.slidingHandler?(direction)
            }
        }
        overlay.slidingEndHandler = {
            if wkself?.slidingEndHandler != nil {
                wkself?.slidingEndHandler?()
            }
        }
    }
}
//MARK: - fetch image for given time
private extension FGVideoEditSliderView {
    private func imageFromVideo(at: CGFloat) -> UIImage {
        do {
            let ct = CMTimeMakeWithSeconds(Float64(at), timescale)
            let ref = try imageGenerator.copyCGImage(at: ct, actualTime: nil)
            let image = UIImage.init(cgImage: ref)
            return image
        } catch let e {
            print(e.localizedDescription)
        }
        return UIImage.init()
    }
}
extension FGVideoEditSliderView : UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if contentDidScrollHandler != nil {
            contentDidScrollHandler?()
        }
    }
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if dragWillBeginHandler != nil {
            dragWillBeginHandler?()
        }
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if dragDidEndHandler != nil {
            dragDidEndHandler?()
        }
    }
}
