//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation
import Contacts

public extension DiscoveryVenue {
    public struct Address: Decodable {
        let street: String
        let city: String
        let state: String
        let postalCode: String
        let country: String
        
        
        
        func makePostalAddress() -> CNPostalAddress {
            let address = CNMutablePostalAddress()
            address.street = self.street
            address.city = self.city
            address.state = self.state
            address.postalCode = self.postalCode
            return address
        }
        
        func makeSingleLineAddressText() -> String {
            let address = self.makePostalAddress()
            let formatter = CNPostalAddressFormatter()
            return formatter.string(from: address).replacingOccurrences(of: "\n", with: " ")
        }
    }
}

public extension DiscoveryVenue.Address {
    
    private enum CodingKeys: String, CodingKey  {
        case address
        case state
        case city
        case country
        case postalCode
    }
    
    private enum StateCodingKeys: String, CodingKey {
        case name
        case stateCode
    }
    
    private enum CountryCodingKeys: String, CodingKey {
        case name
        case countryCode
    }
    
    private enum CityCodingKeys: String, CodingKey {
        case name
    }
    
    private enum StreetCodingKeys: String, CodingKey {
        case line1
        case line2
        case line3
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DiscoveryVenue.Address.CodingKeys.self)
        
        let cityContainer = try container.nestedContainer(keyedBy: CityCodingKeys.self, forKey: .city)
        self.city = try cityContainer.decode(String.self, forKey: .name)
        
        let stateContainer = try container.nestedContainer(keyedBy: StateCodingKeys.self, forKey: .state)
        self.state = try stateContainer.decode(String.self, forKey: .stateCode)
        
        self.postalCode = try container.decode(String.self, forKey: .postalCode)
        
        let countryContainer = try container.nestedContainer(keyedBy: CountryCodingKeys.self, forKey: .country)
        self.country = try countryContainer.decode(String.self, forKey: .countryCode)
        
        let streetContainer = try container.nestedContainer(keyedBy: StreetCodingKeys.self, forKey: .address)
        
        let line1 = try streetContainer.decode(String.self, forKey: .line1)
        let line2 = try streetContainer.decodeIfPresent(String.self, forKey: .line2) ?? ""
        let line3 = try streetContainer.decodeIfPresent(String.self, forKey: .line2) ?? ""
        
        var street = line1
        if line2.isEmpty == false {
            street += "\n\(line2)"
        }
        
        if line3.isEmpty == false {
            street += "\n\(line3)"
        }
        
        self.street = street
    }
}
