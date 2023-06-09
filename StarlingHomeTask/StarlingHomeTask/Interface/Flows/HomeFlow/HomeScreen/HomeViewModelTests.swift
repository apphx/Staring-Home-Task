//
//  HomeViewModelTests.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 09/06/2023.
//

@testable import StarlingHomeTask
import XCTest

final class HomeViewModelTests: XCTestCase {
    private var accountsService: AccountsApiServiceMock!
    private var authorizaitonService: AuthorizationServiceMock!
    private var onReloadCount: Int!
    private var onAction: [HomeViewModel.Action]!
    private var sut: HomeViewModel!

    override func setUp() {
        accountsService = .init()
        authorizaitonService = .init()
        onReloadCount = 0
        onAction = []

        sut = .init(
            accountsService: accountsService,
            authorizationService: authorizaitonService
        ) { [weak self] action in
            self?.onAction.append(action)
        }
        sut.onReload = { [weak self] in
            self?.onReloadCount += 1
        }
    }

    override func tearDown() {
        accountsService = nil
        authorizaitonService = nil
        onReloadCount = nil
        sut = nil
    }

    func testOnViewDidLoad_itRefreshesAccounts() {
        accountsService.getAccountsResult = .success([])

        sut.viewDidLoad()

        XCTAssertEqual(accountsService.getAccountsCount, 1)
        XCTAssertEqual(onReloadCount, 1)
    }

    func testDataSource_whenFetchSucceeds_itDisplaysAllReceievedAccounts() {
        let accounts: [Account] = [
            .sample(),
            .sample(
                accountUid: UUID().uuidString,
                accountType: .additional,
                currency: UUID().uuidString,
                name: UUID().uuidString
            )
        ]
        accountsService.getAccountsResult = .success(accounts)

        sut.viewDidLoad()

        XCTAssertEqual(onReloadCount, 1)
        XCTAssertEqual(sut.numberOfRows(in: 0), 2)

        let expectedModels = accounts.map {
            Cell.Model(
                title: .init(text: $0.name),
                subtitle: .init(text: "Currency: \($0.currency)")
            )
        }
        let cellModels = (0...1).map {
            sut.model(at: .init(row: $0, section: 0))
        }
        XCTAssertEqual(cellModels, expectedModels)
    }

    func testDataSource_whenAnAccountIsTapped_itRequestsCorrectAction() {
        let accounts: [Account] = [
            .sample(),
            .sample(
                accountUid: UUID().uuidString,
                accountType: .additional,
                currency: UUID().uuidString,
                name: UUID().uuidString
            )
        ]
        accountsService.getAccountsResult = .success(accounts)

        sut.viewDidLoad()
        (0...1).forEach {
            sut.model(at: .init(row: $0, section: 0)).onTap?()
        }

        let expectedActions = accounts.map { HomeViewModel.Action.didTapAccount($0) }
        XCTAssertEqual(onAction, expectedActions)
    }

    func testDataSource_whenAuthorizationChangesAndSuccessfull_itRefreshesAccounts() {
        accountsService.getAccountsResult = .success([])

        sut.viewDidLoad()
        authorizaitonService.subscribeAuthorizationChangedClosures.last?(true)

        XCTAssertEqual(accountsService.getAccountsCount, 2)
        XCTAssertEqual(onReloadCount, 2)
    }

    func testDataSource_whenAuthorizationChangesAndFailed_itDoesNotRefreshAccounts() {
        accountsService.getAccountsResult = .success([])

        sut.viewDidLoad()
        authorizaitonService.subscribeAuthorizationChangedClosures.last?(false)

        XCTAssertEqual(accountsService.getAccountsCount, 1)
        XCTAssertEqual(onReloadCount, 1)
    }
}
