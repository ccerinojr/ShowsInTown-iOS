//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation

public enum ServiceResponse<T> {
    case success(response: T)
    case failure(error: Error)
}
