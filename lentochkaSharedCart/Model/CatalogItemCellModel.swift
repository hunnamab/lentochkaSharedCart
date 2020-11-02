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
    let weight: String
    let image: String
    let bigImage: String
    let unitName: String
    let id: String
    var personalCartQuantity: Int
    var sharedCartQuantity: Int
    
    init(name: String, price: Double, weight: String, image: String, bigImage: String, unitName: String, id: String, personalCartQuantity: Int = 0, sharedCartQuantity: Int = 0) {
        self.name                 = name
        self.price                = price
        self.weight               = weight
        self.image                = image
        self.bigImage             = bigImage
        self.unitName             = unitName
        self.id                   = id
        self.personalCartQuantity = personalCartQuantity
        self.sharedCartQuantity   = sharedCartQuantity
    }
}
