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
        authorizationService.subscribeAuthorizationChanged { [weak self] authorized in
            if authorized {
                self?.refresh()
            }
        }
    }

    func refresh() {
        accountsService.getAccounts { result in
            print(result)
            // TODO:
        }
    }
}
