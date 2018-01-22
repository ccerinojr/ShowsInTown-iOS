//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation
import CoreLocation

public struct DiscoveryVenue: Decodable {
    
    public enum BoxOfficeInfoKey: String, CodingKey, CustomStringConvertible {
        case phoneNumberDetail
        case willCallDetail
        case acceptedPaymentDetail
        case openHoursDetail
  
        public var description: String {
            switch self {
            case .phoneNumberDetail:
                return NSLocalizedString("Phone Numbers", comment: "Phone Numbers")
            case .willCallDetail:
                return NSLocalizedString("Will Call", comment: "Will Call")
            case .acceptedPaymentDetail:
                return NSLocalizedString("Accepted Payments", comment: "Accepted Payments")
            case .openHoursDetail:
                return NSLocalizedString("Open Hours", comment: "Open Hours")
            }
        }
    }
    
    public enum GeneralInfoKey: String, CodingKey, CustomStringConvertible {
        case generalRule
        case childRule
        
        public var description: String {
            switch self {
            case .generalRule:
                return NSLocalizedString("General Rules", comment: "General Rules")
            case .childRule:
                return NSLocalizedString("Child Rules", comment: "Child Rules")
            }
        }
    }
    
    public let identifier: String
    public let name: String
    public let location: CLLocationCoordinate2D
    public let address: DiscoveryVenue.Address
    public let website: URL?
    public let twitterHandle: String?
    
    public let parkingInfo: String?
    public let boxOfficeInfo: [BoxOfficeInfoKey: String]
    public let generalInfo: [GeneralInfoKey: String]
    
    public func distance(from location: CLLocation) -> CLLocationDistance {
        let venueLocation = CLLocation(latitude: self.location.latitude, longitude: self.location.longitude)
        return venueLocation.distance(from: location)
    }
}

public extension DiscoveryVenue {
    
    private enum CodingKeys: String, CodingKey {
        case name
        case identifier = "id"
        case location
        case website = "url"
        case boxOfficeInfo
        case parkingInfo = "parkingDetail"
        case generalInfo
        case social
    }
    
    private enum LocationCodingKeys: String, CodingKey {
        case longitude
        case latitude
    }
    
    private enum SocialCodingKeys: String, CodingKey {
        case twitter
    }
    
    private enum TwitterCodingKeys: String, CodingKey {
        case handle
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.identifier = try container.decode(String.self, forKey: .identifier)
        self.name = try container.decode(String.self, forKey: .name)
        self.website = try container.decodeIfPresent(URL.self, forKey: .website)
        
        if container.contains(.social) {
            let socialContainer = try container.nestedContainer(keyedBy: SocialCodingKeys.self, forKey: .social)
            let twitterContainer = try socialContainer.nestedContainer(keyedBy: TwitterCodingKeys.self, forKey: .twitter)
            self.twitterHandle = try twitterContainer.decodeIfPresent(String.self, forKey: .handle)
        } else {
            self.twitterHandle = nil
        }
        
        let locationContainer = try container.nestedContainer(keyedBy: LocationCodingKeys.self, forKey: .location)
        let longitudeAsString = try locationContainer.decode(String.self, forKey: .longitude)
        let latitudeAsString = try locationContainer.decode(String.self, forKey: .latitude)
        
        if let longitude = Double(longitudeAsString), let latitude = Double(latitudeAsString) {
            self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            let context = DecodingError.Context(codingPath: [LocationCodingKeys.latitude, LocationCodingKeys.longitude], debugDescription: "String value unable to be converted to double")
            throw DecodingError.typeMismatch(Double.self, context)
        }
        
        self.parkingInfo = try container.decodeIfPresent(String.self, forKey: .parkingInfo)
        
        if container.contains(.boxOfficeInfo) {
            let boxOfficeContainer = try container.nestedContainer(keyedBy: BoxOfficeInfoKey.self, forKey: .boxOfficeInfo)
            var boxOfficeInfo = [BoxOfficeInfoKey: String]()
            for key in boxOfficeContainer.allKeys {
                boxOfficeInfo[key] = try boxOfficeContainer.decode(String.self, forKey: key)
            }
            self.boxOfficeInfo = boxOfficeInfo
        } else {
            self.boxOfficeInfo = [:]
        }
        
        if container.contains(.generalInfo) {
            let generalInfoContainer = try container.nestedContainer(keyedBy: GeneralInfoKey.self, forKey: .generalInfo)
            var generalInfo = [GeneralInfoKey: String]()
            for key in generalInfoContainer.allKeys {
                generalInfo[key] = try generalInfoContainer.decode(String.self, forKey: key)
            }
            
            self.generalInfo = generalInfo
        } else {
            self.generalInfo = [:]
        }

        self.address = try Address(from: decoder)
    }
}
