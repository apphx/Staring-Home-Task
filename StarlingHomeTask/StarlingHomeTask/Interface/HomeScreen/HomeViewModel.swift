//
//  HomeViewModel.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 08/06/2023.
//

import Foundation

final class HomeViewModel {
    private let accountsService: AccountsApiServiceProtocol
    private let authorizationService: AuthorizationServiceProtocol

    private(set) var cells = [Cell.Model]()
    let title = "Accounts"

    var onReload: (() -> Void)?

    init(
        accountsService: AccountsApiServiceProtocol,
        authorizationService: AuthorizationServiceProtocol
    ) {
        self.accountsService = accountsService
        self.authorizationService = authorizationService
    }

    convenience init() {
        self.init(
            accountsService: AccountsApiService(),
            authorizationService: AuthorizationService()
        )
    }

    func viewDidLoad() {
        refresh()
        subscribeAuthorizationChanges()
    }
}

// MARK: - DataSource

extension HomeViewModel {
    func numberOfRows(in section: Int) -> Int {
        cells.count
    }

    func model(at indexPath: IndexPath) -> Cell.Model {
        cells[indexPath.row]
    }
}

// MARK: - Behaviour

private extension HomeViewModel {
    func makeAccountsModels(for accounts: [Account]) -> [Cell.Model] {
        accounts.map {
            Cell.Model(
                title: .init(text: $0.name),
                subtitle: .init(text: "Currency: \($0.currency)")
            )
        }
    }

    func reloadWithContent(accounts: [Account]) {
        cells = makeAccountsModels(for: accounts)
        onReload?()
    }

    func subscribeAuthorizationChanges() {
        authorizationService.subscribeAuthorizationChanged { [weak self] authorized in
            if authorized {
                self?.refresh()
            }
        }
    }

    func refresh() {
        accountsService.getAccounts { [weak self] result in
            switch result {
            case let .success(accounts):
                self?.reloadWithContent(accounts: accounts)
            case let .failure(error):
                print(error)
                // would need proper error state, but for simplicity purposes it will be silenced
            }
        }
    }
}
