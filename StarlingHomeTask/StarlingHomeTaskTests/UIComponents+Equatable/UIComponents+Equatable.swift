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

extension Label.Model: Equatable {
    public static func == (
        lhs: StarlingHomeTask.Label.Model,
        rhs: StarlingHomeTask.Label.Model
    ) -> Bool {
        lhs.text == rhs.text &&
        lhs.textColor == rhs.textColor &&
        lhs.numberOfLines == rhs.numberOfLines
    }
}

extension Cell.Model: Equatable {
    public static func == (
        lhs: StarlingHomeTask.Cell.Model,
        rhs: StarlingHomeTask.Cell.Model
    ) -> Bool {
        lhs.title == rhs.title &&
        lhs.subtitle == rhs.subtitle
    }
}
