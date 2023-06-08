//
//  KeychainMock.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 08/06/2023.
//

@testable import StarlingHomeTask
import Foundation

final class KeychainMock: KeychainProtocol {
    private(set) var writeKey = [String]()
    private(set) var writeData = [Data]()
    var writeResult: Result<Void>!

    func write(key: String, data: Data) -> StarlingHomeTask.Result<Void> {
        writeKey.append(key)
        writeData.append(data)
        return writeResult
    }

    private(set) var readKey = [String]()
    var readResult: Result<Data?>!
    func read(key: String) -> StarlingHomeTask.Result<Data?> {
        readKey.append(key)
        return readResult
    }
}
