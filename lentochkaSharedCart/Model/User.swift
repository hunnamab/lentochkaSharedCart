//
//  User.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 28.10.2020.
//

import Foundation

struct User {
    var login: String
    var cart: [CatalogItemCellModel]? // пока сделала опциональным
    var group: [User]? // same
}
