//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableViewRegisterable {}

protocol ReusableNibViewRegisterable: ReusableViewRegisterable {}

extension ReusableViewRegisterable {
    static var reuseIdentifier: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}

extension ReusableNibViewRegisterable {
    
    fileprivate static func makeViewNib() -> UINib {
        return UINib(nibName: self.reuseIdentifier, bundle: nil)
    }
}

extension ReusableNibViewRegisterable where Self: UICollectionViewCell {
    static func registerCell(in collectionView: UICollectionView) {
        collectionView.register(self.makeViewNib(), forCellWithReuseIdentifier: self.reuseIdentifier)
    }
}

extension ReusableNibViewRegisterable where Self: UICollectionReusableView {
    static func registerSupplementaryView(in collectionView: UICollectionView, as kind: String) {
        collectionView.register(self.makeViewNib(), forSupplementaryViewOfKind: kind, withReuseIdentifier: self.reuseIdentifier)
    }
}

extension ReusableNibViewRegisterable where Self: UITableViewCell {
    static func registerCell(in tableView: UITableView) {
        tableView.register(self.makeViewNib(), forCellReuseIdentifier: self.reuseIdentifier)
    }
}

extension ReusableViewRegisterable where Self: UICollectionViewCell {
    static func registerCell(in collectionView: UICollectionView) {
        collectionView.register(self, forCellWithReuseIdentifier: self.reuseIdentifier)
    }
}

extension ReusableViewRegisterable where Self: UICollectionReusableView {
    static func registerSupplementaryView(in collectionView: UICollectionView, as kind: String) {
        collectionView.register(self, forSupplementaryViewOfKind: kind, withReuseIdentifier: self.reuseIdentifier)
    }
}

extension ReusableViewRegisterable where Self: UITableViewCell {
    static func registerCell(in tableView: UITableView) {
        tableView.register(self, forCellReuseIdentifier: self.reuseIdentifier)
    }
}

extension ReusableViewRegisterable where Self: UITableViewHeaderFooterView {
    static func register(in tableView: UITableView) {
        tableView.register(self, forHeaderFooterViewReuseIdentifier: self.reuseIdentifier)
    }
}
