//
//  RoundUpViewController.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 09/06/2023.
//

import UIKit

final class RoundUpViewController: UIViewController {
    private enum Constants {
        static let buttonHeight: CGFloat = 56
        static let buttonPadding: CGFloat = 16
    }
    private var viewModel: RoundUpViewModel

    private(set) lazy var tableView = UITableView()
    private(set) lazy var button = Button()

    init(viewModel: RoundUpViewModel) {
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
        bindViewModel()

        viewModel.viewDidLoad()
    }
}

// MARK: - Behaviour

private extension RoundUpViewController {
    func bindViewModel() {
        viewModel.onReload = { [weak self] in
            guard let self else { return }
            self.tableView.reloadData()
            self.button.update(with: self.viewModel.roundUpButton)
        }
    }
}

// MARK: - SetupUI

private extension RoundUpViewController  {
    func setupViews() {
        title = viewModel.title
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.register(reusableCell: Reusable<Cell>())
    }

    func setupHierarchy() {
        view.addSubview(tableView)
        view.addSubview(button)
    }

    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.snapToEdges()
        tableView.contentInset = .init(
            top: tableView.contentInset.top,
            left: tableView.contentInset.left,
            bottom: tableView.contentInset.bottom + Constants.buttonHeight + Constants.buttonPadding,
            right: tableView.contentInset.right
        )
        button.snapHorizontally()
        button.snapToBottom()
        button.fixHeight(height: Constants.buttonHeight)
    }
}

// MARK: - DataSource

extension RoundUpViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.model(at: indexPath)
        let cell = tableView.dequeue(reusableCell: Reusable<Cell>(), indexPath: indexPath)
        cell.update(with: model)
        return cell
    }
}
