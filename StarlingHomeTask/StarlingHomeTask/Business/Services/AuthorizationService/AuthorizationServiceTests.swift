//
//  AuthorizationServiceTests.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 08/06/2023.
//

@testable import StarlingHomeTask
import XCTest

final class AuthorizationServiceTests: XCTestCase {
    private var keychain: KeychainMock!
    private var sut: AuthorizationService!

    override func setUp() {
        keychain = .init()
        sut = .init(keychain: keychain)
    }

    override func tearDown() {
        keychain = nil
        sut = nil
    }

    func testUpdateAuthorizationToken_whenKeychainWriteSucceeds_itReturnsSuccess() throws {
        let randomString = UUID().uuidString
        let randomStringData = try XCTUnwrap(randomString.data(using: .utf8))
        keychain.writeResult = .success

        let updateResult = sut.updateAuthorizationToken(randomString)

        XCTAssertEqual(updateResult, .success)
        XCTAssertEqual(keychain.writeKey, ["AuthorizationToken"])
        XCTAssertEqual(keychain.writeData, [randomStringData])
    }

    func testUpdateAuthorizationToken_whenKeychainWriteFailure_itReturnsFailure() throws {
        let randomString = UUID().uuidString
        keychain.writeResult = .failure(TestError.test)

        let updateResult = sut.updateAuthorizationToken(randomString)

        XCTAssertEqual(updateResult, .failure(TestError.test))
    }

    func testGetAuthorizationToken_whenKeychainReadSucceedsAndValidStringData_itReturnsString() throws {
        let randomString = UUID().uuidString
        let randomStringData = try XCTUnwrap(randomString.data(using: .utf8))
        keychain.readResult = .success(randomStringData)

        let tokenResult = sut.getAuthorizationToken()

        XCTAssertEqual(tokenResult, .success(randomString))
        XCTAssertEqual(keychain.readKey, ["AuthorizationToken"])
    }

    func testGetAuthorizationToken_whenKeychainReadSucceedsAndNilData_itReturnsNil() throws {
        keychain.readResult = .success(nil)

        let tokenResult = sut.getAuthorizationToken()

        XCTAssertEqual(tokenResult, .success(nil))
    }

    func testGetAuthorizationToken_whenKeychainReadFails_itReturnsFailure() throws {
        keychain.readResult = .failure(TestError.test)

        let tokenResult = sut.getAuthorizationToken()

        XCTAssertEqual(tokenResult, .failure(TestError.test))
    }
}
