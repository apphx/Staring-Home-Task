//
//  HomeViewController.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 08/06/2023.
//

import UIKit

final class HomeViewController: UIViewController {
    private var viewModel: HomeViewModel

    private(set) lazy var tableView = UITableView()

    init(viewModel: HomeViewModel) {
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

private extension HomeViewController {
    func bindViewModel() {
        viewModel.onReload = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - SetupUI

private extension HomeViewController {
    func setupViews() {
        title = viewModel.title
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.register(reusableCell: Reusable<Cell>())
    }

    func setupHierarchy() {
        view.addSubview(tableView)
    }

    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.snapToEdges()
    }
}

// MARK: - DataSource

extension HomeViewController: UITableViewDataSource {
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
