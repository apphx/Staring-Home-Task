//
//  AccountsApiService.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 08/06/2023.
//

import Foundation

protocol AccountsApiServiceProtocol: AnyObject {
    func getAccounts(completion: @escaping (Result<[Account]>) -> Void)
}

final class AccountsApiService: AccountsApiServiceProtocol {
    private let network: NetworkingClientProtocol

    init(
        network: NetworkingClientProtocol
    ) {
        self.network = network
    }

    convenience init() {
        self.init(network: NetworkingClient())
    }

    func getAccounts(completion: @escaping (Result<[Account]>) -> Void) {
        network.execute(
            request: .makeWith(path: "/accounts")
        ) { (result: Result<AccountsResponse>) in
            completion(result.map { $0.accounts} )
        }
    }
}
