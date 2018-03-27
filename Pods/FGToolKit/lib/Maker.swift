//
//  Maker.swift
//  FriendCircle
//
//  Created by xgf on 2018/1/31.
//  Copyright © 2018年 HuaZhongShiXun. All rights reserved.
//

import UIKit

public class Maker: NSObject {
    //tbview
    open class func makeTableView(style:UITableViewStyle?, delegate:UITableViewDelegate?, dataSource:UITableViewDataSource?, bgcolor:UIColor?) -> UITableView {
        let tbView = UITableView.init(frame: .zero, style: style ?? .plain)
        if delegate != nil {
            tbView.delegate = delegate
        }
        if dataSource != nil {
            tbView.dataSource = dataSource
        }
        if bgcolor != nil {
            tbView.backgroundColor = bgcolor
        }else{
            tbView.backgroundColor = .clear
        }
        if #available(iOS 9.0, *) {
            tbView.cellLayoutMarginsFollowReadableWidth = false
        }
        return tbView
    }
    //lb
    open class func makeLb(text:String?, aligment:NSTextAlignment?, font:UIFont?, textColor:UIColor?, numberOfLines:Int?) -> UILabel {
        let lb = UILabel.init(frame: .zero)
        if text != nil {
            lb.text = text
        }
        if aligment != nil {
            lb.textAlignment = aligment!
        }
        if font != nil {
            lb.font = font!
        }
        if textColor == nil {
            lb.textColor = .black
        } else {
            lb.textColor = textColor
        }
        if numberOfLines != nil {
            lb.numberOfLines = numberOfLines!
        }
        return lb
    }
    open class func makeBtn(title:String?,
                            textColor:UIColor?,
                            font:UIFont?,
                            bgcolor:UIColor?,
                            target:Any?,
                            action:Selector?) -> UIButton {
        let btn = UIButton.init(frame: .zero)
        if title != nil {
            btn.setTitle(title, for: .normal)
        }
        if font != nil {
            btn.titleLabel?.font = font!
        }
        let c1 = textColor ?? .blue
        btn.setTitleColor(c1, for: .normal)
        let b1 = bgcolor ?? .clear
        btn.backgroundColor = b1
        if target != nil && action != nil {
            btn.addTarget(target, action: action!, for: .touchUpInside)
        }
        return btn
    }
    open class func makeBtn(title:String?,
                            textColor:UIColor?,
                            font:UIFont?,
                            bgcolor:UIColor?,
                            envents:UIControlEvents,
                            handler:((UIControl?) -> ())?) -> UIButton {
        let btn = UIButton.init(frame: .zero)
        if title != nil {
            btn.setTitle(title, for: .normal)
        }
        if font != nil {
            btn.titleLabel?.font = font!
        }
        let c1 = textColor ?? .blue
        btn.setTitleColor(c1, for: .normal)
        let b1 = bgcolor ?? .clear
        btn.backgroundColor = b1
        if handler != nil {
            btn.handleClick(events: envents, click: handler!)
        }
        return btn
    }
    open class func makeBtn(title:String?,
                            textColor:UIColor?,
                            font:UIFont?,
                            bgcolor:UIColor?,
                            handler:((UIControl?) -> ())?) -> UIButton {
        let btn = UIButton.init(frame: .zero)
        if title != nil {
            btn.setTitle(title, for: .normal)
        }
        if font != nil {
            btn.titleLabel?.font = font!
        }
        let c1 = textColor ?? .blue
        btn.setTitleColor(c1, for: .normal)
        let b1 = bgcolor ?? .clear
        btn.backgroundColor = b1
        if handler != nil {
            btn.handleClick(events: .touchUpInside, click: handler!)
        }
        return btn
    }
    open class func makeBtn(img:String?,
                            bgcolor:UIColor?,
                            target:Any?,
                            action:Selector?) -> UIButton {
        let btn = UIButton.init(frame: .zero)
        if img != nil {
            btn.setImage(UIImage.init(named: img!), for: .normal)
        }
        let b1 = bgcolor ?? .clear
        btn.backgroundColor = b1
        if target != nil && action != nil {
            btn.addTarget(target, action: action!, for: .touchUpInside)
        }
        return btn
    }
    open class func makeBtn(img:String?,
                            target:Any?,
                            action:Selector?) -> UIButton {
        let btn = UIButton.init(frame: .zero)
        if img != nil {
            btn.setImage(UIImage.init(named: img!), for: .normal)
        }
        if target != nil && action != nil {
            btn.addTarget(target, action: action!, for: .touchUpInside)
        }
        return btn
    }
    open class func makeBtn(img:String?,
                            bgcolor:UIColor?,
                            envents:UIControlEvents,
                            handler:((UIControl?) -> ())?) -> UIButton {
        let btn = UIButton.init(frame: .zero)
        if img != nil {
            btn.setImage(UIImage.init(named: img!), for: .normal)
        }
        let b1 = bgcolor ?? .clear
        btn.backgroundColor = b1
        if handler != nil {
            btn.handleClick(events: envents, click: handler!)
        }
        return btn
    }
    open class func makeBtn(img:String?,
                            bgcolor:UIColor?,
                            handler:((UIControl?) -> ())?) -> UIButton {
        let btn = UIButton.init(frame: .zero)
        if img != nil {
            btn.setImage(UIImage.init(named: img!), for: .normal)
        }
        let b1 = bgcolor ?? .clear
        btn.backgroundColor = b1
        if handler != nil {
            btn.handleClick(events: .touchUpInside, click: handler!)
        }
        return btn
    }
    open class func makeBtn(img:String?,
                            handler:((UIControl?) -> ())?) -> UIButton {
        let btn = UIButton.init(frame: .zero)
        if img != nil {
            btn.setImage(UIImage.init(named: img!), for: .normal)
        }
        if handler != nil {
            btn.handleClick(events: .touchUpInside, click: handler!)
        }
        return btn
    }
    open class func makeTextField(delegate:UITextFieldDelegate?, font:UIFont?,textColor:UIColor?,placeHolder:String?,text:String?,leftView:UIView?,rightView:UIView?,keyboard:UIKeyboardType?,returnType:UIReturnKeyType?) -> UITextField {
        let tf = UITextField.init()
        tf.delegate = delegate
        tf.font = font
        tf.textColor = textColor
        tf.placeholder = placeHolder
        tf.text = text
        tf.leftView = leftView
        tf.leftViewMode = .always
        tf.rightView = rightView
        tf.rightViewMode = .always
        if keyboard != nil {
            tf.keyboardType = keyboard!
        }
        if returnType != nil {
            tf.returnKeyType = returnType!
        }
        return tf
    }
    open class func makeTextField(font:UIFont?,textColor:UIColor?,placeHolder:String?,text:String?,keyboard:UIKeyboardType?) -> UITextField {
        let tf = UITextField.init()
        tf.font = font
        tf.textColor = textColor
        tf.placeholder = placeHolder
        tf.text = text
        tf.leftViewMode = .always
        tf.rightViewMode = .always
        if keyboard != nil {
            tf.keyboardType = keyboard!
        }
        
        let accessory = UIView.init(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 26))
        let btn = Maker.makeBtn(img: "hidekeyboard", handler: { (sender) in
            tf.resignFirstResponder()
        })
        accessory.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(accessory)
            make.right.equalTo(accessory).offset(-10)
            make.size.equalTo(CGSize.init(width: 34, height: 26))
        }
        tf.inputAccessoryView = accessory
        
        return tf
    }
    
    open class func makeAttributeText(prefix:(String,[NSAttributedStringKey: Any]?), suffix:(String,[NSAttributedStringKey: Any]?)) -> NSAttributedString {
        let attributeText = NSMutableAttributedString.init()
        let p1 = NSAttributedString.init(string: prefix.0, attributes: prefix.1)
        attributeText.append(p1)
        let p2 = NSAttributedString.init(string: suffix.0, attributes: suffix.1)
        attributeText.append(p2)
        return attributeText
    }
    open class func makeAttributeText(prefix:(String,[NSAttributedStringKey: Any]?), mid:(String,[NSAttributedStringKey: Any]?), suffix:(String,[NSAttributedStringKey: Any]?)) -> NSAttributedString {
        let attributeText = NSMutableAttributedString.init()
        let p1 = NSAttributedString.init(string: prefix.0, attributes: prefix.1)
        attributeText.append(p1)
        let p2 = NSAttributedString.init(string: mid.0, attributes: mid.1)
        attributeText.append(p2)
        let p3 = NSAttributedString.init(string: suffix.0, attributes: suffix.1)
        attributeText.append(p3)
        return attributeText
    }
}
