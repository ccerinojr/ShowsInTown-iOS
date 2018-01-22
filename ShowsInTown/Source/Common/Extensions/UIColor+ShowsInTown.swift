//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

extension UIColor {
    
    private convenience init(displayP3RedValue red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.init(displayP3Red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
    class var sitSeparatorGray: UIColor {
        return UIColor(displayP3RedValue: 225.0, green: 226.0, blue: 227.0, alpha: 1.0)
    }
    
    class var sitDarkGray: UIColor {
        return UIColor(displayP3RedValue: 46.0, green: 55.0, blue: 60.0, alpha: 1.0)
    }
    
    class var sitLightGray: UIColor {
        return UIColor(displayP3RedValue: 108.0, green: 115.0, blue: 118.0, alpha: 1.0)
    }
    
    class var sitGreen: UIColor {
        return UIColor(displayP3RedValue: 103.0, green: 179.0, blue: 37.0, alpha: 1.0)
    }
}
