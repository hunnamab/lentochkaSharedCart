//
//  FriendCell.swift
//  lentochkaSharedCart
//
//  Created by Анастасия on 28.10.2020.
//

import UIKit

class FriendCell: UITableViewCell {
    
    static let reuseID = "FriendCell"
    
    func setUp(forUser user: User, andFriend friend: String) {
        if user.groupHost == friend {
            let hostImageView = UIImageView(image: UIImage(named: "Host"))
            hostImageView.image = hostImageView.image?.withRenderingMode(.alwaysTemplate)
            hostImageView.tintColor = UIColor(named: "MainColor")
            accessoryView = hostImageView
        } else {
            accessoryView = .none
        }
        textLabel?.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        textLabel?.textColor = UIColor(named: "MainColor") ?? .blue
    }
    
}
