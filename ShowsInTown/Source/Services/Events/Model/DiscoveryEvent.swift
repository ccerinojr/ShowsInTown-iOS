//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation
import CoreLocation

public struct DiscoveryEvent: Decodable {
    
    public let name : String
    public let identifier : String
    public let isTest : Bool
    public let webURL : URL
    public let locale : Locale
    public let images : [DiscoveryRemoteImage]
    public let date : DiscoveryEvent.EventDate
    public let attractions: [DiscoveryAttraction]
    public let venues: [DiscoveryVenue]
    
    public init(identifier: String, name: String, webURL: URL, locale: Locale, date: DiscoveryEvent.EventDate, attractions: [DiscoveryAttraction], venues: [DiscoveryVenue], images: [DiscoveryRemoteImage] = [], isTest: Bool = false) {
        self.name = name
        self.identifier = identifier
        self.locale = locale
        self.webURL = webURL
        self.date = date
        self.images = images
        self.isTest = isTest
        self.venues = venues
        self.attractions = attractions
    }
}

public extension DiscoveryEvent {
    
    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case locale
        case webURL = "url"
        case date = "dates"
        case images
        case isTest = "test"
        case embeddedObjects = "_embedded"
    }
    
    private enum EmbeddedObjects: String, CodingKey {
        case attractions
        case venues
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.identifier = try container.decode(String.self, forKey: .identifier)
        self.isTest = try container.decodeIfPresent(Bool.self, forKey: .isTest) ?? false
        self.webURL = try container.decode(URL.self, forKey: .webURL)
        self.images = try container.decode([DiscoveryRemoteImage].self, forKey: .images)
        
        let localeIdentifier = try container.decode(String.self, forKey: .locale)
        self.locale = Locale(identifier: localeIdentifier)
        
        
        let embeddedObjectsContainer = try container.nestedContainer(keyedBy: EmbeddedObjects.self, forKey: .embeddedObjects)
        self.attractions = try embeddedObjectsContainer.decodeIfPresent([DiscoveryAttraction].self, forKey: .attractions) ?? []
        self.venues = try embeddedObjectsContainer.decodeIfPresent([DiscoveryVenue].self, forKey: .venues) ?? []
        
        self.date = try container.decode(EventDate.self, forKey: .date)
    }
}


