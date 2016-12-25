//
//  AutoReusable.swift
//  Tinbox
//
//  Created by Zhu Shengqi on 25/12/2016.
//  Copyright © 2016 Zhu Shengqi. All rights reserved.
//

import UIKit

// MARK: - AutoReusable
protocol AutoReusable: class {
    static var autoReuseIdentifier: String { get }
}

extension AutoReusable {
    static var autoReuseIdentifier: String {
        return "\(self)"
    }
}

extension UITableViewCell: AutoReusable {}
extension UITableViewHeaderFooterView: AutoReusable {}
extension UICollectionReusableView: AutoReusable {}

// MARK: - UITableView
extension UITableView {
    // MARK: - Register
    func registerNibForCell<T: UITableViewCell>(type: T.Type) where T: AutoReusable {
        register(UINib(nibName: T.autoReuseIdentifier, bundle: nil), forCellReuseIdentifier: T.autoReuseIdentifier)
    }
    
    func registerClassForCell<T: UITableViewCell>(type: T.Type) where T: AutoReusable {
        register(type, forCellReuseIdentifier: T.autoReuseIdentifier)
    }
    
    func registerNibForHeaderFooterView<T: UITableViewHeaderFooterView>(type: T.Type) where T: AutoReusable {
        register(UINib(nibName: T.autoReuseIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: T.autoReuseIdentifier)
    }
    
    func registerClassForHeaderFooterView<T: UITableViewHeaderFooterView>(type: T.Type) where T: AutoReusable {
        register(type, forHeaderFooterViewReuseIdentifier: T.autoReuseIdentifier)
    }
    
    // MARK: - Dequeue
    func dequeueReusableCell<T: UITableViewCell>(type: T.Type, for indexPath: IndexPath) -> T where T: AutoReusable {
        return self.dequeueReusableCell(withIdentifier: T.autoReuseIdentifier, for: indexPath) as! T
    }
    
    func dequeueReusableCell<T: UITableViewCell>(type: T.Type) -> T where T: AutoReusable {
        return self.dequeueReusableCell(withIdentifier: T.autoReuseIdentifier) as! T
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(type: T.Type) -> T where T: AutoReusable {
        return self.dequeueReusableHeaderFooterView(withIdentifier: T.autoReuseIdentifier) as! T
    }
}

// MARK: - UICollectionView
extension UICollectionView {
    // MARK: - Register
    func registerNibForCell<T: UICollectionViewCell>(type: T.Type) where T: AutoReusable {
        register(UINib(nibName: T.autoReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: T.autoReuseIdentifier)
    }
    
    func registerClassForCell<T: UICollectionViewCell>(type: T.Type) where T: AutoReusable {
        register(type, forCellWithReuseIdentifier: T.autoReuseIdentifier)
    }
    
    func registerNibForSupplementaryViewOfKind<T: UICollectionReusableView>(_ kind: String, type: T.Type) where T: AutoReusable {
        register(UINib(nibName: T.autoReuseIdentifier, bundle: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: T.autoReuseIdentifier)
    }
    
    func registerClassForSupplementaryViewOfKind<T: UICollectionReusableView>(_ kind: String, type: T.Type) where T: AutoReusable {
        register(type, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.autoReuseIdentifier)
    }
    
    // MARK: - Dequeue
    func dequeueReusableCell<T: UICollectionViewCell>(type: T.Type, for indexPath: IndexPath) -> T where T: AutoReusable {
        return self.dequeueReusableCell(withReuseIdentifier: T.autoReuseIdentifier, for: indexPath) as! T
    }
    
    func dequeueReusableSupplementaryViewOfKind<T: UICollectionReusableView>(_ kind: String, type: T.Type, for indexPath: IndexPath) -> T where T: AutoReusable {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.autoReuseIdentifier, for: indexPath) as! T
    }
}

// MARK: - UIColllectionViewLayout
extension UICollectionViewLayout {
    func registerNibForDecorationViewOfKind<T: UICollectionReusableView>(_ kind: String, type: T.Type) where T: AutoReusable {
        register(UINib(nibName: T.autoReuseIdentifier, bundle: nil), forDecorationViewOfKind: kind)
    }
    
    func registerClassForDecorationViewOfKind<T: UICollectionReusableView>(_ kind: String, type: T.Type) where T: AutoReusable {
        register(type, forDecorationViewOfKind: kind)
    }
}
