//
//  User.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 28.10.2020.
//

import Foundation

//class User {
struct User {
    var login: String
    var personalCart: [CatalogItemCellModel]
    var sharedCart: [CatalogItemCellModel]
    var group: [User]
    
//    init(login: String, personalCart: [CatalogItemCellModel], sharedCart: [CatalogItemCellModel], group: [User]) {
//        self.login = login
//        self.personalCart = personalCart
//        self.sharedCart = sharedCart
//        self.group = group
//    }
}
