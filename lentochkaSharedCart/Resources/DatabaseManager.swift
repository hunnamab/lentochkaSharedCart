//
//  DatabaseManager.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 30.10.2020.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth //

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
}

// MARK: - Управление аккаунтом
extension DatabaseManager {
    /// Добавляет нового юзера в базу данных Firebase
    public func addUser(with user: User) {
        
        let email = user.login + "@mail.ru"
        database.child(user.login).setValue([
            "email":email,
        ])
        
    }
    
    /// Добавляет новую позицию товара в корзину
    public func addItemInCart(with itemID: String, to login: String) {
        
        database.child(login).child("cart").child(itemID).setValue(itemID)
        print("ADDED \(itemID)")
    }
    
    /// Удаляет позицию из корзины
    public func removeItemFromCart(with itemID: String, from login: String) {
        
        database.child(login).child("cart").child(itemID).removeValue()
        print("REMOVED \(itemID)")
    }
    
    public func addFriendToCart() {
        
    }
    
    public func fetchUserData(completion: @escaping (User?) -> Void) {
        let currentUser = FirebaseAuth.Auth.auth().currentUser
        let login = String(currentUser?.email?.split(separator: "@")[0] ?? "") // мб по uid делать?
        var user: User? = nil
        database.child(login).observeSingleEvent(of: .value) { snapshot in
            let value = snapshot.value as? NSDictionary
            let login = value?["email"] as? String ?? ""
            let cart = value?["cart"] as? [CatalogItemCellModel] ?? []
            let group = value?["cart"] as? [User] ?? []
            user = User(login: login, cart: cart, group: group)
            completion(user)
        }
    }
}
