//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation
import CoreLocation

class AppSettings {
    
    private enum Keys: String {
        case useAlternateLocation
        case alternateLatitude
        case alternateLongitude
    }
    
    static func initializeDefaults() {
        let defaults = [Keys.useAlternateLocation.rawValue: false]
        UserDefaults.standard.register(defaults: defaults)
    }
    
    var useAlertnateLocation: Bool {
        return UserDefaults.standard.bool(forKey: Keys.useAlternateLocation.rawValue)
    }
    
    var alternateLocation: CLLocation {
        var alternateLatitude = UserDefaults.standard.float(forKey: Keys.alternateLatitude.rawValue)
        alternateLatitude = alternateLatitude == 0 ? 41.4993 : alternateLatitude
        
        var alternateLongitude = UserDefaults.standard.float(forKey: Keys.alternateLongitude.rawValue)
        alternateLongitude = alternateLongitude == 0 ? -81.6944 : alternateLongitude
        
        return CLLocation(latitude: CLLocationDegrees(alternateLatitude), longitude: CLLocationDegrees(alternateLongitude))
    }
}
