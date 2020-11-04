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
    
    private var hostRef: DatabaseReference?
    
}

// MARK: - Управление аккаунтом
extension DatabaseManager {
    /// установление хоста и ссылки на него от других юзеров
    public func addHost(login: String, to user: String) {
        database.child(user).child("groupHost").setValue(login)
    }
}

extension DatabaseManager {
    
    /// Добавляет новую позицию товара в корзину
    public func addItemInCart(with item: CatalogItemCellModel, to user: User, cart: String) {
        let value: [String: Any] = [
            "name"                  : item.name,
            "price"                 : item.price,
            "weight"                : item.weight,
            "image"                 : item.image,
            "bigImage"              : item.bigImage,
            "unitName"              : item.unitName,
            "id"                    : item.id,
            "personalCartQuantity"  : item.personalCartQuantity,
            "sharedCartQuantity"    : item.sharedCartQuantity
        ]
        if cart == "sharedCart" { // сделать enum
            database.child(user.groupHost).child(cart).child(user.login).child(item.id).setValue(value)
        } else {
            database.child(user.login).child(cart).child(item.id).setValue(value)
        }
        
        
//        database.child(login).child(cart).child(item.id).setValue([
//            "name"                  : item.name,
//            "price"                 : item.price,
//            "weight"                : item.weight,
//            "image"                 : item.image,
//            "bigImage"              : item.bigImage,
//            "unitName"              : item.unitName,
//            "id"                    : item.id,
//            "personalCartQuantity"  : item.personalCartQuantity,
//            "sharedCartQuantity"    : item.sharedCartQuantity
//        ])
        print("ADDED \(item.name)")
    }
    
    /// Удаляет позицию из корзины
    public func removeItemFromCart(with item: CatalogItemCellModel, from user: User, cart: String) {
        if cart == "sharedCart" {
            if item.sharedCartQuantity < 1 {
                database.child(user.groupHost).child(cart).child(user.login).child(item.id).removeValue()
            } else {
                addItemInCart(with: item, to: user, cart: cart)
            }
        } else if cart == "personalCart" {
            if item.personalCartQuantity < 1 {
                database.child(user.login).child(cart).child(item.id).removeValue()
            } else {
                addItemInCart(with: item, to: user, cart: cart)
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
        database.child(friend.groupHost).child("sharedCart").child(friend.login).removeValue()
        database.child(login).child("group").child(friend.login).removeValue()
        database.child(friend.login).child("groupHost").removeValue()
        print("REMOVED FRIEND")
    }
    
    /// Получение данных какого-либо юзера из базы
    public func fetchUserData(login: String, completion: @escaping (User?) -> Void) {
        var user: User? = nil
        database.child(login).observeSingleEvent(of: .value) { snapshot in
            
            let value               = snapshot.value as? NSDictionary
            let login               = value?["login"] as? String ?? ""
            let personalCart        = value?["personalCart"] as? [String: Any] ?? [:]
            var personalCartItems   = [CatalogItemCellModel]()
            
            for (_, cartItem) in personalCart {
                guard let item = cartItem as? [String: Any] else { return }
                let newItem = CatalogItemCellModel(
                    name:                   item["name"] as! String,
                    price:                  item["price"] as! Double,
                    weight:                 item["weight"] as! String,
                    image:                  item["image"] as! String,
                    bigImage:               item["bigImage"] as! String,
                    unitName:               item["unitName"] as! String,
                    id:                     item["id"] as! String,
                    personalCartQuantity:   item["personalCartQuantity"] as! Int,
                    sharedCartQuantity:     item["sharedCartQuantity"] as! Int
                )
                personalCartItems.append(newItem)
            }
            
            let sharedCart      = value?["sharedCart"] as? [String: Any] ?? [:]
            var sharedCartItems = [CatalogItemCellModel]()
            print(sharedCart)
            for (_, cartItem) in sharedCart {
//                guard let item = cartItem as? [String: Any] else { return }
//                let newItem = CatalogItemCellModel(
//                    name:                   item["name"] as! String,
//                    price:                  item["price"] as! Double,
//                    weight:                 item["weight"] as! String,
//                    image:                  item["image"] as! String,
//                    bigImage:               item["bigImage"] as! String,
//                    unitName:               item["unitName"] as! String,
//                    id:                     item["id"] as! String,
//                    personalCartQuantity:   item["personalCartQuantity"] as! Int,
//                    sharedCartQuantity:     item["sharedCartQuantity"] as! Int
//                )
//                sharedCartItems.append(newItem)
//                print(cartItem)
            }
            
            let groupHost   = value?["groupHost"] as? String ?? ""
            self.fetchGroup(login: login, groupHost: groupHost) { group in
                user = User(login: login,
                            personalCart: personalCartItems,
                            sharedCart: sharedCartItems,
                            group: group, groupHost: groupHost)
                completion(user)
            }
        }
    }
    
    private func fetchGroup(login: String, groupHost: String, completion: @escaping ([User]) -> Void) {
        var group = [User]()
        if groupHost.isEmpty {
            completion(group)
            return
        }
        self.database.child(groupHost).child("group").observeSingleEvent(of: .value) { snapshot in
            let users = snapshot.value as? [String: String] ?? [:]
            for (_, user) in users {
                let user = User(login: user, personalCart: [], sharedCart: [], group: [], groupHost: groupHost)
                group.append(user)
            }
            completion(group)
        }
    }
    
}
