//
//  AppDelegate.swift
//  Badesaba
//
//  Created by Mahdiyar Oraei on 8/27/19.
//  Copyright © 2019 Moj Hamrah. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var language = "fa"

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        UINavigationBar.appearance().semanticContentAttribute = .forceRightToLeft
        
        window = UIWindow()
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
}

