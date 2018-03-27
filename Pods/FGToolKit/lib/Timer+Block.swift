//
//  Timer+Block.swift
//  Fate
//
//  Created by xgf on 2017/11/2.
//  Copyright © 2017年 sencent. All rights reserved.
//

import Foundation

private var TimerBlockActionKey = "TimerBlockActionKey"

public extension Timer {
    //iOS 10以下的也可以用block的timer了
    class func fg_scheduledTimer(interval:TimeInterval,repeats:Bool,block:((_ t:Timer)->Void)) -> Timer {
        let timer=Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(fg_timerAction(_:)), userInfo: nil, repeats: repeats)
        objc_setAssociatedObject(self, &TimerBlockActionKey, block, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        return timer
    }
    @objc private class func fg_timerAction(_ sender:Timer){
        let block:((_ t:Timer)->Void)?=objc_getAssociatedObject(self, &TimerBlockActionKey) as? ((Timer) -> Void)
        guard block != nil else {
            return
        }
        block!(sender)
    }
}
