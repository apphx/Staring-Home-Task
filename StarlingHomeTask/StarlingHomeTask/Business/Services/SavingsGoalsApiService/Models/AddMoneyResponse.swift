//
//  AddMoneyResponse.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 09/06/2023.
//

import Foundation

struct AddMoneyResponse: Decodable, Equatable {
    let transferUid: String
    let success: Bool
}
