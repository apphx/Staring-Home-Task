//
//  Money.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 09/06/2023.
//

import Foundation

struct Money: Codable, Hashable {
    let currency: String
    let minorUnits: Int
}
