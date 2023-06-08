//
//  URL+Sample.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 08/06/2023.
//

import Foundation

extension URL {
    static func sample(_ string: String = "https://example.com") -> URL {
        URL(string: string)!
    }
}
