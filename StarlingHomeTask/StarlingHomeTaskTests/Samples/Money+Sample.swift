//
//  Money+Sample.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 11/06/2023.
//

@testable import StarlingHomeTask

extension Money {
    static func eur(minorUnits: Int = 100_00) -> Money {
        .init(
            currency: "EUR",
            minorUnits: minorUnits
        )
    }
}
