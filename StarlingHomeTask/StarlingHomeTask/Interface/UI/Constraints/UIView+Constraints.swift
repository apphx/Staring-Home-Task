//
//  UIView+Constraints.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 09/06/2023.
//

import UIKit

extension UIView {
    func snapHorizontally(to view: UIView? = nil, spacing: CGFloat = 0) {
        guard let view = view ?? superview else { return assertionFailure() }
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacing),
            trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spacing)
        ])
    }

    func snapToTop(of view: UIView? = nil, spacing: CGFloat = 0) {
        guard let view = view ?? superview else { return assertionFailure() }
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacing)
        ])
    }

    func snapToBottom(of view: UIView? = nil, spacing: CGFloat = 0) {
        guard let view = view ?? superview else { return assertionFailure() }
        NSLayoutConstraint.activate([
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -spacing)
        ])
    }

    func limitToBottom(of view: UIView? = nil, spacing: CGFloat = 0) {
        guard let view = view ?? superview else { return assertionFailure() }
        NSLayoutConstraint.activate([
            bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -spacing)
        ])
    }

    func fixHeight(height: CGFloat) {
        let constraint =  heightAnchor.constraint(equalToConstant: height)
        constraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            constraint
        ])
    }

    func snapVertically(to view: UIView? = nil, spacing: CGFloat = 0) {
        snapToTop(of: view, spacing: spacing)
        snapToBottom(of: view, spacing: spacing)
    }

    func centerVertically(in view: UIView? = nil, offset: CGFloat = 0) {
        guard let view = view ?? superview else { return assertionFailure() }
        NSLayoutConstraint.activate([
            centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset)
        ])
    }

    func snapToEdges(
        of view: UIView? = nil,
        horizontalSpacing: CGFloat = 0,
        verticalSpacing: CGFloat = 0
    ) {
        snapVertically(to: view, spacing: verticalSpacing)
        snapHorizontally(to: view, spacing: horizontalSpacing)
    }
}
