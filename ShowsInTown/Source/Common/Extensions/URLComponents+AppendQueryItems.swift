//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation

extension URLComponents {
    mutating func appendQueryItems(_ items: [URLQueryItem]) {
        let existingItems = self.queryItems ?? []
        self.queryItems = items + existingItems
    }
}
