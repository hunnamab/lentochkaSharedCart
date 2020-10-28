//
//  LoginVM.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 28.10.2020.
//

import Foundation
import Firebase

class LoginVM {
    var user: User
    
    init(user: User) {
        self.user = user
    }

    func loginUser(login: String, password: String) {
        Auth.auth().signIn(withEmail: login, password: password) { (result, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                print("Successfully logged in")
            }
        }
    }
}
