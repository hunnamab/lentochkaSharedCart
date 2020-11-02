//
//  CatalogItemCellModel.swift
//  lentochkaSharedCart
//
//  Created by Tatiana Karpukova on 28.10.2020.
//

import Foundation

class CatalogItemCellModel {
    let name: String
    let price: Double
    let image: String
    let unitName: String
    let id: String
    var personalCartQuantity: Int = 0
    var sharedCartQuantity: Int = 0
    
    init(name: String, price: Double, image: String, unitName: String, id: String) {
        self.name       = name
        self.price      = price
        self.image      = image
        self.unitName   = unitName
        self.id         = id
    }
}
