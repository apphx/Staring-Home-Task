//
//  HomeViewModel.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 08/06/2023.
//

import Foundation

final class HomeViewModel {
    enum Action: Equatable {
        case didTapAccount(Account)
    }
    private let accountsService: AccountsApiServiceProtocol
    private let authorizationService: AuthorizationServiceProtocol
    private let onAction: (Action) -> Void

    private(set) var cells = [Cell.Model]()
    let title = "Accounts"

    var onReload: (() -> Void)?

    init(
        accountsService: AccountsApiServiceProtocol,
        authorizationService: AuthorizationServiceProtocol,
        onAction: @escaping (Action) -> Void
    ) {
        self.accountsService = accountsService
        self.authorizationService = authorizationService
        self.onAction = onAction
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
        accounts.map { account in
            Cell.Model(
                title: .init(text: account.name),
                subtitle: .init(text: "Currency: \(account.currency)")
            ) { [weak self] in
                self?.onAction(.didTapAccount(account))
            }
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
