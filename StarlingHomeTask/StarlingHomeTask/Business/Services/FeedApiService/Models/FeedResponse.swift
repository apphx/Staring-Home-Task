//
//  FeedResponse.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 09/06/2023.
//

import Foundation

struct FeedResponse: Decodable {
    let feedItems: [FeedItem]
}
