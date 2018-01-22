//
//  Copyright © 2018 Carmen Cerino. All rights reserved.
//

import Foundation

struct ITunesTrack: Track, Decodable, ITunesObjectWrapperType {
    
    static let nameOfType = "track"

    enum CodingKeys: String, CodingKey {
        case trackName
        case collectionName
        case previewURL = "previewUrl"
        case artworkURL = "artworkUrl100"
    }
    
    let trackName: String
    let collectionName: String
    let previewURL: URL
    let artworkURL: URL
    
    var name: String { return trackName }
    var albumName: String { return collectionName }
}
