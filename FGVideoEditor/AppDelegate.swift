//
//  AppDelegate.swift
//  FGVideoEditor
//
//  Created by xgf on 2018/3/27.
//  Copyright © 2018年 xgf. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window?.rootViewController = UINavigationController.init(rootViewController: ViewController())
        return true
    }
}

