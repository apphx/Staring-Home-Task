//
//  CancellableMock.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 08/06/2023.
//

@testable import StarlingHomeTask
import Foundation

final class CancellableMock: Cancellable {
    private(set) var cancelCount = 0

    func cancel() {
        cancelCount += 1
    }
}
