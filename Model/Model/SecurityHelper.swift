////
////  SecurityHelper.swift
////  Model
////
////  Created by Mac mini on 2023/07/10.
////
//
//import Foundation
//import Security
//
//public class SecurityHelper {
//
//    // Keychain에 값을 저장하는 함수
//    public let shared = SecurityHelper()
//    public init() {}
//    // service: App 을 식별.
//    // 앱 내에서 데이터를 식별.
//
//
//     public func saveToKeychain(service: String, account: String, password: String) {
//        if let passwordData = password.data(using: .utf8) {
//            let query: [String: Any] = [
//                kSecClass as String: kSecClassGenericPassword,
//                kSecAttrService as String: service,
//                kSecAttrAccount as String: account,
//                kSecValueData as String: passwordData
//            ]
//
//            let status = SecItemAdd(query as CFDictionary, nil)
//            if status != errSecSuccess {
//                print("Error saving to Keychain: \(status)")
//            }
//        }
//    }
//
//    // Keychain에서 값을 불러오는 함수
//     public func loadFromKeychain(service: String, account: String) -> String? {
//        let query: [String: Any] = [
//            kSecClass as String: kSecClassGenericPassword,
//            kSecAttrService as String: service,
//            kSecAttrAccount as String: account,
//            kSecReturnData as String: true,
//            kSecMatchLimit as String: kSecMatchLimitOne
//        ]
//
//        var result: AnyObject?
//        let status = SecItemCopyMatching(query as CFDictionary, &result)
//        if status == errSecSuccess, let data = result as? Data, let password = String(data: data, encoding: .utf8) {
//            return password
//        } else {
//            print("Error loading from Keychain: \(status)")
//            return nil
//        }
//    }
//
//    static public func testCode() {
//        // Keychain에 값을 저장
//        let service = "com.example.app"
//        let account = "user123"
//        let password = "password123"
//        saveToKeychain(service: service, account: account, password: password)
//
//        // Keychain에서 값을 불러옴
//        if let loadedPassword = loadFromKeychain(service: service, account: account) {
//            print("Loaded password: \(loadedPassword)")
//        }
//    }
//}
//
//
//
//
//
//
