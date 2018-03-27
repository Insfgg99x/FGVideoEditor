//
//  FGHUD.swift
//  FGHUD
//
//  Created by xgf on 2018/3/15.
//  Copyright © 2018年 xgf. All rights reserved.
//

import UIKit
import SnapKit

public enum HUDType {
    //show a hud with template
    case loading(String?)
    //show success
    case success(String?)
    //show error
    case error(String?)
    //show warn
    case warning(String?)
    //show given content
    case content(String?)
    //auto dismiss after given time(FGHUDAutoDismisDuration)
    case toast(String?)
}

class FGHUD: UIView {
    class func show(on v: UIView?, type:HUDType) -> FGHUD? {
        guard let view = v else {
            return nil
        }
        let hud = FGHUD.init(frame: .init(x: 0, y: 0, width: 100, height: 100))
        hud.layer.cornerRadius = 10
        hud.backgroundColor = FGHUDTintColor
        
        let contentLb = UILabel.init(frame: .zero)
        contentLb.textColor = .white
        contentLb.textAlignment = .center
        contentLb.font = UIFont.systemFont(ofSize: FGHUDFontSize)
        hud.addSubview(contentLb)
        
        var trimx:CGFloat = 50
        var hudw:CGFloat = 100
        var hudh:CGFloat = 100
        func contentBlock(_ msg: String?) {
            trimx = 40
            contentLb.numberOfLines = 0
            contentLb.text = msg
            contentLb.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalTo(hud).offset(5)
                make.right.equalTo(hud).offset(-5)
                make.height.equalTo(20)
            }
            var w = contentLb.sizeThatFits(.init(width: .greatestFiniteMagnitude, height: FGHUDMinHeight)).width
            if w < FGHUDMinWidth {
                w = FGHUDMinWidth
            } else if w > FGHUDMaxWidth {
                w = FGHUDMaxWidth
            }
            var h = contentLb.sizeThatFits(.init(width: w, height: .greatestFiniteMagnitude)).height
            if h < FGHUDMinHeight {
                h = FGHUDMinHeight
            } else if h > FGHUDMaxHeight {
                h = FGHUDMaxHeight
            }
            hudw = w + 20
            hudh = h
        }
        func fillBlock(_ msg: String?) {
            contentLb.text = msg
            contentLb.snp.makeConstraints { (make) in
                make.bottom.equalTo(hud).offset(-10)
                make.left.equalTo(hud).offset(5)
                make.right.equalTo(hud).offset(-5)
                make.height.equalTo(20)
            }
            var w = contentLb.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: 20)).width
            if w < FGHUDMinWidth {
                w = FGHUDMinWidth
            } else if w > FGHUDMaxWidth {
                w = FGHUDMaxWidth
            }
            hudw = w + 20
            let accessoryView = FGHUDAccessoryView.init(frame: .zero)
            hud.addSubview(accessoryView)
            accessoryView.snp.makeConstraints({ (make) in
                make.edges.equalTo(hud)
            })
            accessoryView.type = type
            DispatchQueue.main.asyncAfter(deadline: .now() + FGHUDAutoDismisDuration) {
                hud.hide()
            }
        }
        switch type {
        case let .loading(msg):
            contentLb.text = msg
            contentLb.snp.makeConstraints { (make) in
                make.bottom.equalTo(hud).offset(-10)
                make.left.equalTo(hud).offset(5)
                make.right.equalTo(hud).offset(-5)
                make.height.equalTo(20)
            }
            let indicator = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
            hud.addSubview(indicator)
            indicator.snp.makeConstraints { (make) in
                make.top.equalTo(hud).offset(20)
                make.centerX.equalTo(hud)
                make.size.equalTo(CGSize.init(width: 30, height: 30))
            }
            indicator.startAnimating()
            break
        case let .success(msg):
            fillBlock(msg)
            break
        case let .error(msg):
            fillBlock(msg)
            break
        case let .warning(msg):
            fillBlock(msg)
            break
        case let .content(msg):
            contentBlock(msg)
            break
        case let .toast(msg):
            contentBlock(msg)
            DispatchQueue.main.asyncAfter(deadline: .now() + FGHUDAutoDismisDuration, execute: {
                hud.hide()
            })
            break
        }
        view.addSubview(hud)
        hud.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize.init(width: hudw, height: hudh))
        }
        hud.alpha = 0.0
        UIView.animate(withDuration: 0.2, animations: {
            hud.alpha = 1.0
        })
        return hud
    }
}
//MARK: -
//MARK: Hide
extension FGHUD {
    class func hide(from:UIView?) {
        guard let view = from else {
            return
        }
        view.subviews.forEach {
            if $0 is FGHUD {
                let hud = $0
                UIView.animate(withDuration: 0.2, animations: {
                    hud.alpha = 0.0
                }, completion: { (_) in
                    hud.removeFromSuperview()
                })
            }
        }
    }
    func hide() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0.0
        }, completion: { (_) in
            self.removeFromSuperview()
        })
    }
    func hideWithoutAnimation() {
        removeFromSuperview()
    }
}
private class FGHUDAccessoryView: UIView {
    fileprivate var type:HUDType? {
        didSet {
            setNeedsDisplay()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        guard let hudType = type else {
            return
        }
        let w = rect.size.width
        let radius:CGFloat = 20
        let topy:CGFloat = 15
        switch hudType {
        case .success:
            let path = UIBezierPath.init()
            path.move(to: .init(x: w/2 + radius, y: topy + radius))
            path.addArc(withCenter: .init(x: w/2, y: topy + radius), radius: radius, startAngle: 0, endAngle: .pi*2, clockwise: true)
            path.move(to: .init(x: w/2 - radius / 2, y: topy + radius))
            path.addLine(to: .init(x: w/2 - radius / 2 + 6, y: topy + radius + 6))
            path.addLine(to: .init(x: w/2 + radius / 2, y: topy + radius  - 6))
            UIColor.white.setStroke()
            path.stroke()
            path.close()
        case .error:
            let path = UIBezierPath.init()
            path.move(to: .init(x: w/2 + radius, y: topy + radius))
            path.addArc(withCenter: .init(x: w/2, y: topy + radius), radius: radius, startAngle: 0, endAngle: .pi*2, clockwise: true)
            let fix:CGFloat = 2
            path.move(to: .init(x: w/2 - radius / 2 + fix, y: topy + radius / 2 + 2))
            path.addLine(to: .init(x: w/2 + radius / 2 - fix, y: topy + radius * 3 / 2 - fix))
            path.move(to: .init(x: w/2 + radius / 2 - fix, y: topy + radius / 2 + fix))
            path.addLine(to: .init(x: w/2 - radius / 2 + fix, y: topy + radius * 3 / 2 - fix))
            UIColor.white.setStroke()
            path.stroke()
            path.close()
        case .warning:
            let path = UIBezierPath.init()
            path.move(to: .init(x: w/2 + radius, y: topy + radius))
            path.addArc(withCenter: .init(x: w/2, y: topy + radius), radius: radius, startAngle: 0, endAngle: .pi*2, clockwise: true)
            path.move(to: .init(x: w/2, y: topy + radius / 2))
            path.addLine(to: .init(x: w / 2, y: topy + radius * 3 / 2 - 2))
            UIColor.white.setStroke()
            path.stroke()
            path.close()
            
            let dotRadius:CGFloat = 1
            let dotPath = UIBezierPath.init()
            dotPath.move(to: .init(x: w / 2, y: topy + radius * 3 / 2))
            dotPath.addArc(withCenter: .init(x: w / 2, y: topy + radius * 3 / 2 + dotRadius), radius: dotRadius, startAngle: 0, endAngle: .pi*2, clockwise: true)
            UIColor.white.setFill()
            dotPath.fill()
            dotPath.close()
        default:
            break
        }
    }
}
//MARK: -
//MARK: UIView
public extension UIView {
    func showHUD() {
        DispatchQueue.main.async {
            if let tmp = objc_getAssociatedObject(self, &FGHUDKey) as? FGHUD {
                tmp.hideWithoutAnimation()
            }
            let hud = FGHUD.show(on: self, type: .loading("请稍候"))
            objc_setAssociatedObject(self, &FGHUDKey, hud, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    func showHUD(_ type:HUDType) {
        DispatchQueue.main.async {
            if let tmp = objc_getAssociatedObject(self, &FGHUDKey) as? FGHUD {
                tmp.hideWithoutAnimation()
            }
            let hud = FGHUD.show(on: self, type: type)
            objc_setAssociatedObject(self, &FGHUDKey, hud, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    func hideHUD() {
        DispatchQueue.main.async {
            if let hud = objc_getAssociatedObject(self, &FGHUDKey) as? FGHUD {
                hud.hide()
            }
        }
    }
}
//MARK: -
//MARK: UIViewController
public extension UIViewController {
    func showHUD() {
        DispatchQueue.main.async {
            if let tmp = objc_getAssociatedObject(self, &FGHUDKey) as? FGHUD {
                tmp.hideWithoutAnimation()
            }
            let hud = FGHUD.show(on: self.view, type: .loading("请稍候"))
            objc_setAssociatedObject(self, &FGHUDKey, hud, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    func showHUD(_ type:HUDType) {
        DispatchQueue.main.async {
            if let tmp = objc_getAssociatedObject(self, &FGHUDKey) as? FGHUD {
                tmp.hideWithoutAnimation()
            }
            let hud = FGHUD.show(on: self.view, type: type)
            objc_setAssociatedObject(self, &FGHUDKey, hud, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    func hideHUD() {
        DispatchQueue.main.async {
            if let hud = objc_getAssociatedObject(self, &FGHUDKey) as? FGHUD {
                hud.hide()
            }
        }
    }
}
