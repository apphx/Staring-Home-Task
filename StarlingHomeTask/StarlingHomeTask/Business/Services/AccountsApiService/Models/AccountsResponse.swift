//
//  AccountsResponse.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 08/06/2023.
//

import Foundation

// arguably decoding these can be tested as well; e.g. a sample json is introduced into the testing target
// and it's used to ensure decoding + conversion to domain model (in this case) happens as expected
struct AccountsResponse: Decodable, Hashable {
    let accounts: [Account]
}
