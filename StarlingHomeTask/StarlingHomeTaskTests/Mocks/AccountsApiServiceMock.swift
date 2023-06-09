//
//  AccountsApiServiceMock.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 09/06/2023.
//

@testable import StarlingHomeTask
import Foundation

final class AccountsApiServiceMock: AccountsApiServiceProtocol {
    private(set) var getAccountsCount = 0
    var getAccountsResult: Result<[StarlingHomeTask.Account]>!
    func getAccounts(
        completion: @escaping (StarlingHomeTask.Result<[StarlingHomeTask.Account]>) -> Void
    ) {
        getAccountsCount += 1
        completion(getAccountsResult)
    }
}
