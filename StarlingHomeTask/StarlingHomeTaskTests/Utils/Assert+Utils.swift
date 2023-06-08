//
//  Assert+Utils.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 08/06/2023.
//

@testable import StarlingHomeTask
import Foundation
import XCTest

func XCTAssertEqual<T: Equatable>(_ lhs: Result<T>, _ rhs: Result<T>) {
    switch (lhs, rhs) {
    case let (.success(valL), .success(valR)):
        XCTAssertEqual(valL, valR)
    case let (.failure(errL), .failure(errR)):
        XCTAssertEqual(errL as NSError, errR as NSError)
    default:
        XCTFail()
    }
}

func XCTAssertEqual(_ lhs: Result<Void>, _ rhs: Result<Void>) {
    switch (lhs, rhs) {
    case (.success, .success):
        break
    case let (.failure(errL), .failure(errR)):
        XCTAssertEqual(errL as NSError, errR as NSError)
    default:
        XCTFail()
    }
}
