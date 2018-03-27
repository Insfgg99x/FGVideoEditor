//
//  ImageCropView.swift
//  FriendCircle
//
//  Created by xgf on 2018/1/19.
//  Copyright © 2018年 HuaZhongShiXun. All rights reserved.
//

import UIKit
import CoreImage
import SnapKit

typealias ImageCropMode = CGFloat
let ImageCropModewh57:ImageCropMode = 0.7142857// w/h = 5/7
let ImageCropModewh11:ImageCropMode = 1.0//w/h = 1:1
let ImageCropModewh32:ImageCropMode = 1.5//w/h = 3:2
let ImageCropModewh43:ImageCropMode = 1.3333333//w/h = 4:3/
/*!不用枚举，否则在OC中无法使用
enum ImageCropMode : CGFloat {
    case wh57 = 0.7142857// w/h = 5/7
    case wh11 = 1.0//w/h = 1:1
    case wh32 = 1.5//w/h = 3:2
    case wh43 = 1.3333333//w/h = 4:3
}*/
class ImageCropView: UIView, UIScrollViewDelegate {

    var sourceImage:UIImage?
    var cropMode:ImageCropMode = ImageCropModewh11
    var completion:((UIImage) -> ())?
    fileprivate var imv = UIImageView.init()
    fileprivate var scroll:UIScrollView = UIScrollView.init()
    fileprivate var refrenceScale:CGFloat = 0.0
    fileprivate var pickBtn:UIButton?
    
    convenience init(frame: CGRect, image: UIImage, mode: ImageCropMode, hanlder:((UIImage) -> ())?) {
        self.init(frame: frame)
        self.frame = frame
        sourceImage = image
        cropMode = mode
        completion = hanlder
        setup()
        createUI()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setup() {
        if sourceImage == nil {
            sourceImage = UIImage.init()
        }
        backgroundColor = .black
    }
    private func createUI() {
        
        let cropWidth  = frame.size.width
        let cropHeight = frame.size.width / cropMode
        let imgw = sourceImage!.size.width
        let imgh = sourceImage!.size.height

        scroll.delegate = self
        addSubview(scroll)
        scroll.showsHorizontalScrollIndicator = false
    
        
        let coverHeihgt = (frame.size.height - cropHeight) / 2
        
        let upper = UIView.init(frame: .init(x: 0, y: 0, width: frame.size.width, height: coverHeihgt - 1))
        upper.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
        addSubview(upper)
        upper.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(coverHeihgt - 1)
        }
        
        scroll.addSubview(imv)
        imv.image = sourceImage
        imv.contentMode = .scaleAspectFill

        var showH:CGFloat = 0
        var showW:CGFloat = 0
        var minScale :CGFloat = 1.0
        if imgw / imgh > cropWidth / cropHeight {
            minScale = cropHeight / imgh
            showH = cropHeight
            showW = imgw * minScale
        } else {
            minScale = cropWidth / imgw
            showW = cropWidth
            showH = imgh * minScale
        }
        scroll.minimumZoomScale = minScale
        scroll.zoomScale = minScale;
        imv.frame = .init(x: 0, y: 0, width: showW, height: showH)
        
        var tmpH:CGFloat = 0
        var tmpW:CGFloat = 0
        if showH > cropHeight {
            tmpH = (showH - cropHeight)/2
        }
        if showW > cropWidth {
            tmpW = (showW - cropWidth) / 2
        }
        scroll.frame = .init(x: 0, y: coverHeihgt, width: cropWidth, height: cropHeight)
        scroll.contentSize = .init(width: showW, height: showH)
        scroll.contentOffset = .init(x: tmpW, y: tmpH)
        
        let bottom = UIView.init(frame: .init(x: 0, y: frame.size.height - coverHeihgt + 1, width: frame.size.width, height: coverHeihgt))
        bottom.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
        addSubview(bottom)
        bottom.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(coverHeihgt - 1)
        }
        
        weak var wkself = self
        let titles = ["取消", "选取"]
        for i in 0 ..< titles.count {
            let name = titles[i]
            var f = CGRect.init(x: 20, y: frame.size.height - 60, width: 50, height: 40)
            if i == 1 {
                f = CGRect.init(x: frame.size.width - 70, y: frame.size.height - 60, width: 50, height: 40)
            }
            let btn = UIButton.init(frame: f)
            btn.setTitle(name, for: .normal)
            btn.setTitleColor(.white, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            btn.addTarget(wkself, action: #selector(crop(_:)), for: .touchUpInside)
            addSubview(btn)
            if(i == 1) {
                pickBtn = btn
            }
        }
    }
}
//MARK: -
//MARK: Crop
extension ImageCropView {
    @objc fileprivate func crop(_ sender:UIButton) {
        if sender.currentTitle == "取消" {
            removeFromSuperview()
            return
        }
        var bigCGImage = sourceImage!.cgImage
        if bigCGImage == nil {
            guard let ciImage = sourceImage?.ciImage else {
                //裁剪图片失败
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.removeFromSuperview()
                })
                return
            }
            bigCGImage = CIContext.init().createCGImage(ciImage, from: ciImage.extent)
        }
        guard bigCGImage != nil else {
            //裁剪图片失败
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.removeFromSuperview()
            })
            return
        }
        let from = scroll.convert(scroll.bounds, to: imv)
        guard let cropedCGImage = bigCGImage!.cropping(to: from) else {
            //裁剪图片失败
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.removeFromSuperview()
            })
            return
        }
        let croperedImage = UIImage.init(cgImage: cropedCGImage)
        if completion != nil {
            completion?(croperedImage)
        }
        removeFromSuperview()
    }
}
extension ImageCropView {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imv
    }
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        if(pickBtn!.isEnabled) {
            pickBtn?.isEnabled = false
            pickBtn?.setTitleColor(.gray, for: .normal)
        }
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if(!pickBtn!.isEnabled) {
            pickBtn?.isEnabled = true
            pickBtn?.setTitleColor(.white, for: .normal)
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if(pickBtn!.isEnabled) {
            pickBtn?.isEnabled = false
            pickBtn?.setTitleColor(.gray, for: .normal)
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(!pickBtn!.isEnabled) {
            pickBtn?.isEnabled = true
            pickBtn?.setTitleColor(.white, for: .normal)
        }
    }
}
