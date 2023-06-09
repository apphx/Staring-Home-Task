//
//  URLRequestFactory.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 08/06/2023.
//

import Foundation

extension URLRequest {
    static func makeWith(
        path: String,
        httpMethod: HttpMethod = .get()
    ) -> Self {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api-sandbox.starlingbank.com"
        components.path = "/api/v2\(path)"

        var request: URLRequest

        switch httpMethod {
        case let .get(queryParameters):
            components.queryItems = queryParameters.map { (key, value) in
                URLQueryItem(name: key, value: value)
            }
            request = URLRequest(url: components.url!)
        case let .put(body):
            request = URLRequest(url: components.url!)
            guard let bodyData = try? JSONEncoder().encode(body) else { break }
            request.httpBody = bodyData
            request.addValue("application/json", forHTTPHeaderField: "ContentType")
        }

        return request
    }
}

extension URLRequest {
    enum HttpMethod {
        case get(queryParameters: [String: String] = [:])
        case put(body: Encodable)

        var rawValue: String {
            switch self {
            case .get:
                return "GET"
            case .put:
                return "PUT"
            }
        }
    }
}
