//
//  CatalogVM.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 29.10.2020.
//

import Foundation

class CatalogVM {
    var catalogItems: [CatalogItemCellModel]
    let user: User
    
    init(catalogItems: [CatalogItemCellModel], forUser user: User) {
        self.catalogItems = catalogItems
        self.user = user
    }
    
    func parseJSON() {
        var extendedCatalogItems = [CatalogItemModel]()
        if let path = Bundle.main.path(forResource: "bakery", ofType: "json")
        {
            let pathUrl = URL(fileURLWithPath: path)
            do {
                let data = try! Data(contentsOf: pathUrl)
                let decoder = JSONDecoder()
                extendedCatalogItems = try decoder.decode([CatalogItemModel].self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
        createCatalogItemViewModels(fromItems: extendedCatalogItems)
    }
    
    func createCatalogItemViewModels(fromItems extendedCatalogItems: [CatalogItemModel]) {
        for item in extendedCatalogItems {
            let fullName = item.name.components(separatedBy: "   ")
            let name = fullName[0]
            let weight = fullName[1]
            let catalogItem = CatalogItemCellModel(
                name: name,
                price: item.goodsUnitList[0].price,
                weight: weight,
                image: item.imageSmallURL,
                bigImage: item.imageHighURL,
                unitName: item.goodsUnitList[0].unitName,
                id: item.id
            )
            self.catalogItems.append(catalogItem)
            setQuantity(forItems: catalogItems) //
        }
    }
    
    private func setQuantity(forItems items: [CatalogItemCellModel]) {
        for item in items {
            for personalItem in user.personalCart {
                if item.id == personalItem.id {
                    item.personalCartQuantity = personalItem.personalCartQuantity
                }
            }
            guard user.sharedCart[user.login] != nil else { continue }
            for sharedItem in user.sharedCart[user.login]! {
                if item.id == sharedItem.id {
                    item.sharedCartQuantity = sharedItem.sharedCartQuantity
                }
            }
        }
    }
    
}
