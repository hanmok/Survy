//
//  Survey.swift
//  Survy
//
//  Created by Mac mini on 2023/03/31.
//

import Foundation


struct Survey {
    var dateLeft: Int
    var categories: [String]
    var question: String
    var availableOptions: [String]?
    var textFieldPlaceHolder: String?
    var participants: [Int]
    var reward: Int
}
