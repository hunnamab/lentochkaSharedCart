//
//  LaunchVC.swift
//  lentochkaSharedCart
//
//  Created by Tatiana Karpukova on 04.11.2020.
//

import UIKit

class LaunchVC: UIViewController {
    
    private var current: UIViewController
    
    init() {
        self.current = SplashVC()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) haddChildd")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParent: self)
    }
    
    func showLoginScreen() {
        let loginVC = LoginVC()
        addChild(loginVC)
        loginVC.view.frame = view.bounds
        view.addSubview(loginVC.view)
        loginVC.didMove(toParent: self)
        current.willMove(toParent: nil)
        current.view.removeFromSuperview()
        current.removeFromParent()
        current = loginVC
    }
    
    func showMainScreen(withUser user: User) {
        let tabBarVC = TabBarVC(withUser: user)
//        addChild(tabBarVC)
//        tabBarVC.view.frame = view.bounds
//        view.addSubview(tabBarVC.view)
//        tabBarVC.didMove(toParent: self)
//        current.willMove(toParent: nil)
        animateFadeTransition(to: tabBarVC)
        current.view.removeFromSuperview()
        current.removeFromParent()
        
        current = tabBarVC
    }
    
    // можно убрать анимацию
    private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        current.willMove(toParent: nil)
        addChild(new)
        
        transition(from: current, to: new, duration: 0.5, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
        }) { completed in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?()
        }
    }

}
