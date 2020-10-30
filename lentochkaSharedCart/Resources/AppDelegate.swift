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
        
        FirebaseApp.configure()
        
        UINavigationBar.appearance().tintColor = .purple // для вкладки "Люди"
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarVC = TabBarVC()
        tabBarVC.modalPresentationStyle = .fullScreen
        window.rootViewController = tabBarVC
        self.window = window
        self.window?.makeKeyAndVisible()
        return true
    }

}

