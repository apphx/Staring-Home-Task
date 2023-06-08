//
//  Cancellable.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 08/06/2023.
//

import Foundation

protocol Cancellable: AnyObject {
    func cancel()
}

extension URLSessionTask: Cancellable {}
