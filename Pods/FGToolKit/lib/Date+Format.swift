//
//  Date+Format.swift
//  Fate
//
//  Created by xgf on 2017/11/9.
//  Copyright © 2017年 xgf. All rights reserved.
//

import Foundation

private let hour_seconds:TimeInterval =  3600
private let year_hours:Int = 8760
private let week_hours:Int = 168
private let day_hours:Int = 24

private var DateFormatedTimeKey = "DateFormatedTimeKey"

public extension Date {
    var formatedTime:String? {
        get {
            var time=objc_getAssociatedObject(self, &DateFormatedTimeKey) as? String
            if time == nil {
                time=getTime()
                objc_setAssociatedObject(self, &DateFormatedTimeKey, time, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            return time
        }
    }
    private func getTime() -> String? {
        let fmt=DateFormatter.init()
        fmt.dateFormat="YYYY-MM-dd"
        let now=fmt.string(from: Date())
        var components=DateComponents.init()
        let array=now.components(separatedBy: "-")
        let day = Int(array.last!)
        let month=Int(array[1])
        let year=Int(array.first!)
        components.day=day
        components.year=year
        components.month=month
        let calendar=NSCalendar.init(calendarIdentifier: .gregorian)
        let today=calendar?.date(from: components)//今天 0点时间
        let hour = Int(self.timeIntervalSince(today!)/hour_seconds)
        
        let newFormat=DateFormatter.init()
        let flag=DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)
        //hasAMPM==TURE为12小时制，否则为24小时制
        let range:NSRange=(flag! as NSString).range(of: "a")
        var hasAM=false
        if range.location != NSNotFound {
            hasAM=true
        }
        if hour>year_hours || hour < -year_hours{//消息时间大于1年
            newFormat.dateFormat="YYYY-MM-dd HH:mm"
        }else if hour>week_hours || hour < -week_hours {//消息大于1周
            newFormat.dateFormat="MM-dd HH:mm"
        }else if hour>day_hours || (hour < -day_hours && hour > -week_hours) {//消息超过1天、小于1周
            let weekComponents=calendar?.components([.weekday], from: self)
            let weekRawvalue=weekComponents?.weekday
            let week=weekWithValue(weekRawvalue)
            newFormat.dateFormat=String.init(format: "%@ HH:mm", week!)
        }else if hour<0 && hour>day_hours {//昨天
            newFormat.dateFormat = "昨天HH:mm"
        }else{//今天
            if !hasAM {//24小时制
                newFormat.dateFormat="HH:mm"
            }else{//12小时制
                if hour > 0 && hour < 6 {
                    newFormat.dateFormat = "凌晨hh:mm"
                }else if hour > 6 && hour < 12{
                    newFormat.dateFormat = "上午hh:mm"
                }else if hour > 12 && hour < 18 {
                    newFormat.dateFormat = "下午hh:mm"
                }else{
                    newFormat.dateFormat = "晚上hh:mm"
                }
            }
        }
        let time=newFormat.string(from: self)
        return time
    }
    private func weekWithValue(_ weekValue:Int?) -> String! {
        if weekValue == nil {
            return ""
        }
        var week = ""
        switch weekValue! {
        case 1:
            week = "星期日"
            break
        case 2:
            week = "星期一"
            break
        case 3:
            week = "星期二"
            break
        case 4:
            week = "星期三"
            break
        case 5:
            week = "星期四"
            break
        case 6:
            week = "星期五"
            break
        case 7:
            week = "星期六"
            break
        default:
            break
        }
        return week
    }
}
