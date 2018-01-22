//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation
import PromiseKit

enum TrackProviderError: Error {
    case failedToFetch
    case failedToParse
    case attractionNotSupported
}

protocol TrackProvider {
    
    var trackCount: UInt { get set }
    
    func isSupported(_ attraction: Attraction) -> Bool
    func tracks(for attraction: Attraction, limit: UInt) -> Promise<[Track]>
}
