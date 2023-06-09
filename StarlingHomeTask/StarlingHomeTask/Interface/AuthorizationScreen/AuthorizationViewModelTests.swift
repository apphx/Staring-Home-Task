//
//  AuthorizationViewModelTests.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 09/06/2023.
//

@testable import StarlingHomeTask
import XCTest

final class AuthorizationViewModelTests: XCTestCase {
    private var authorizationService: AuthorizationServiceMock!
    private var sut: AuthorizationViewModel!

    override func setUp() {
        authorizationService = .init()
        sut = .init(authorizationService: authorizationService)
    }

    func testConfirmButton_returnsExpectedModel() {
        let model = sut.confirmButton

        XCTAssertEqual(model, .init(title: "Confirm", titleColor: .blue, onTap: {}))
    }

    func textTextField_returnsExpectedModel() {
        let model = sut.textField

        XCTAssertEqual(model, .init(placeholder: "Authorization token..."))
    }

    func testWHenConfirmButtonIsPressed_authorizationServiceTokenIsUpdatedWithTextFieldValue() {
        let randomString = UUID().uuidString
        sut.textField.text = randomString
        authorizationService.updateAuthorizationTokenResult = .success

        sut.confirmButton.onTap()

        XCTAssertEqual(authorizationService.updateAuthorizationTokenToken, [randomString])
    }
}
