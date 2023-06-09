//
//  Label.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 09/06/2023.
//

import UIKit

final class Label: UILabel {
    convenience init() {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }

    func update(with model: Model) {
        text = model.text
        textColor = model.textColor
        numberOfLines = model.numberOfLines
    }

    func updateOrHide(with model: Model?) {
        if let model {
            update(with: model)
        } else {
            isHidden = true

            text = nil
            textColor = nil
            numberOfLines = 0
        }
    }
}

extension Label {
    final class Model {
        let text: String
        let textColor: UIColor
        let numberOfLines: Int

        init(
            text: String,
            textColor: UIColor = .darkText,
            numberOfLines: Int = 0
        ) {
            self.text = text
            self.textColor = textColor
            self.numberOfLines = numberOfLines
        }
    }
}
