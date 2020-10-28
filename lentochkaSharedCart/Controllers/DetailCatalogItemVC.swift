//
//  DetailCatalogItemVC.swift
//  lentochkaSharedCart
//
//  Created by Tatiana Karpukova on 28.10.2020.
//

import UIKit

class DetailCatalogItemVC: UIViewController {
    
    let itemImageView = UIImageView()
    let itemNameLabel = UILabel()
    let itemPriceLabel = UILabel()
    let button = UIButton()
    
    init(withItem: CatalogItemModel) {
        super.init(nibName: .none, bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemPink
    }
}
