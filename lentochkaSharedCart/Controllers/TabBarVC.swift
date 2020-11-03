//
//  TabBarVC.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 30.10.2020.
//

import UIKit
import FirebaseAuth

class TabBarVC: UITabBarController {
    
    let user: User

    init(withUser user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        self.presentTabBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentTabBar() {
        
        print("tab bar \(user.login)")
        
        UITabBar.appearance().tintColor = UIColor(named: "MainColor")
        
        let catalogVC = CatalogVC(withUser: user)
        let navVC = UINavigationController(rootViewController: catalogVC)
        navVC.tabBarItem = UITabBarItem(title: "Каталог",
                                        image: UIImage(named: "Catalog"),
                                        tag: 0)
        
        let friendsVC = FriendsVC(withUser: user)
        let secondNavVC = UINavigationController(rootViewController: friendsVC)
        secondNavVC.tabBarItem = UITabBarItem(title: "Люди",
                                              image: UIImage(named: "Friends"),
                                              tag: 1)
        
        let cartVC = CartVC(style: .grouped, withUser: user)
        let thirdNavVC = UINavigationController(rootViewController: cartVC)
        thirdNavVC.tabBarItem = UITabBarItem(title: "Корзина",
                                             image: UIImage(named: "Cart"),
                                             tag: 2)
        
        let profileVC = ProfileVC(withUser: user)
        let fourthNavVC = UINavigationController(rootViewController: profileVC)
        fourthNavVC.tabBarItem = UITabBarItem(title: "Профиль",
                                              image: UIImage(named: "Profile"),
                                              tag: 3)
        
        self.viewControllers = [navVC, secondNavVC, thirdNavVC, fourthNavVC]
        self.modalPresentationStyle = .fullScreen
    }
    
}
