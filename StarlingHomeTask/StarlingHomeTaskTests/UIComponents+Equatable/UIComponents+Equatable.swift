//
//  UIComponents+Equatable.swift
//  StarlingHomeTaskTests
//
//  Created by Alexandru Pop on 09/06/2023.
//

@testable import StarlingHomeTask

extension Button.Model: Equatable {
    public static func == (
        lhs: StarlingHomeTask.Button.Model,
        rhs: StarlingHomeTask.Button.Model
    ) -> Bool {
        lhs.title == rhs.title &&
        lhs.titleColor == rhs.titleColor
    }
}

extension TextField.Model: Equatable {
    public static func == (
        lhs: StarlingHomeTask.TextField.Model,
        rhs: StarlingHomeTask.TextField.Model
    ) -> Bool {
        lhs.placeholder == rhs.placeholder &&
        lhs.text == rhs.text
    }
}
