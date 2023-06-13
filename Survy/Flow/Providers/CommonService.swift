//
//  CommonService.swift
//  Survy
//
//  Created by Mac mini on 2023/06/13.
//

import Foundation
import Model

protocol CommonServiceType {
    var selectedIndex: Int { get set }
    var allTags: [Tag] { get set }
    
    func setSelectedIndex(_ index: Int)
    func setTags(_ tags: [Tag])
}

class CommonService: CommonServiceType {
    func setTags(_ tags: [Tag]) {
        allTags = tags
    }
    
    var allTags: [Tag] = []
    
    var selectedIndex: Int = 0
    func setSelectedIndex(_ index: Int) {
        selectedIndex = index
    }
}

