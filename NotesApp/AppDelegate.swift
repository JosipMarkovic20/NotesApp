//
//  AppDelegate.swift
//  NotesApp
//
//  Created by Josip Marković on 28/05/2020.
//  Copyright © 2020 Josip Marković. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupUiOptions()
        return true
    }

    func setupUiOptions(){
        self.window = UIWindow()
        self.window?.rootViewController = ViewController()
        self.window?.makeKeyAndVisible()
    }
}

