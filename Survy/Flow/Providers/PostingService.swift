//
//  PostingServiceType.swift
//  Survy
//
//  Created by Mac mini on 2023/05/16.
//

import Foundation
import Model

protocol PostingServiceType: AnyObject {
    var selectedTargets: [Target] { get set }
    var selectedTags: [Tag] { get set }
    
    func setTargets(_ targets: [Target])
    func setTags(_ tags: [Tag])
}

class PostingService: PostingServiceType {
    var selectedTargets: [Target] = []
    var selectedTags: [Tag] = []
    
    func setTargets(_ targets: [Target]) {
        selectedTargets = targets.sorted()
    }
    
    func setTags(_ tags: [Tag]) {
        selectedTags = tags.sorted()
    }
}
