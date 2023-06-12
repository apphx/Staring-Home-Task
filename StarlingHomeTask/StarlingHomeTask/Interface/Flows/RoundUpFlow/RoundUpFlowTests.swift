//
//  RoundUpFlowTests.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 12/06/2023.
//


@testable import StarlingHomeTask
import XCTest
import UIKit

final class RoundUpFlowTests: XCTestCase {
    private var navigationController: UINavigationController!
    private var screenFactory: ScreenFactoryMock!
    private var sut: RoundUpFlow!

    override func setUp() {
        navigationController = .init()
        screenFactory = .init()

        sut = .init(
            navigationController: navigationController,
            screenFactory: screenFactory
        )
    }

    override func tearDown() {
        navigationController = nil
        screenFactory = nil
        sut = nil
    }

    func testStart_itPushesRoundUpScreen() {
        let controller = UIViewController()
        screenFactory.makeRoundUpScreenController = controller

        sut.start(account: .sample())

        XCTAssertEqual(screenFactory.makeRoundUpScreenAccounts, [.sample()])
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        // mocking the navigation controller would be useful to test push method parameters
        XCTAssertIdentical(controller, navigationController.viewControllers.first)
    }

    func testCompletionIsCalled_itPopsTheStack() {
        navigationController.setViewControllers([.init()], animated: false)
        screenFactory.makeRoundUpScreenController = .init()

        sut.start(account: .sample())
        screenFactory.makeRoundUpScreenOnCompletionClosures.first?()

        // mocking the navigation controller would be useful to test pop method w/o actual UIKit dependency
        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }
}
