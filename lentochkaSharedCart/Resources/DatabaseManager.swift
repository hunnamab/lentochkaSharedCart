//
//  DatabaseManager.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 30.10.2020.
//

import Foundation
import FirebaseDatabase

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
}
