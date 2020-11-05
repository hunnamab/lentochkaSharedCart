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
    
    var user: User?
    
    func setNewUser(_ user: User) {
        self.user = user
    }
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        UINavigationBar.appearance().tintColor = UIColor(named: "MainColor")
        setWindow()
        return true
    }
    
    private func setWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        }
        self.window?.rootViewController = LaunchVC()
        self.window?.makeKeyAndVisible()
    }
}

extension AppDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var rootViewController: LaunchVC {
        return window!.rootViewController as! LaunchVC
    }
}
