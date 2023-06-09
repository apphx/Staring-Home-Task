//
//  Account.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 08/06/2023.
//

import Foundation

struct Account: Decodable, Hashable {
    enum AccountType: String, Decodable {
        case primary = "PRIMARY"
        case additional = "ADDITIONAL"
    }
    let accountUid: String
    let accountType: AccountType
    let defaultCategory: String
    let currency: String
    let createdAt: Date
    let name: String
}
