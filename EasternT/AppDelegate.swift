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
        QBSettings.setApplicationID(47073);
        QBSettings.setAuthKey("mGNGayd52Exxuaq");
        QBSettings.setAuthSecret("HSYJf2fbMrNhUtY");
        QBSettings.setAccountKey("sDNgiKC36vp2hz4J1pep");
        // Override point for customization after application launch.
        return true
    }

}

