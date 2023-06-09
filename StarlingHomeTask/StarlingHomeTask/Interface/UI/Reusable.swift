//
//  Reusable.swift
//  StarlingHomeTask
//
//  Created by Alexandru Pop on 09/06/2023.
//

import UIKit

protocol ReusableView {
    func update(with model: any ReusableModel)
}

protocol ReusableModel {
    associatedtype View: ReusableView
}

private extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: type(of: Self.self))
    }
}

struct Reusable<ViewType: ReusableView> {
    var id: String { ViewType.reuseIdentifier }
}

// MARK: - UITableView

extension UITableView {
    func register<CellType: UITableViewCell>(reusableCell reusable: Reusable<CellType>) {
        register(CellType.self, forCellReuseIdentifier: reusable.id)
    }

    func dequeue<CellType: UITableViewCell>(reusableCell reusable: Reusable<CellType>, indexPath: IndexPath) -> CellType {
        return dequeueReusableCell(withIdentifier: reusable.id, for: indexPath) as! CellType
    }
}
