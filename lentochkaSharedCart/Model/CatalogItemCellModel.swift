//
//  CatalogItemCellModel.swift
//  lentochkaSharedCart
//
//  Created by Tatiana Karpukova on 28.10.2020.
//

import Foundation

struct CatalogItemCellModel {
    let name: String
    let price: Double
    let image: String
    let unitName: String
    let id: String
    var quantity: Int = 0
    
    init(name: String, price: Double, image: String, unitName: String, id: String) {
        self.name = name
        self.price = price
        self.image = image
        self.unitName = unitName
        self.id = id
    }
}
