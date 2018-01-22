//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation

class CalendarEventIdentifierCache {
 
    func calendarEventIdentifier(forEventIdentifier identifier: String) -> String? {
       return self.calendarEventIdentifiers[identifier]
    }
    
    func removeCalendarEventIdentifier(forEventIdentifier identifier: String) {
        self.calendarEventIdentifiers[identifier] = nil
    }
    
    func save(calendarEventIdentifier: String, forEventIdentifier eventIdentifier: String) {
        self.calendarEventIdentifiers[eventIdentifier] = calendarEventIdentifier
    }
    
    private static let calendarEventIdentifiersByDiscoveryIdentifiersKey = "calendarEventIdentifiersByDiscoveryIdentifiersKey"
    private var calendarEventIdentifiers: [String: String] {
        
        get {
            return UserDefaults.standard.object(forKey: CalendarEventIdentifierCache.calendarEventIdentifiersByDiscoveryIdentifiersKey) as? [String: String] ?? [:]
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: CalendarEventIdentifierCache.calendarEventIdentifiersByDiscoveryIdentifiersKey)
        }
        
    }
}
