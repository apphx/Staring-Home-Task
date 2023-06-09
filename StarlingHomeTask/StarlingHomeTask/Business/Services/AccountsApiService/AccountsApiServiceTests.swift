//
//  AccountsApiServiceTests.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 09/06/2023.
//

@testable import StarlingHomeTask
import XCTest

final class AccountsApiServiceTests: XCTestCase {
    private var network: NetworkingClientMock<AccountsResponse>!
    private var sut: AccountsApiService!


    override func setUp() {
        network = .init()
        sut = .init(network: network)
    }

    override func tearDown() {
        network = nil
        sut = nil
    }

    func testGetAccounts_whenApiServiceReturnsSuccess_itReturnsAccountsFromResponse() {
        let response = AccountsResponse(accounts: [.sample()])

        network.response = .success(response)

        sut.getAccounts { result in
            XCTAssertEqual(result, .success(response.accounts.map { $0 }))
        }
    }

    func testGetAccounts_whenApiServiceReturnsError_itReturnsError() {
        network.response = .failure(TestError.test)

        sut.getAccounts { result in
            XCTAssertEqual(result, .failure(TestError.test))
        }
    }
}
