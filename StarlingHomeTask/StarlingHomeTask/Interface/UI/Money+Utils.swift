//
//  Money+Description.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 09/06/2023.
//

import Foundation

extension Money {
    private enum Constants {
        // for most FIAT we can assume this
        static let currencyMultiplier = 100
    }
    private static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()

    var decimalMajorUnits: Decimal {
        Decimal(minorUnits) / 100
    }

    static func +(lhs: Money, rhs: Money) -> Money {
        guard lhs.currency == rhs.currency else {
            fatalError("Cannot add money with different currencies.")
        }

        let totalMinorUnits = lhs.minorUnits + rhs.minorUnits

        return Money(currency: lhs.currency, minorUnits: totalMinorUnits)
    }

    func localizedDescription(direction: FeedItem.Direction = .receive) -> String {
        let valueWithDirection: Decimal
        switch direction {
        case .receive:
            valueWithDirection = decimalMajorUnits
        case .out:
            valueWithDirection = -decimalMajorUnits
        }
        if #available(iOS 15.0, *) {
            return valueWithDirection.formatted(.currency(code: currency))
        } else {
            Self.currencyFormatter.currencyCode = currency
            return Self.currencyFormatter.string(from: NSDecimalNumber(decimal: valueWithDirection)) ?? "-"
        }
    }

    func roundUpMoney(scale: Int16 = 0) -> Money {
        let roundingBehavior = NSDecimalNumberHandler(
            roundingMode: .up,
            scale: scale,
            raiseOnExactness: false,
            raiseOnOverflow: false,
            raiseOnUnderflow: false,
            raiseOnDivideByZero: false
        )
        let roundedAmount = NSDecimalNumber(decimal: decimalMajorUnits).rounding(accordingToBehavior: roundingBehavior).decimalValue
        let difference = (roundedAmount - decimalMajorUnits) * Decimal(Constants.currencyMultiplier)

        return Money(
            currency: currency,
            minorUnits: NSDecimalNumber(decimal: difference).intValue
        )
    }
}
