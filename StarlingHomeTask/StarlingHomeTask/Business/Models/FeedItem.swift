//
//  FeedItem.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 09/06/2023.
//

import Foundation

struct FeedItem: Decodable {
    enum Direction: String, Decodable {
        case receive = "IN"
        case out = "OUT"
    }
    let amount: Money
    let feedItemUid: String
    let reference: String
    let transactionTime: Date
    let direction: Direction
}
