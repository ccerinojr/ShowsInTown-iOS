//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation
import CoreLocation
import Contacts

extension URL {
    init?(location: CLLocationCoordinate2D, query: String? = nil) {
        
        guard var components = URLComponents(string: "http://maps.apple.com") else { return nil }

        let locationValue = "\(location.latitude),\(location.longitude)"
        let queryItems: [URLQueryItem]
        if let query = query {
            
            queryItems = [URLQueryItem(name: "sll", value: locationValue), URLQueryItem(name:"q", value:query)]
            
        } else {
            queryItems = [URLQueryItem(name: "ll", value: locationValue)]
        }
        
        components.queryItems = queryItems
        
        guard let stringValue = components.url?.absoluteString else { return nil }
        
        self.init(string: stringValue)

    }
}
