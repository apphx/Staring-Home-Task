//
//  Array+Utils.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 09/06/2023.
//

import Foundation

extension Array where Element == FeedItem {
    func outgoingItems() -> [FeedItem] {
        filter { $0.direction == .out }
    }
}
