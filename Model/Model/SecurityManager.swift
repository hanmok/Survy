//
//  SecurityManager.swift
//  Model
//
//  Created by Mac mini on 2023/07/10.
//

import Foundation
import Security

struct KeychainService {
    static let serviceName = "com.example.app"
    static let accessTokenKey = "accessToken"
    static let refreshTokenKey = "refreshToken"
}

//public class KeychainManager2 {
//    private init (){}
//    static public let shared = KeychainManager2()
//
//    public func saveAccessToken(_ token: String) {
//        print("saveAccessToken, \(token)")
//        saveToKeychain(service: KeychainService.serviceName, account: KeychainService.accessTokenKey, data: token)
//    }
//
//    public func saveRefreshToken(_ token: String) {
//        print("saveRefreshToken, \(token)")
//        saveToKeychain(service: KeychainService.serviceName, account: KeychainService.refreshTokenKey, data: token)
//        guard let savedRefreshToken = loadRefreshToken() else { fatalError() }
//        print("savedRefreshToken: \(savedRefreshToken)")
//    }
//
//    public func loadAccessToken() -> String? {
//        let accessToken = loadFromKeychain(service: KeychainService.serviceName, account: KeychainService.accessTokenKey)
//        print("loading accessToken \(accessToken)")
//        return accessToken
////        return loadFromKeychain(service: KeychainService.serviceName, account: KeychainService.accessTokenKey)
//    }
//
//    public func loadRefreshToken() -> String? {
//        let refreshToken = loadFromKeychain(service: KeychainService.serviceName, account: KeychainService.refreshTokenKey)
//        print("loading refreshToken \(refreshToken)")
//        return refreshToken
////        return loadFromKeychain(service: KeychainService.serviceName, account: KeychainService.refreshTokenKey)
//    }
//
//    private func saveToKeychain(service: String, account: String, data: String) {
//        if let data = data.data(using: .utf8) {
//            let query: [String: Any] = [
//                kSecClass as String: kSecClassGenericPassword,
//                kSecAttrService as String: service,
//                kSecAttrAccount as String: account,
//                kSecValueData as String: data
//            ]
//
//            let status = SecItemAdd(query as CFDictionary, nil)
//            if status != errSecSuccess {
//                print("Error saving to Keychain: \(status)")
//            }
//        }
//    }
//
//    private func loadFromKeychain(service: String, account: String) -> String? {
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
//}
