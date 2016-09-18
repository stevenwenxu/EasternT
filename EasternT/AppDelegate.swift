//
//  AppDelegate.swift
//  EasternT
//
//  Created by Steven Xu on 2016-09-16.
//  Copyright © 2016 EasternT. All rights reserved.
//

import UIKit
import Quickblox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        QBSettings.setApplicationID(47106);
        QBSettings.setAuthKey("z3dXyT5UWALMXKb");
        QBSettings.setAuthSecret("kHuTHNwvv8wWkrw");
        QBSettings.setAccountKey("RYqtrqV39eZAnX9uSpvM");
        QBSettings.setKeepAliveInterval(30);
        QBSettings.setAutoReconnectEnabled(true);
        // Override point for customization after application launch.
        return true
    }

}

