import Foundation
import Security

public class KeychainManager {
    static public let shared = KeychainManager()

    private let accessTokenKey = "AccessToken"
    private let refreshTokenKey = "RefreshToken"
    private let serviceName = "survy"
    
    // AccessToken 저장
    public func saveAccessToken(_ accessToken: String?) {
        print("accessToken \(accessToken) has been saved")
        saveToKeychain(accessToken, forKey: accessTokenKey)
    }

    // AccessToken 검색
    public func loadAccessToken() -> String? {
        let accessToken = retrieveFromKeychain(forKey: accessTokenKey)
        print("accessToken \(accessToken) has loaded")
        return accessToken
    }

    // RefreshToken 저장
    public func saveRefreshToken(_ refreshToken: String?) {
        print("refreshToken \(refreshToken) has been saved")
        saveToKeychain(refreshToken, forKey: refreshTokenKey)
    }

    // RefreshToken 검색
    public func loadRefreshToken() -> String? {
        let refreshToken = retrieveFromKeychain(forKey: refreshTokenKey)
        print("refreshToken \(refreshToken) has loaded")
        return refreshToken
    }

    // Keychain에 값 저장
    private func saveToKeychain(_ value: String?, forKey key: String) {
        if value == nil {
            let query = [
                kSecClass as String: kSecClassGenericPassword as String,
                kSecAttrService as String: serviceName,
                kSecAttrAccount as String: key,
                kSecValueData as String: nil
            ] as [String: Any?]
            SecItemDelete(query as CFDictionary)
            return
        }
        
        if let value = value {
            if let data = value.data(using: .utf8) {
                let query = [
                    kSecClass as String: kSecClassGenericPassword as String,
                    kSecAttrService as String: serviceName,
                    kSecAttrAccount as String: key,
                    kSecValueData as String: data
                ] as [String: Any]
                
                SecItemDelete(query as CFDictionary)
                
                let status = SecItemAdd(query as CFDictionary, nil)
                if status != errSecSuccess {
                    print("Failed to save \(key) to keychain. Status: \(status)")
                }
            }
        }
    }
    
    

    // Keychain에서 값 검색
    private func retrieveFromKeychain(forKey key: String) -> String? {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ] as [String: Any]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess, let data = result as? Data, let value = String(data: data, encoding: .utf8) {
            return value
        } else {
            return nil
        }
    }
}
