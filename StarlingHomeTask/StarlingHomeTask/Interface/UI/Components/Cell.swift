//
//  Cell.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 09/06/2023.
//

import UIKit

final class Cell: UITableViewCell, ReusableView {
    private enum Constants {
        static let horizontalSpacing: CGFloat = 16
        static let verticalSpacing: CGFloat = 4
    }

    private lazy var titleLabel = Label()
    private lazy var subtitleLabel = Label()

    private lazy var titleSubtitleStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        titleSubtitleStack.axis = .vertical
        titleSubtitleStack.spacing = 8

        contentView.addSubview(titleSubtitleStack)

        titleSubtitleStack.snapHorizontally(spacing: Constants.horizontalSpacing)
        titleSubtitleStack.snapToTop(spacing: Constants.verticalSpacing)
        titleSubtitleStack.limitToBottom(spacing: Constants.verticalSpacing)
        titleSubtitleStack.translatesAutoresizingMaskIntoConstraints = false

        selectionStyle = .none
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with model: any ReusableModel) {
        guard let model = model as? Model else { return assertionFailure() }
        titleLabel.update(with: model.title)
        subtitleLabel.updateOrHide(with: model.subtitle)
    }
}

extension Cell {
    final class Model: ReusableModel {
        typealias View = Cell

        let title: Label.Model
        let subtitle: Label.Model?
        let onTap: (() -> Void)?

        init(
            title: Label.Model,
            subtitle: Label.Model? = nil,
            onTap: (() -> Void)? = nil
        ) {
            self.title = title
            self.subtitle = subtitle
            self.onTap = onTap
        }
    }
}
