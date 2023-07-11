import Foundation
import Security

public class KeychainManager2 {
    static public let shared = KeychainManager2()

    private let accessTokenKey = "AccessToken"
    private let refreshTokenKey = "RefreshToken"

    // AccessToken 저장
    public func saveAccessToken(_ accessToken: String) {
        saveToKeychain(accessToken, forKey: accessTokenKey)
    }

    // AccessToken 검색
    public func getAccessToken() -> String? {
        return retrieveFromKeychain(forKey: accessTokenKey)
    }

    // RefreshToken 저장
    public func saveRefreshToken(_ refreshToken: String) {
        saveToKeychain(refreshToken, forKey: refreshTokenKey)
    }

    // RefreshToken 검색
    public func getRefreshToken() -> String? {
        return retrieveFromKeychain(forKey: refreshTokenKey)
    }

    // Keychain에 값 저장
    private func saveToKeychain(_ value: String, forKey key: String) {
        if let data = value.data(using: .utf8) {
            let query = [
                kSecClass as String: kSecClassGenericPassword as String,
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

    // Keychain에서 값 검색
    private func retrieveFromKeychain(forKey key: String) -> String? {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
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
