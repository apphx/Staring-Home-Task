//
//  Result+Utils.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 08/06/2023.
//

import Foundation

public typealias Result<Success> = Swift.Result<Success, Error>

public extension Swift.Result where Success == Void {
    static var success: Swift.Result<Success, Failure> {
        return .success(())
    }
}
