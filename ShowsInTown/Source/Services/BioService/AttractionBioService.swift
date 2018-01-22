//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation
import PromiseKit

protocol AttractionBioService {
    func isSupported(_ attraction: Attraction) -> Bool
    func bio(for attraction: Attraction) -> Promise<String>
}
