//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

class CarouselCollectionViewLayout: UICollectionViewFlowLayout {
    
    struct Page {
        let rows: UInt
        let columns: UInt
    }
    
    var page = Page(rows: 1, columns: 1)
    
    override var scrollDirection: UICollectionViewScrollDirection {
        didSet {
            if self.scrollDirection != .horizontal {
                assertionFailure("CarouselCollectionViewLayout requires horizontal scroll direction")
            }
        }
    }

    override var sectionInset: UIEdgeInsets {
        set {
            let horizontalMargin = max(newValue.left, newValue.right)
            super.sectionInset = UIEdgeInsetsMake(newValue.top, horizontalMargin, newValue.bottom, horizontalMargin)
        }
        get {
            return super.sectionInset
        }
       
    }
    
    override var minimumLineSpacing: CGFloat {
        set {
            super.minimumLineSpacing = newValue
        }
        
        get {
            return self.sectionInset.left / 2.0
        }
    }
    
    override func prepare() {
        
        let size: CGSize
        if let collectionView = self.collectionView {
            
            let availableSpaceForWidth = collectionView.bounds.width - (self.sectionInset.left) - (self.minimumLineSpacing * CGFloat(self.page.columns)) - self.peekAmount
            let width = floor(availableSpaceForWidth / CGFloat(self.page.columns))
            
            let availableSpaceForHeight = collectionView.bounds.height - (self.sectionInset.top + self.sectionInset.bottom) - (self.minimumInteritemSpacing * CGFloat(self.page.rows-1))
            let height = floor(availableSpaceForHeight / CGFloat(self.page.rows))
            
            size = CGSize(width: width, height: height)
        
        } else {
            size = CGSize(width: 50.0, height: 50.0)
        }
        
        self.itemSize = size
        
        super.prepare()

    }

    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }
        
        var proposedContentOffset = proposedContentOffset
        
        let pageWidth = self.sectionInset.left + self.itemSize.width - self.peekAmount
        let currentPage = round(collectionView.contentOffset.x / pageWidth)
        var page = round(proposedContentOffset.x / pageWidth)

        if page == currentPage && abs(velocity.x) > 0.25 {
            if velocity.x > 0 {
                page = currentPage + 1
            } else {
                page = currentPage - 1
            }
        }
        
        proposedContentOffset.x = min(collectionView.contentSize.width - pageWidth, max(0, page * pageWidth))
        
        
        return proposedContentOffset
    }
    
    private var peekAmount: CGFloat {
        return self.minimumLineSpacing
    }
    
}
