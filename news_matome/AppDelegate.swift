//
//  AppDelegate.swift
//  news_matome
//
//  Created by Youmaru on 2020/01/18.
//  Copyright © 2020 Youmaru. All rights reserved.
//

import UIKit


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController.init(rootViewController: HomeVC.init())
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = UIColor.init(red: 192/255.0, green: 82/255.0, blue: 139/255.0, alpha: 1)
        UINavigationBar.appearance().isTranslucent = false
        window?.makeKeyAndVisible()
        
        return true
    }
}

