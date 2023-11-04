//
//  HeaderReusingUtils.swift
//  Macroscop-TestAssignment
//
//  Created by Богдан Полыгалов on 04.11.2023.
//

import UIKit

protocol ReusableHeaderIdentifying {
    static var defaultHeaderReuseIdentifier: String { get }
}

extension ReusableHeaderIdentifying where Self: UICollectionReusableView {
    static var defaultHeaderReuseIdentifier: String {
        NSStringFromClass(self).components(separatedBy: ".").last ?? NSStringFromClass(self)
    }
}

extension UICollectionView {
    func registerHeader<T: UICollectionReusableView>(_: T.Type, forSupplementaryViewOfKind kind: String) where T: ReusableHeaderIdentifying {
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.defaultHeaderReuseIdentifier)
    }

    func dequeueReusableHeader<T: UICollectionReusableView>(ofKind kind: String, indexPath: IndexPath) -> T where T: ReusableHeaderIdentifying {
        guard let header = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.defaultHeaderReuseIdentifier, for: indexPath) as? T else {
            assertionFailure("Нельзя взять заголовок: \(T.defaultHeaderReuseIdentifier) для: \(indexPath)")
            return T()
        }
        return header
    }
}
