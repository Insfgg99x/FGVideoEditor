//
//  UIView+Action.swift
//  FGToolKit
//
//  Created by xgf on 2018/1/26.
//  Copyright © 2018年 xgf. All rights reserved.
//

import UIKit
private var UIViewTapActionHandlerKey = "UIViewTapActionHandlerKey"
private var UIViewLongPressActionHandlerKey = "UIViewLongPressActionHandlerKey"

public extension UIView {
    func addTap(handler: @escaping ((UITapGestureRecognizer) -> ())) {
        isUserInteractionEnabled = true
        objc_setAssociatedObject(self, &UIViewTapActionHandlerKey, handler, .OBJC_ASSOCIATION_COPY)
        let tap =  UITapGestureRecognizer.init(target: self, action: #selector(fg_tapAction(_:)))
        addGestureRecognizer(tap)
    }
    @objc private func fg_tapAction(_ sender:UITapGestureRecognizer) {
        guard let handler = objc_getAssociatedObject(self, &UIViewTapActionHandlerKey) as? ((UITapGestureRecognizer) -> ())  else {
            return
        }
        handler(sender)
    }
    func addLongPress(handler: @escaping ((UILongPressGestureRecognizer) -> ())) {
        isUserInteractionEnabled = true
        objc_setAssociatedObject(self, &UIViewLongPressActionHandlerKey, handler, .OBJC_ASSOCIATION_COPY)
        let longPress =  UILongPressGestureRecognizer.init(target: self, action: #selector(fg_longPressAction(_:)))
        addGestureRecognizer(longPress)
    }
    @objc private func fg_longPressAction(_ sender:UITapGestureRecognizer) {
        guard let handler = objc_getAssociatedObject(self, &UIViewLongPressActionHandlerKey) as? ((UITapGestureRecognizer) -> ())  else {
            return
        }
        handler(sender)
    }
}
