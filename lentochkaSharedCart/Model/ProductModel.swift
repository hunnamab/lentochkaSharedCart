//
//  ProductModel.swift
//  lentochkaSharedCart
//
//  Created by Tatiana Karpukova on 28.10.2020.
//

import Foundation

struct ProductModel {
    let imageURL: String
    let imagePreviewURL: String
    let id: String
    let isAllowHomeDelivery: Bool
    let defaultCategoryName: String?
    let count, manufacturer, bruttoWeight: String
    let imageSmallURL, imageHighURL: String
    let name: String
    let imageBigURL: String
    let images: [Image]
    let goodsUnitList: [GoodsUnitList]
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "ImageUrl"
        case imagePreviewURL = "ImagePreviewUrl"
        case count = "Count"
        case manufacturer = "Manufacturer"
        case bruttoWeight = "BruttoWeight"
        case id = "Id"
        case isAllowHomeDelivery = "IsAllowHomeDelivery"
        case imageSmallURL = "ImageSmallUrl"
        case imageHighURL = "ImageHighUrl"
        case name = "Name"
        case imageBigURL = "ImageBigUrl"
        case images = "Images"
        case goodsUnitList = "GoodsUnitList"
    }
}

// MARK: - GoodsUnitList
struct GoodsUnitList: Codable {
    let unitName: String
    let price: Double

    enum CodingKeys: String, CodingKey {
        case unitName = "UnitName"
        case price = "Price"
    }
}

// MARK: - Image
struct Image: Codable {
    let resampleURL: String
    let smallURL, bigURL: String

    enum CodingKeys: String, CodingKey {
        case resampleURL = "ResampleUrl"
        case smallURL = "SmallUrl"
        case bigURL = "BigUrl"
    }
}
