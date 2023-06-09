//
//  IgnoreEquatable.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 09/06/2023.
//

import Foundation

@propertyWrapper
struct IgnoreEquatable<T>: Equatable {
    var wrappedValue: T

    static func == (lhs: IgnoreEquatable<T>, rhs: IgnoreEquatable<T>) -> Bool {
        true
    }
}
