//
//  Button.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 09/06/2023.
//

import UIKit

final class Button: UIButton {
    private var model: Model?

    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(onTap), for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with model: Model) {
        self.model = model
        setTitle(model.title, for: .normal)
        setTitleColor(model.titleColor, for: .normal)
    }

    @objc
    private func onTap() {
        model?.onTap()
    }
}

// MARK: - Model

extension Button {
    final class Model {
        let title: String
        let titleColor: UIColor
        let onTap: () -> Void

        init(
            title: String,
            titleColor: UIColor,
            onTap: @escaping () -> Void
        ) {
            self.title = title
            self.titleColor = titleColor
            self.onTap = onTap
        }
    }
}
