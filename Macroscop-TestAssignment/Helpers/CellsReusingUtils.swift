//
//  CellsReusingUtils.swift
//  Macroscop-TestAssignment
//
//  Created by Богдан Полыгалов on 04.11.2023.
//

import UIKit

protocol ReuseIdentifying {
    static var defaultCellReuseIdentifier: String { get }
}

extension ReuseIdentifying where Self: UICollectionViewCell {
    static var defaultCellReuseIdentifier: String {
        NSStringFromClass(self).components(separatedBy: ".").last ?? NSStringFromClass(self)
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReuseIdentifying {
        register(T.self, forCellWithReuseIdentifier: T.defaultCellReuseIdentifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T where T: ReuseIdentifying {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultCellReuseIdentifier, for: indexPath) as? T else {
            assertionFailure("Нельзя взять ячейку: \(T.defaultCellReuseIdentifier) для: \(indexPath)")
            return T()
        }
        return cell
    }

    func cellForItem<T: UICollectionViewCell>(at indexPath: IndexPath) -> T where T: ReuseIdentifying {
        guard let cell = cellForItem(at: indexPath) as? T else {
            assertionFailure("Не могу найти ячейку: \(T.defaultCellReuseIdentifier) для: \(indexPath)")
            return T()
        }
        return cell
    }
}
