//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

final class CollectionSource<ContentItemCell: UICollectionViewCell>: NSObject, CollectionViewController where ContentItemCell: ReusableViewRegisterable, ContentItemCell: ContentItemConfigurable {

    typealias ContentItem = ContentItemCell.ContentItem

    var contentItems: [ContentItem] = [] {
        didSet {
            self.collectionView?.reloadData()
        }
    }

    weak var collectionView: UICollectionView?
    
    var shouldSelectItem: ((_ item: ContentItem) -> Bool)?
    var didSelectItem: ((_ item: ContentItem, _ indexPath: IndexPath) -> ())?
    var didDeselectItem: ((_ item: ContentItem, _ indexPath: IndexPath) -> ())?
    
    convenience init(contentItems: [ContentItem]) {
        self.init()
        self.contentItems = contentItems
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.contentItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentItemCell.reuseIdentifier, for: indexPath) as! ContentItemCell
        let item = self.contentItems[indexPath.item]
        cell.configure(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return self.shouldSelectItem?(self.contentItems[indexPath.item]) ?? true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let contentItem = self.contentItems[indexPath.item]
        self.didSelectItem?(contentItem, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let contentItem = self.contentItems[indexPath.item]
        self.didDeselectItem?(contentItem, indexPath)
    }
}
