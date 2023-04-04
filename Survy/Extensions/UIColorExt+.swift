//
//  UIColorExt+.swift
//  Survy
//
//  Created by Mac mini on 2023/03/31.
//

import UIKit

/**
     RGB 16진수 초기화

     RGB 6자리 16진수와 불투명도를 따로 지정하여 생성

     **Example**
     ```
     UIColor(hex6: 0xFFFFFF) // White
     UIColor(hex6: 0xFFFFFF, alpha: 0.2) // White20
     UIColor(hex6: 0x000000) // Black
     ```

     - Parameters:
        - hex6 : RGB값을 16진수로 사용. 각 자리수는 16진수 2자리씩 이용하여 6자리 사용 가능. 0x000000~0xFFFFFF
        - alpha: 불투명도 값. 0.0~1.0 범위에 값을 지정 가능. 기본값은 불투명도 최대값
     */
extension UIColor {
    public convenience init(hex6 color: Int, alpha: CGFloat? = nil) {
        let mask = 0x000000FF
        
        let red = CGFloat(color >> 16 & mask) / 255.0
        let green = CGFloat(color >> 8 & mask) / 255.0
        let blue = CGFloat(color & mask) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha ?? 1)
    }
}

extension UIColor {
    public static let unselectedUpperTabColor = UIColor(hex6: 0x818181)
    static let selectedUpperTabColor = UIColor.black
    static let participantsColor = UIColor(hex6: 0x8F939F)
    static let dividerColor = UIColor(hex6: 0xDCDCDC)
    static let rewardColor = UIColor(hex6: 0xE7574F)
    
//    static let mainColor = UIColor(hex6: 0xE3EDFF)
    static let mainColor = UIColor(hex6: 0xB8D4FF)
    
    static let mainBackgroundColor = UIColor(hex6: 0xECEDF3)
//    static let dateLeft = UIColor(hex6: 0x8F939)
    static let blueTextColor = UIColor(hex6: 0x3255ED)
    
    static let blurredTextColor = UIColor(hex6: 0x777777)
    static let modifyingButtonColor = UIColor(hex6: 0xF2F2F2)
    
    static let separatorViewColor = UIColor(hex6: 0xF0F2F8)
    
    static let unfilledGageColor = UIColor(hex6: 0xF0F2F8)
    
    static let filledGageColor = UIColor(hex6: 0x3255ED)
    
    static let bigSeparatorViewColor = UIColor(hex6: 0xF6F7FD)
    
    static let logoutButtonBackground = UIColor(hex6: 0xF2F2F2)
    static let logoutButtonText = UIColor(hex6: 0xA1A6B8)
}
