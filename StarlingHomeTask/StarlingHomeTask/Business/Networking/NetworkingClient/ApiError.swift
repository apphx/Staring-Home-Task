//
//  ApiError.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 08/06/2023.
//

import Foundation

enum ApiError: Error {
    case httpFailure(code: Int)
    case genericError
}
