//
//  RoundUpViewModel.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 09/06/2023.
//

import Foundation

final class RoundUpViewModel {
    private let account: Account
    private let screenInteractor: RoundUpScreenInteractorProtocol
    private let onCompletion: () -> Void
    private var idempotencyKey: String = ""
    private var lastRoundUp: Money?

    private(set) var cells = [Cell.Model]()
    private(set) lazy var roundUpButton = makeRoundUpButton()
    var title: String { "\(account.name) - \(account.currency)" }

    var onReload: (() -> Void)?

    init(
        account: Account,
        screenInteractor: RoundUpScreenInteractorProtocol,
        onCompletion: @escaping () -> Void
    ) {
        self.account = account
        self.screenInteractor = screenInteractor
        self.onCompletion = onCompletion
    }

    func viewDidLoad() {
        refresh()
    }
}

// MARK: - DataSource

extension RoundUpViewModel {
    func numberOfRows(in section: Int) -> Int {
        cells.count
    }

    func model(at indexPath: IndexPath) -> Cell.Model {
        cells[indexPath.row]
    }
}

// MARK: - Behaviour

private extension RoundUpViewModel {
    func makeRoundUpButton() -> Button.Model {
        Button.Model(
            title: "Round up: \(lastRoundUp?.localizedDescription() ?? "-")",
            titleColor: .white,
            backgroundColor: .blue
        ) { [weak self] in
            self?.roundUp()
        }
    }

    func makeFeedItemsModels(for feedItems: [FeedItem]) -> [Cell.Model] {
        feedItems.map { feedItem in
            Cell.Model(
                title: .init(
                    text: [
                        feedItem.amount.localizedDescription(direction: feedItem.direction),
                        feedItem.amount.roundUpMoney().localizedDescription()
                    ].joined(separator: " -> Round up: ")
                ),
                subtitle: .init(text: feedItem.reference, textColor: .lightGray)
            )
        }
    }

    func makeEmptyCells() -> [Cell.Model] {
        [
            .init(title: .init(text: "Looks like there are no valid transactions 🤷"))
        ]
    }

    func reloadWithContent(feedItems: [FeedItem]) {
        if feedItems.isEmpty {
            lastRoundUp = nil
            cells = makeEmptyCells()
        } else {
            lastRoundUp = feedItems.reduce(.init(currency: account.currency, minorUnits: 0)) { partialResult, feedItem in
                partialResult + feedItem.amount.roundUpMoney()
            }
            cells = makeFeedItemsModels(for: feedItems)
        }
        onReload?()
    }

    func refresh() {
        screenInteractor.fetchSettledOutoingTransactionsSinceLastWeek(
            referenceDate: Date(), // causes flackyness; further improvement to have this injected
            accountId: account.accountUid
        ) { [weak self] result in
            switch result {
            case let .success(feedItems):
                self?.reloadWithContent(feedItems: feedItems.outgoingItems())
                self?.idempotencyKey = UUID().uuidString
                // disable/enable round up button if there are no items
            case let .failure(error):
                print(error)
                // would need proper error state, but for simplicity purposes it will be silenced
            }
        }
    }

    func roundUp() {
        guard let lastRoundUp else { return }
        screenInteractor.roundUp(
            idempotencyKey: idempotencyKey,
            accountId: account.accountUid,
            money: lastRoundUp
        ) { [weak self] result in
            switch result {
            case .success:
                self?.onCompletion()
            case let .failure(error):
                print(error)
                // handle error
            }
        }
    }
}
