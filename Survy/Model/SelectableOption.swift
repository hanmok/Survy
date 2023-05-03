//
//  SelectableOption.swift
//  Survy
//
//  Created by Mac mini on 2023/04/23.
//

import Foundation

struct SelectableOption {
    let id: Int = Int.random(in: 0 ... 10000)
    let questionId: Int
    let position: Int
    var value: String? = nil
    var placeHolder: String? = nil
}
