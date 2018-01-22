//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

class InvalidatingSupplementaryViewLayout: UICollectionViewFlowLayout {
    override func invalidationContext(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutInvalidationContext {
        let context: UICollectionViewLayoutInvalidationContext = super.invalidationContext(forPreferredLayoutAttributes: preferredAttributes, withOriginalAttributes: originalAttributes)
        
        let indexPath = preferredAttributes.indexPath
        
        if indexPath.item == 0 {
            context.invalidateSupplementaryElements(ofKind: UICollectionElementKindSectionHeader, at: [indexPath])
        }
        
        return context
    }
}
