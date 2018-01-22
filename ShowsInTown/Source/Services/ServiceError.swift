//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation

enum ServiceError: Error {
    case noData
    case failedToCovertDataToJSON
    case jsonDeserializationFailed
}
