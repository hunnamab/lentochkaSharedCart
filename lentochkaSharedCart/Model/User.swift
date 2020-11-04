//
//  User.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 28.10.2020.
//

import Foundation

class User: Equatable {
    var login: String
    var personalCart: [CatalogItemCellModel]
    var sharedCart: [String: [CatalogItemCellModel]] //[CatalogItemCellModel]
    var group: [User]
    var groupHost: String
    
    init(login: String, personalCart: [CatalogItemCellModel], sharedCart: [String: [CatalogItemCellModel]], group: [User], groupHost: String) {
        self.login = login
        self.personalCart = personalCart
        self.sharedCart = sharedCart
        self.group = group
        self.groupHost = groupHost
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.login == rhs.login
    }
}
