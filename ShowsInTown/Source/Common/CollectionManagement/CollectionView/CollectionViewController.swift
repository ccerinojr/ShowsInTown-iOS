//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

protocol CascadingCollectionViewDelegate: UICollectionViewDelegate, UICollectionViewDataSource { }

protocol CollectionViewController: CascadingCollectionViewDelegate {
    weak var collectionView: UICollectionView? { get set }
}

extension CollectionViewController {
    
    func unlinkCollectionView() {
        self.collectionView?.dataSource = nil
        self.collectionView?.delegate = nil
        self.collectionView = nil
    }
    
    func linkCollectionView(_ collectionView: UICollectionView?) {
        self.unlinkCollectionView()
        
        self.collectionView = collectionView
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.reloadData()
    }
}
