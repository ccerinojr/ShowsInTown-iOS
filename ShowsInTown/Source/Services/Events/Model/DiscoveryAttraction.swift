//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation

public struct DiscoveryAttraction: Decodable {
    
    public enum ExternalSource: String, CustomStringConvertible, Decodable, CodingKey {
        case itunes
        case twitter
        case youtube
        case musicbrainz
        case lastfm
        case wiki
        case facebook
        case homepage
        case spotify
        case instagram
        
        public var description: String {
            switch self {
            case .itunes:
                return NSLocalizedString("iTunes", comment: "iTunes")
            case .homepage:
                return NSLocalizedString("Homepage", comment: "Homepage")
            case .facebook:
                return NSLocalizedString("Facebook", comment: "Facebook")
            case .instagram:
                return NSLocalizedString("Instagram", comment: "Instagram")
            case .spotify:
                return NSLocalizedString("Spotify", comment: "Spotify")
            case .twitter:
                return NSLocalizedString("Twitter", comment: "Twitter")
            case .lastfm:
                return NSLocalizedString("Last.fm", comment: "Last.fm")
            case .musicbrainz:
                return NSLocalizedString("Musicbrainz", comment: "Musicbrainz")
            case .youtube:
                return NSLocalizedString("YouTube", comment: "YouTube")
            case .wiki:
                return NSLocalizedString("Wikipedia", comment: "Wikipedia")
            }
        }
    }
    
    public let identifier: String
    public let name: String
    public let images: [DiscoveryRemoteImage]
    public let externalIdentifiers: [ExternalSource: [String]]
    public let externalLinks: [ExternalSource: [URL]]
    public let classifications: [[String : Any]]
    
    
}

public extension DiscoveryAttraction {
    
    private enum CodingKeys: String, CodingKey {
        case name
        case identifier = "id"
        case images
        case externalLinks
        case classifications
    }
    
    private enum ExternalSourceCodingKeys: String, CodingKey {
        case identifer = "id"
        case url
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.identifier = try container.decode(String.self, forKey: .identifier)
        self.images = try container.decode([DiscoveryRemoteImage].self, forKey: .images)
        
        let classifications: [[String: Any]]? = try container.decodeIfPresent(Array<Any>.self, forKey: .classifications) as? [[String : Any]]
        self.classifications = classifications ?? [[:]]
        
        var externalLinks = [ExternalSource: [URL]]()
        var externalIdentifiers = [ExternalSource: [String]]()
        
        if container.contains(.externalLinks) {
            let externalLinkContainer = try container.nestedContainer(keyedBy: ExternalSource.self, forKey: .externalLinks)
            
            for source in externalLinkContainer.allKeys {
                var sourcesArray = try externalLinkContainer.nestedUnkeyedContainer(forKey: source)
                
                while (!sourcesArray.isAtEnd) {
                    let sourceData = try sourcesArray.nestedContainer(keyedBy: ExternalSourceCodingKeys.self)
                    
                    if let url = try sourceData.decodeIfPresent(URL.self, forKey: .url) {
                        var links = externalLinks[source, default: []]
                        links.append(url)
                        externalLinks[source] = links
                    }
                    
                    if let identifier = try sourceData.decodeIfPresent(String.self, forKey: .identifer) {
                        var identifiers = externalIdentifiers[source, default: []]
                        identifiers.append(identifier)
                        externalIdentifiers[source] = identifiers
                    }
                }
            }
        }
        
        self.externalLinks = externalLinks
        self.externalIdentifiers = externalIdentifiers
        
    }
}
