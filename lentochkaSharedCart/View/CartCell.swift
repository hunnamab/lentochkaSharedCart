//
//  CartCell.swift
//  lentochkaSharedCart
//
//  Created by Tatiana Karpukova on 31.10.2020.
//

import UIKit

class CartCell: UITableViewCell {
    
    enum CellType: String {
        case price = "Итого"
        case weight = "Вес корзины"
    }
    
    static let reuseID = "CartCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: CartCell.reuseID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(cellType: CellType, detailInfo: String) {
        textLabel?.text = cellType.rawValue
        textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        textLabel?.textColor = .darkGray
        
        detailTextLabel?.text = detailInfo
        detailTextLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        detailTextLabel?.textColor = UIColor(red: 0.168627451,
        green: 0.1294117647,
        blue: 0.5764705882,
        alpha: 1)
    }
    
}
