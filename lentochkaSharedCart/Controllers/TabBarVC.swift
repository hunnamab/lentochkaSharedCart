//
//  TabBarVC.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 30.10.2020.
//

import UIKit
import FirebaseAuth

protocol CreateUser: AnyObject {
    func setNewUser(_ user: User)
}

class TabBarVC: UITabBarController {
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        validateAuth()
    }
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let rootVC = LoginVC()
            rootVC.modalPresentationStyle = .fullScreen
            rootVC.delegate = self
            present(rootVC, animated: false)
        } else {
            showLoadingVC()
            DatabaseManager.shared.fetchUserData { [weak self] user in
                guard let self = self, let user = user else { return }
                self.user = user
                self.presentTabBar()
            }
        }
    }
    
    private func showLoadingVC() {
        let loadingVC                       = UIViewController()
        loadingVC.view.backgroundColor      = .white
        loadingVC.modalPresentationStyle    = .fullScreen
        
        let activityIndicator               = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingVC.view.addSubview(activityIndicator)
        
        let transfrom                       = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        activityIndicator.transform         = transfrom
        activityIndicator.color             = UIColor(named: "MainColor")
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: loadingVC.view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: loadingVC.view.centerXAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 300),
            activityIndicator.heightAnchor.constraint(equalToConstant: 300)
        ])
        activityIndicator.startAnimating()
        self.viewControllers = [loadingVC]
    }
    
    func presentTabBar() {
        guard let user = user else { return }
        
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
        UITabBar.appearance().tintColor = UIColor(named: "MainColor")
    }
    
}

extension TabBarVC: CreateUser {
    func setNewUser(_ user: User) {
        self.user = user
        presentTabBar()
    }
}
