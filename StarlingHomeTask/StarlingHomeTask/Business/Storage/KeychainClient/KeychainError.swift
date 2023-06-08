//
//  KeychainError.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 08/06/2023.
//

import Foundation

enum KeychainError: Error {
    case error(osStatus: OSStatus)
}
