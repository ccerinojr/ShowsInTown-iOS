//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation

struct Attraction {
    
    let indentifier: String
    let name: String
    let images: [DiscoveryRemoteImage]
    let externalLinks: [DiscoveryAttraction.ExternalSource: [URL]]
    let externalIdentifiers: [DiscoveryAttraction.ExternalSource: [String]]
    var bio: String?
    var tracks = [Track]()
    
    var canShowADP: Bool {
        let hasTracks = self.tracks.isEmpty == false
        let hasExternalLinks = self.externalLinks.isEmpty == false
        let hasBio = self.bio?.isEmpty ?? false
        
        return hasBio || hasTracks || hasExternalLinks
    }
    
    static func makeAttractions(from event: DiscoveryEvent) -> [Attraction] {
        if event.attractions.isEmpty {
            return [Attraction(event: event)]
        } else {
            return event.attractions.map({ return Attraction(attraction: $0) })
        }
    }
    
    init(attraction: DiscoveryAttraction) {
        self.indentifier = attraction.identifier
        self.name = attraction.name
        self.images = attraction.images
        self.externalLinks = attraction.externalLinks
        self.externalIdentifiers = attraction.externalIdentifiers
    }
    
    init(event: DiscoveryEvent) {
        self.indentifier = event.identifier
        self.name = event.name
        self.images = event.images
        self.externalLinks = [:]
        self.externalIdentifiers = [:]
    }
}
