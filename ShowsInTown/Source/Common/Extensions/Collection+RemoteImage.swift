//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation
import CoreGraphics

extension Array where Element == DiscoveryRemoteImage {
    func image(forTargetWidth targetWidth: CGFloat) -> DiscoveryRemoteImage? {
        return self.reduce(nil) { (result, image) -> DiscoveryRemoteImage? in
            guard image.size.width >= targetWidth else { return result }
            guard let result = result else { return image }
            
            return result.size.width <= image.size.width ? result : image
        }
    }
}
