//
//  PersonFollowingTableViewCellViewModel.swift
//  Survy
//
//  Created by Mac mini on 2023/05/18.
//

import UIKit

class PersonFollowingTableViewCellViewModel {
    let name: String
    let username: String
    var currentlyFollowing: Bool
    let image: UIImage?
    var model: Person
    
    init(with model: Person) {
        self.model = model
        name = model.name
        username = model.username
//        currentlyFollowing = false
        currentlyFollowing = model.currentlyFollowing
        image = UIImage(systemName: "person")
    }
    
    func updateFollowing() {
        model.currentlyFollowing = !model.currentlyFollowing
    }
    
    
}
