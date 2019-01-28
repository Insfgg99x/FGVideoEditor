//
//  UITextFiled+ToolBar.swift
//  FGToolKit
//
//  Created by xgf on 2018/8/27.
//  Copyright © 2018年 xgf. All rights reserved.
//

import Foundation
import UIKit

private func createToolBar(_ target : Any?, action : Selector) -> UIToolbar {
    let bar = UIToolbar.init(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40))
    let space = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let btn = UIButton.init(frame: .init(x: 0, y: 0, width: 50, height: 40))
    btn.setTitle("完成", for: .normal)
    btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    btn.setTitleColor(.black, for: .normal)
    btn.addTarget(target, action: action, for: .touchUpInside)
    let done = UIBarButtonItem.init(customView: btn)
    bar.items = [space, done]
    return bar
}

extension UITextField {
    public func enableToolBar() {
        let bar = createToolBar(self, action: #selector(resignKeyboardAction))
        inputAccessoryView = bar
    }
    @objc private func resignKeyboardAction() {
        resignFirstResponder()
    }
}

extension UITextView {
    public func enableToolBar() {
        let bar = createToolBar(self, action: #selector(resignKeyboardAction))
        inputAccessoryView = bar
    }
    @objc private func resignKeyboardAction() {
        resignFirstResponder()
    }
}

extension UISearchBar {
    public func enableToolBar() {
        let bar = createToolBar(self, action: #selector(resignKeyboardAction))
        inputAccessoryView = bar
    }
    @objc private func resignKeyboardAction() {
        resignFirstResponder()
    }
}
