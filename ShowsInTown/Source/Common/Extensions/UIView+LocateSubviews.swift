//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

extension UIView {
    func locateSubviews(ofClass targetClass: AnyClass, in view: UIView) -> [UIView] {
        
        if view.isKind(of: targetClass) {
            return [view]
        }
        
        var locatedViews: [UIView] = []
        for subview in view.subviews {
            let views = self.locateSubviews(ofClass: targetClass, in: subview)
            locatedViews.append(contentsOf: views)
        }
        return locatedViews
    }
}
