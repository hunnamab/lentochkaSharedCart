//
//  CatalogVM.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 29.10.2020.
//

import Foundation

class CatalogVM {
    
    var extendedCatalogItems: [CatalogItemModel]
    var catalogItems: [CatalogItemCellModel]
    
    init(extendedCatalogItems: [CatalogItemModel], catalogItems: [CatalogItemCellModel]) {
        self.extendedCatalogItems = extendedCatalogItems
        self.catalogItems = catalogItems
    }
    
    func parseJSON() {
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
        createCatalogItemViewModels()
    }
    
    func createCatalogItemViewModels() {
        for item in extendedCatalogItems {
            guard let imageUrl = URL(string: item.imageSmallURL) else { return }
            let imageData = try! Data(contentsOf: imageUrl)
            let name = item.name.components(separatedBy: "   ")[0]
            let catalogItem = CatalogItemCellModel(
                name: name,
                price: item.goodsUnitList[0].price,
                image: imageData,
                unitName: item.goodsUnitList[0].unitName,
                id: item.id
            )
            self.catalogItems.append(catalogItem)
        }
    }
    
}
