//
//  CatalogButton.swift
//  lentochkaSharedCart
//
//  Created by Tatiana Karpukova on 28.10.2020.
//

import UIKit

class CatalogButton: UIButton {
    
    enum ButtonSize {
        case small
        case large
    }
    
    enum ButtonState {
        case add(ButtonSize)
        case remove(ButtonSize)
    }
    
    var currentState: ButtonState
    var title: String

    override init(frame: CGRect) {
        self.currentState   = .add(.small)
        self.title          = ""
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(currentState: ButtonState, title: String) {
        self.currentState   = currentState
        self.title          = title
        super.init(frame: .zero)
        setUp()
    }
    
//    func toggleState() {
//        switch currentState {
//        case .add(let size):
//            currentState = .remove(size)
//            title = (size == .small) ? "-" : "Удалить"
//        case .remove(let size):
//            currentState = .add(size)
//            title = (size == .small) ? "+" : "Добавить"
//        }
//        setUp()
//    }
    
    private func setUp() {
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        var fontSize: CGFloat = 0
        switch currentState {
        case .add(let size):
            fontSize = (size == .small) ? 16 : 24
            backgroundColor = .systemGreen
        case .remove(let size):
            fontSize = (size == .small) ? 16 : 24
            backgroundColor = .systemOrange
        }
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
    }

}
