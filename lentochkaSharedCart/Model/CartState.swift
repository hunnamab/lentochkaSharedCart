//
//  CartState.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 03.11.2020.
//

import Foundation

enum CartState: Int {
    case personal
    case shared
    
    mutating func toggle() {
        switch self {
        case .personal:
            self = .shared
        case .shared:
            self = .personal
        }
    }
}
