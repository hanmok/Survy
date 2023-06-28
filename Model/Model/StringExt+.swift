//
//  StringExt+.swift
//  Model
//
//  Created by Mac mini on 2023/06/22.
//

import Foundation

extension String {
    public static let optionPlaceholder = "옵션"
    public static let longerPlaceholder = "질문을 입력해주세요."
    
    public static func generateShortUUID() -> String {
        let uuid = UUID()
        let uuidString = uuid.uuidString
        let shortUUID = String(uuidString.prefix(10))
        return shortUUID
    }
}

