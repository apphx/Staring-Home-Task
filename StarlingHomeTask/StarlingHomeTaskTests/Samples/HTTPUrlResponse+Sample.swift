//
//  HTTPURLResponse+Sample.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 08/06/2023.
//

import Foundation

extension HTTPURLResponse {
    static func sample(
        statusCode: Int = 200
    ) -> HTTPURLResponse {
        HTTPURLResponse(
            url: .sample(),
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: [:]
        )!
    }
}
