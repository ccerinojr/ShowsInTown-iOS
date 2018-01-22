//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    var startingAndEndingColors: (starting: UIColor, ending: UIColor) = (UIColor(white: 1.0, alpha: 0.0), .white) {
        didSet {
            self.gradientLayer.colors = [startingAndEndingColors.starting.cgColor, startingAndEndingColors.ending.cgColor]
        }
    }
    
    var startingAndEndingLocations: (starting: CGFloat, ending: CGFloat) = (0.0, 1.0) {
        didSet {
            self.gradientLayer.locations = [NSNumber(value: Float(startingAndEndingLocations.starting)), NSNumber(value: Float(startingAndEndingLocations.ending))]
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.frame = self.bounds
    }
    
    override open class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }
    
    //MARK: Private variables
    
    private var gradientLayer: CAGradientLayer {
        return self.layer as! CAGradientLayer
    }
}
