//
//  KeychainClient.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 08/06/2023.
//

import Foundation

protocol KeychainProtocol: AnyObject {
    func write(key: String, data: Data) -> Result<Void>
    func read(key: String) -> Result<Data?>
}

// Based on: https://gist.github.com/kgleong/e8610b9b9106b28d1c721a59c4ea1f5f#file-ios_keychain_store_and_fetch-md
final class Keychain: KeychainProtocol {
    func write(key: String, data: Data) -> Result<Void> {
        let query = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecValueData as String : data
        ] as [String : Any]

        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)

        if status != noErr {
            return .failure(KeychainError.error(osStatus: status))
        }
        return .success
    }

    func read(key: String) -> Result<Data?> {
        let query = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String : true,
            kSecMatchLimit as String : kSecMatchLimitOne
        ] as [String : Any]

        var data: AnyObject?

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &data)

        if status != noErr {
            return .failure(KeychainError.error(osStatus: status))
        }
        return .success(data as? Data)
    }
}
