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
            "login":user.login,
        ])
        
    }
    
    /// Добавляет новую позицию товара в корзину
    public func addItemInCart(with item: CatalogItemCellModel, to login: String, cart: String) {
        
        database.child(login).child(cart).child(item.id).setValue([
            "name"      : item.name,
            "price"     : item.price,
            "image"     : item.image,
            "unitName"  : item.unitName,
            "id"        : item.id,
            "quantity"  : item.quantity
        ])
        print("ADDED \(item.name)")
        
    }
    
    /// Удаляет позицию из корзины
    public func removeItemFromCart(with item: CatalogItemCellModel, from login: String, cart: String) {
        
        if item.quantity < 1 {
            database.child(login).child(cart).child(item.id).removeValue()
        } else {
            addItemInCart(with: item, to: login, cart: cart)
        }
        print("REMOVED \(item.name)")
    }
    
    public func addFriendToCart(friend: User, to login: String) {
        database.child(login).child("group").child(friend.login).setValue(friend.login)
        print("ADDED FRIENDS")
    }
    
    public func removeFriendFromCart(friend: User, from login: String) {
        
        database.child(login).child("group").child(friend.login).removeValue()
        print("REMOVED FRIEND")
    }
    
    public func fetchUserData(login: String, completion: @escaping (User?) -> Void) {
        //let currentUser = FirebaseAuth.Auth.auth().currentUser
        //let login = String(currentUser?.email?.split(separator: "@")[0] ?? "") // мб по uid делать?
        var user: User? = nil
        database.child(login).observeSingleEvent(of: .value) { snapshot in
            let value           = snapshot.value as? NSDictionary
            let login           = value?["login"] as? String ?? ""
            let personalCart    = value?["personalCart"] as? [CatalogItemCellModel] ?? []
            let sharedCart      = value?["sharedCart"] as? [CatalogItemCellModel] ?? []
            let group           = value?["group"] as? [User] ?? []
            user                = User(login: login,
                                       personalCart: personalCart,
                                       sharedCart: sharedCart,
                                       group: group)
            completion(user)
        }
    }
}
