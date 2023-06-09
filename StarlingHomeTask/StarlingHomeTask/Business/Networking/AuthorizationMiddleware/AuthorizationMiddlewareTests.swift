//
//  AuthorizationMiddlewareTests.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 08/06/2023.
//

@testable import StarlingHomeTask
import XCTest

final class AuthorizationMiddlewareTests: XCTestCase {
    private var service: AuthorizationServiceMock!
    private var sut: AuthorizationMiddleware!

    override func setUp() {
        service = .init()
        sut = .init(
            service: service
        )
    }

    override func tearDown() {
        service = nil
        sut = nil
    }

    func testAuthorizeRequest_whenGetAuthorizationTokenReturnsValue_itAddsTokenToHeader() {
        let randomString = UUID().uuidString
        service.getAuthorizationTokenResult = .success(randomString)

        var request = URLRequest(url: .sample())
        let authorizedRequest = sut.authorizedRequest(from: request)

        request.addValue("Bearer \(randomString)", forHTTPHeaderField: "Authorization")

        XCTAssertEqual(request, authorizedRequest)
        XCTAssertEqual(service.getAuthorizationTokenCount, 1)
    }

    func testAuthorizeRequest_whenGetAuthorizationTokenReturnsNil_returnsUnchangedRequest() {
        service.getAuthorizationTokenResult = .success(nil)

        let request = URLRequest(url: .sample())
        let authorizedRequest = sut.authorizedRequest(from: request)

        XCTAssertEqual(request, authorizedRequest)
    }

    func testAuthorizeRequest_whenGetAuthorizationTokenReturnsFailure_returnsUnchangedRequest() {
        service.getAuthorizationTokenResult = .failure(TestError.test)

        let request = URLRequest(url: .sample())
        let authorizedRequest = sut.authorizedRequest(from: request)

        XCTAssertEqual(request, authorizedRequest)
    }

    func testValidate_whenResponseStatusCodeIs403_itThrowsUnauthorizedErrorAndUpdatesTokenWithEmptyString() {
        let response = HTTPURLResponse.sample(statusCode: 403)

        service.updateAuthorizationTokenResult = .success

        XCTAssertThrowsError(try sut.validate(response: response)) { error in
            XCTAssertEqual(error as NSError, AuthorizationMiddleware.Error.unauthorized as NSError)
        }
        XCTAssertEqual(service.updateAuthorizationTokenToken, [""])

    }
}
