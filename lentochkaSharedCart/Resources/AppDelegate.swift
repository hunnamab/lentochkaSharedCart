//
//  AppDelegate.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 26.10.2020.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarVC = TabBarVC()
        tabBarVC.modalPresentationStyle = .fullScreen
        window.rootViewController = tabBarVC
        self.window = window
        self.window?.makeKeyAndVisible()
        return true
    }

}

