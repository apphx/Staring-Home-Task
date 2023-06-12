//
//  MoneyUtilsTests.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 12/06/2023.
//

@testable import StarlingHomeTask
import XCTest

final class MoneyTests: XCTestCase {
    func testAddition_sameCurrency_returnsSumOfMinorUnits() {
        let money1 = Money(currency: "USD", minorUnits: 100)
        let money2 = Money(currency: "USD", minorUnits: 200)

        let result = money1 + money2

        XCTAssertEqual(result.currency, "USD")
        XCTAssertEqual(result.minorUnits, 300)
    }

    func testLocalizedDescription_whenReceiveDirection_itFormatsValueWithCurrencySymbol() {
        let money = Money(currency: "USD", minorUnits: 100)

        let description = money.localizedDescription(direction: .receive)

        XCTAssertEqual(description, "$1.00")
    }

    func testLocalizedDescription_whenOutDirection_itFormatsValueWithNegativeSignAndCurrencySymbol() {
        let money = Money(currency: "USD", minorUnits: 100)

        let description = money.localizedDescription(direction: .out)

        XCTAssertEqual(description, "-$1.00")
    }

    func testRoundUpMoney_itRoundsUpToNearestInteger() {
        // more test cases can be appended
        let money = Money(currency: "USD", minorUnits: 101)

        let roundedMoney = money.roundUpMoney()

        XCTAssertEqual(roundedMoney.currency, "USD")
        XCTAssertEqual(roundedMoney.minorUnits, 99)
    }
}
