//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation

public extension TMDateFormatter.DateFormatStyle {
    
    init(eventDate: DiscoveryEvent.EventDate) {
        switch eventDate {
        case .tba:
            self = .tba
        case .tbd:
            self = .tbd
        case .dateRange(let start, let end, _, let timeZone):
            self = .dateRange(TMDateFormatter.DateRange(start: start, end: end, timeZone: timeZone))
        case .singleDay(let date, let timeDescription, let timeZone):
            self = .singleDay(date: date, timeZone: timeZone, timeDescription: TMDateFormatter.TimeDescription(eventTimeDescription: timeDescription))
        }
    }
}

private extension TMDateFormatter.TimeDescription {
    init(eventTimeDescription: DiscoveryEvent.EventDate.TimeDescription) {
        switch eventTimeDescription {
        case .none:
            self = .none
        case .specific:
            self = .specific
        case .tba:
            self = .tba
        }
    }
}
