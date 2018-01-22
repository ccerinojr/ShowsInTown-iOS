//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation

extension URL {
    init?(phoneNumber: String) {
        self.init(string: "telprompt:\(phoneNumber)")
    }
}
