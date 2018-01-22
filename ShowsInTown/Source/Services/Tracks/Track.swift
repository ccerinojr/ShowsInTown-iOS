//
//  Copyright © 2018 Carmen Cerino. All rights reserved.
//

import Foundation

protocol Track {
    var name: String { get }
    var albumName: String { get }
    var previewURL: URL { get }
    var artworkURL: URL { get }
}
