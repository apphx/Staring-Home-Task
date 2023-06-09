//
//  AuthorizationViewController.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 08/06/2023.
//

import UIKit

final class AuthorizationViewController: UIViewController {
    private let viewModel: AuthorizationViewModel

    private(set) lazy var textField = TextField()
    private(set) lazy var confirmButton = Button()
    private(set) lazy var stack = makeStackView()

    init(viewModel: AuthorizationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupHierarchy()
        setupConstraints()
    }

}

// MARK: - Setup UI

private extension AuthorizationViewController {
    func makeStackView() -> UIStackView {
        UIStackView(arrangedSubviews: [
            textField,
            confirmButton
        ])
    }

    func setupViews() {
        view.backgroundColor = .white
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false

        textField.update(with: viewModel.textField)
        confirmButton.update(with: viewModel.confirmButton)
    }

    func setupHierarchy() {
        view.addSubview(stack)
    }

    func setupConstraints() {
        stack.snapHorizontally(spacing: 16)
        stack.centerVertically(offset: -56)
    }
}
