//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

extension UIMotionEffect {
    
    enum Plane {
        case above
        case below
    }
    
    static func forViewInPlane(_ plane: Plane) -> UIMotionEffect {
        
        let distance = 20.0 * ((plane == .above) ? 1.0 : -1.0)
        let shadowDistance = distance * 0.25
        
        let xEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xEffect.minimumRelativeValue = -distance
        xEffect.maximumRelativeValue = distance
        
        let yEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yEffect.minimumRelativeValue = -distance
        yEffect.maximumRelativeValue = distance
        
        let xShadowEffect = UIInterpolatingMotionEffect(keyPath: "layer.shadowOffset.width", type: .tiltAlongHorizontalAxis)
        xShadowEffect.minimumRelativeValue = -shadowDistance
        xShadowEffect.maximumRelativeValue = shadowDistance
        
        let yShadowEffect = UIInterpolatingMotionEffect(keyPath: "layer.shadowOffset.height", type: .tiltAlongVerticalAxis)
        yShadowEffect.minimumRelativeValue = -shadowDistance
        yShadowEffect.maximumRelativeValue = shadowDistance
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xEffect, yEffect, xShadowEffect, yShadowEffect]
        return group
    }
}
