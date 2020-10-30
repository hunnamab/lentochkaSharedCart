//
//  TabBarVC.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 30.10.2020.
//

import UIKit
import FirebaseAuth

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        presentTabBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let rootVC = LoginVC()
            rootVC.modalPresentationStyle = .fullScreen
            present(rootVC, animated: false)
        }
    }
    
    func presentTabBar() {
        let catalogVC = CatalogVC()
        let navVC = UINavigationController(rootViewController: catalogVC)
        navVC.tabBarItem = UITabBarItem(title: "Каталог",
                                        image: UIImage(named: "Catalog"),
                                        tag: 0)
        
        let friendsVC = FriendsVC()
        let secondNavVC = UINavigationController(rootViewController: friendsVC)
        secondNavVC.tabBarItem = UITabBarItem(title: "Люди",
                                        image: UIImage(named: "Friends"),
                                        tag: 1)

        let cartVC = CartVC()
        cartVC.view.backgroundColor = .systemBlue
        cartVC.tabBarItem = UITabBarItem(title: "Корзина",
                                         image: UIImage(named: "Cart"),
                                         tag: 2)

        let profileVC = ProfileVC()
        profileVC.view.backgroundColor = .systemYellow
        profileVC.tabBarItem = UITabBarItem(title: "Профиль",
                                            image: UIImage(named: "Profile"),
                                            tag: 3)

        self.viewControllers = [navVC, secondNavVC, cartVC, profileVC]
        self.modalPresentationStyle = .fullScreen
        UITabBar.appearance().tintColor = UIColor(red: 0.168627451,
                                                  green: 0.1294117647,
                                                  blue: 0.5764705882,
                                                  alpha: 1)
    }

}
