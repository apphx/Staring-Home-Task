//
//  HomeFlowTests.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 09/06/2023.
//

@testable import StarlingHomeTask
import XCTest
import UIKit

final class HomeFlowTests: XCTestCase {
    private var navigationController: UINavigationController!
    private var screenFactory: ScreenFactoryMock!
    private var flowLauncher: FlowLauncherMock!
    private var sut: HomeFlow!

    override func setUp() {
        // wrapping and mocking the navigation controller would be useful
        // in case of a more complex setup & further isolating tests from UIKit
        navigationController = .init()
        screenFactory = .init()
        flowLauncher = .init()

        sut = .init(
            navigationController: navigationController,
            screenFactory: screenFactory,
            flowLauncher: flowLauncher
        )
    }

    override func tearDown() {
        navigationController = nil
        screenFactory = nil
        flowLauncher = nil
        sut = nil
    }

    func testStart_itSetsRootControllerExpectedController() {
        let controller = UIViewController()
        screenFactory.makeHomeScreenController = controller

        sut.start()

        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertIdentical(controller, navigationController.viewControllers.first)
    }

    func testOnAction_whenDidTapAccountIsCalled_itRunsRoundUpFlow() {
        screenFactory.makeHomeScreenController = .init()

        sut.start()
        screenFactory.makeHomeScreenOnActionClosures.last?(.didTapAccount(.sample()))

        XCTAssertEqual(flowLauncher.runRoundUpFlowCount, 1)
        XCTAssertEqual(flowLauncher.runRoundUpFlowAccounts, [.sample()])
    }
}
