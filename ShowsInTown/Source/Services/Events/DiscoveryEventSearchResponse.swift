//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation

struct DiscoveryEventSearchResponse: Decodable {
    
    struct Page: Decodable {
        let size: Int
        let totalElements: Int
        let totalPages: Int
        let number: Int
    }
    
    enum LinkType: String, CodingKey {
        case first
        case `self`
        case next
        case last
    }
    
    let events: [DiscoveryEvent]
    let page: Page
    let links: [LinkType: URL]
}

extension DiscoveryEventSearchResponse {
    
    private enum CodingKeys: String, CodingKey {
        case embeddedObjects = "_embedded"
        case links = "_links"
        case page
    }
    
    private enum EmbeddedObjectCodingKeys: String, CodingKey {
        case events
    }
    
    private enum LinkCodingKeys: String, CodingKey {
        case href
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if container.contains(.embeddedObjects) {
            let embeddedObjects = try container.nestedContainer(keyedBy: EmbeddedObjectCodingKeys.self, forKey: .embeddedObjects)
            self.events = try embeddedObjects.decode([DiscoveryEvent].self, forKey: .events)
        } else {
            self.events = []
        }
        
        self.page = try container.decode(Page.self, forKey: .page)
        
        let linksContainer = try container.nestedContainer(keyedBy: LinkType.self, forKey: .links)
        
        var links = [LinkType: URL]()
        for linkType in linksContainer.allKeys {
            let linkContainer = try linksContainer.nestedContainer(keyedBy: LinkCodingKeys.self, forKey: linkType)
            let link = try linkContainer.decode(URL.self, forKey: .href)
            links[linkType] = link
        }
        
        self.links = links
    }
    
}
