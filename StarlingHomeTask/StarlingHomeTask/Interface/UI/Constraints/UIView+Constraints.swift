//
//  UIView+Constraints.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 09/06/2023.
//

import UIKit

extension UIView {
    func snapHorizontally(to view: UIView? = nil, spacing: CGFloat) {
        guard let view = view ?? superview else { return assertionFailure() }
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacing),
            trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spacing)
        ])
    }

    func centerVertically(in view: UIView? = nil, offset: CGFloat = 0) {
        guard let view = view ?? superview else { return assertionFailure() }
        NSLayoutConstraint.activate([
            centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset)
        ])
    }
}
