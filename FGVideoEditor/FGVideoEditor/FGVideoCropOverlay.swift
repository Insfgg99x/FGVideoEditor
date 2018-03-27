//
//  FGVideoCropOverlay.swift
//  SkateMoments
//
//  Created by xia on 2018/3/26.
//  Copyright © 2018年 xgf. All rights reserved.
//

import UIKit

public enum FGSlideDirection {
    case left
    case right
}

class FGVideoCropOverlay: UIView {
    private var leftSilder = UIView.init()
    private var rightSlider = UIView.init()
    private var maxwidth:CGFloat = 50
    private var minxpos:CGFloat  = 0
    private var maxxpos:CGFloat  = 0
    private var leftCorvery = UIView.init()
    private var rightCorvery = UIView.init()
    private var indicatorView = UIView.init()
    var minWidth:CGFloat = 50
    var slidingBeginHandler:(() -> ())?
    var slidingHandler:((FGSlideDirection) -> ())?
    var slidingEndHandler:(() -> ())?
    var indicatorXpos:CGFloat = 0 {
        didSet {
            updateIndcatorXposition()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2.0
        maxwidth = frame.size.width
        minxpos = frame.origin.x
        maxxpos = frame.origin.x + frame.size.width
        
        createUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func createUI() {
        addSubview(indicatorView)
        indicatorView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.left)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(10)
        }
 
        let indicator = UIView.init()
        indicator.backgroundColor = .white
        indicator.alpha = 0.5
        indicatorView.addSubview(indicator)
        indicator.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(2)
        }
        
        
        let leftView = UIView.init()
        leftView.backgroundColor = .white
        leftSilder.addSubview(leftView)
        for i in 0 ..< 2 {
            let line = UIView.init()
            line.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            leftView.addSubview(line)
            line.snp.makeConstraints({ (make) in
                make.left.equalToSuperview().offset(2 + 4*i)
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize.init(width: 1, height: 5))
            })
        }
        leftSilder.addSubview(leftView)
        leftView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(10)
        }
        addSubview(leftSilder)
        leftSilder.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(20)
        }
        let panLeft = UIPanGestureRecognizer.init(target: self, action: #selector(slideLeftAction(_:)))
        leftSilder.addGestureRecognizer(panLeft)
        
        let rightView = UIView.init()
        rightView.backgroundColor = .white
        rightSlider.addSubview(rightView)
        for i in 0 ..< 2 {
            let line = UIView.init()
            line.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
            rightView.addSubview(line)
            line.snp.makeConstraints({ (make) in
                make.left.equalToSuperview().offset(2 + 4*i)
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize.init(width: 1, height: 5))
            })
        }
        rightSlider.addSubview(rightView)
        rightView.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(10)
        }
        addSubview(rightSlider)
        rightSlider.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(20)
        }
        let panRight = UIPanGestureRecognizer.init(target: self, action: #selector(slideRightAction(_:)))
        rightSlider.addGestureRecognizer(panRight)
    }
}
extension FGVideoCropOverlay {
    private func resetIndicator() {
        indicatorView.snp.updateConstraints { (make) in
            make.centerX.equalTo(self.snp.left)
        }
    }
    private func updateIndcatorXposition() {
        indicatorView.snp.updateConstraints { (make) in
            make.centerX.equalTo(self.snp.left).offset(self.indicatorXpos)
        }
    }
}
//MARK: - Slide
extension FGVideoCropOverlay {
    @objc private func slideLeftAction(_ sender:UIPanGestureRecognizer) {
        let transation = sender.translation(in: sender.view)
        sender.setTranslation(.zero, in: sender.view)
        var width = frame.size.width
        guard width <= maxwidth else {
            return
        }
        var xpos = frame.origin.x
        guard xpos >= minxpos else {
            return
        }
        var offset = transation.x
        if width <= minWidth && offset > 0 {
            return
        }
        if sender.state == .began {
            if slidingBeginHandler != nil {
                slidingBeginHandler?()
            }
            indicatorView.isHidden = true
        }
        if (width - offset) < minWidth {
            offset = width - minWidth
        }
        xpos += offset
        if xpos < minxpos {
            xpos = minxpos
        }
        width -= offset
        if width > maxwidth {
            width = maxwidth
        }
        frame = .init(x: xpos, y: frame.origin.y, width: width, height: frame.size.height)
        if slidingHandler != nil {
            slidingHandler?(.right)
        }
        if sender.state == .ended {
            if slidingEndHandler != nil {
                slidingEndHandler?()
            }
            resetIndicator()
            indicatorView.isHidden = false
        }
    }
    @objc private func slideRightAction(_ sender:UIPanGestureRecognizer) {
        let transation = sender.translation(in: sender.view)
        sender.setTranslation(.zero, in: sender.view)
        var width = frame.size.width
        guard width <= maxwidth else {
            return
        }
        let xpos = frame.origin.x
        guard xpos <= maxxpos else {
            return
        }
        var offset = transation.x
        if width <= minWidth && offset < 0 {
            return
        }
        if sender.state == .began {
            if slidingBeginHandler != nil {
                slidingBeginHandler?()
            }
            indicatorView.isHidden = true
        }
        if (width + offset) < minWidth {
            offset = width - minWidth
        }
        width += offset
        if width > maxwidth {
            width = maxwidth
        }
        frame = .init(x: xpos, y: frame.origin.y, width: width, height: frame.size.height)
        if slidingHandler != nil {
            slidingHandler?(.left)
        }
        if sender.state == .ended {
            if slidingEndHandler != nil {
                slidingEndHandler?()
            }
            resetIndicator()
            indicatorView.isHidden = false
        }
    }
}
