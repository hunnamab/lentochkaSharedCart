//
//  CatalogButton.swift
//  lentochkaSharedCart
//
//  Created by Tatiana Karpukova on 28.10.2020.
//

import UIKit

class CatalogButton: UIButton {
    
    enum ButtonState {
        case add
        case remove
    }
    
    var currentState: ButtonState
    let title: String!

    override init(frame: CGRect) {
        self.currentState = .add
        self.title = ""
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(currentState: ButtonState, title: String) {
        self.currentState = currentState
        self.title = title
        super.init(frame: .zero)
        
        setUp()
    }
    
    private func setUp() {
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        switch currentState {
        case .add:
            backgroundColor = .systemGreen
        case .remove:
            backgroundColor = .systemRed
        }
    }
    

}
