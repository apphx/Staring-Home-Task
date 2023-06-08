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
    private var notificationCenter: NotificationCenter!
    private var sut: AuthorizationMiddleware!

    override func setUp() {
        notificationCenter = .default
        service = .init()
        sut = .init(
            service: service,
            notificationCenter: notificationCenter
        )
    }

    override func tearDown() {
        notificationCenter = nil
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

    func testValidate_whenResponseStatusCodeIs403_itThrowsUnauthorizedError() {
        let response = HTTPURLResponse.sample(statusCode: 403)

        XCTAssertThrowsError(try sut.validate(response: response)) { error in
            XCTAssertEqual(error as NSError, AuthorizationMiddleware.Error.unauthorized as NSError)
        }
    }

    func testValidate_whenResponseStatusCodeIs403_itEmitsUnauthorizedNotification() {
        let response = HTTPURLResponse.sample(statusCode: 403)
        let expectation = XCTestExpectation()

        notificationCenter.addObserver(forName: .unauthorizedRequest, object: nil, queue: nil) { _ in
            expectation.fulfill()
        }

        try? sut.validate(response: response)

        wait(for: [expectation], timeout: 1)
    }

    func testValidate_whenResponseStatusCodeIs403_otherSubscribersGetTriggered() {
        let response = HTTPURLResponse.sample(statusCode: 403)
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 2

        let listeners = [
            AuthorizationMiddleware(service: service, notificationCenter: notificationCenter),
            AuthorizationMiddleware(service: service, notificationCenter: notificationCenter)
        ]

        listeners.forEach { middleware in
            middleware.subscribeUnauthorizedRequestIdentified {
                expectation.fulfill()
            }
        }

        try? sut.validate(response: response)

        wait(for: [expectation], timeout: 1)
    }
}
