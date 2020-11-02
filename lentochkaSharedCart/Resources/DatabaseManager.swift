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
    // пока непонятно, нужна ли нам все же эта функция
    /// Добавляет нового юзера в базу данных Firebase
    public func addUser(with user: User) {
        
        let email = user.login + "@mail.ru"
        database.child(user.login).setValue([
            "login":user.login,
        ])
        
    }
}

extension DatabaseManager {
    
    /// Добавляет новую позицию товара в корзину
    public func addItemInCart(with item: CatalogItemCellModel, to login: String, cart: String) {
        database.child(login).child(cart).child(item.id).setValue([
            "name"                  : item.name,
            "price"                 : item.price,
            "image"                 : item.image,
            "unitName"              : item.unitName,
            "id"                    : item.id,
            "personalCartQuantity"  : item.personalCartQuantity,
            "sharedCartQuantity"    : item.sharedCartQuantity
        ])
        print("ADDED \(item.name)")
        
    }
    
    /// Удаляет позицию из корзины
    public func removeItemFromCart(with item: CatalogItemCellModel, from login: String, cart: String) {
        
        if cart == "sharedCart" {
            if item.sharedCartQuantity < 1 {
                database.child(login).child(cart).child(item.id).removeValue()
            } else {
                addItemInCart(with: item, to: login, cart: cart)
            }
        } else if cart == "personalCart" {
            if item.personalCartQuantity < 1 {
                database.child(login).child(cart).child(item.id).removeValue()
            } else {
                addItemInCart(with: item, to: login, cart: cart)
            }
        }
        
        print("REMOVED \(item.name)")
    }
    
}

extension DatabaseManager {
    
    /// Добавляет нового человека в корзину
    public func addFriendToCart(friend: User, to login: String) {
        database.child(login).child("group").child(friend.login).setValue(friend.login)
        print("ADDED FRIENDS")
    }
    
    /// Удаляет человека из корзины
    public func removeFriendFromCart(friend: User, from login: String) {
        database.child(login).child("group").child(friend.login).removeValue()
        print("REMOVED FRIEND")
    }
    
    /// Получение данных какого-либо юзера из базы
    public func fetchUserData(login: String, completion: @escaping (User?) -> Void) {
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
