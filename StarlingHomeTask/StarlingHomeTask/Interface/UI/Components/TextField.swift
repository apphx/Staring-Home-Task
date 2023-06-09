//
//  TextField.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 09/06/2023.
//

import UIKit

final class TextField: UITextField {
    private var model: Model?

    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(textChanged), for: .editingChanged)
        textAlignment = .center
        borderStyle = .bezel
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with model: Model) {
        self.model = model
        placeholder = model.placeholder
        text = model.text
    }

    @objc
    private func textChanged(_ textField: UITextField) {
        model?.text = text ?? ""
    }
}

// MARK: - Model

extension TextField {
    final class Model {
        var text: String
        let placeholder: String

        init(
            text: String = "",
            placeholder: String
        ) {
            self.text = text
            self.placeholder = placeholder
        }
    }
}
