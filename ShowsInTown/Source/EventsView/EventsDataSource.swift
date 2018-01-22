//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//
import Foundation
import PromiseKit
import CoreLocation

class EventsDataSource {
    
    struct EventGroup {
        
        enum DateRange {
            case today
            case thisYear
            case all
        }
        
        var title: String?
        let dateRange: DateRange
        var events: [DiscoveryEvent]
        
        init(title: String? = nil, dateRange: DateRange, events: [DiscoveryEvent] = []) {
            self.title = title
            self.dateRange = dateRange
            self.events = events
        }
    }
    
    let location: CLLocationCoordinate2D?
    let radius: CLLocationDistance

    private(set) var eventGroups = [EventGroup]()

    init(location: CLLocationCoordinate2D?, radius: CLLocationDistance = 100.0) {
        self.location = location
        self.radius = 100
    }

    func reload() -> Promise<[EventGroup]> {
        guard let location = self.location else { return Promise<[EventGroup]>(value: []) }
        
        typealias DateRangeToDateIntervalMapping = (dateRange: EventGroup.DateRange, dateInterval: DateInterval?)
        
        let datesToLoad: [DateRangeToDateIntervalMapping]
        let today = Date()
        if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today), let thisYear = Calendar.current.dateIntervalForThisYear(start: Calendar.current.startOfDay(for: tomorrow)) {
            datesToLoad = [(dateRange: .today, dateInterval: DateInterval(start: today, end: Calendar.current.startOfDay(for: tomorrow))), (dateRange: .thisYear, thisYear)]
        } else {
            datesToLoad = [(dateRange: .all, dateInterval: nil)]
        }
        
        let loadEvents: [Promise<EventGroup>] = datesToLoad.map { (mapping) in
            self.service.events(near: location, radius: self.radius, dateRange: mapping.dateInterval).then { (events) -> EventGroup in
                return EventGroup(dateRange: mapping.dateRange, events: events)
            }
        }

        return when(fulfilled: loadEvents).then { (eventGroups) -> [EventGroup] in

            let nonEmptyEventGroups = eventGroups.filter({ $0.events.isEmpty == false })
            let titledEventGroups = nonEmptyEventGroups.map { (eventGroup) -> EventGroup in
                var eventGroup = eventGroup

                let title: String?
                switch eventGroup.dateRange {
                case .today:
                    title = NSLocalizedString("Today", comment: "Today")
                case .thisYear where nonEmptyEventGroups.count == 1:
                    title = NSLocalizedString("Coming Soon", comment: "Coming Soon")
                case .thisYear:
                    title = NSLocalizedString("After That", comment: "After That")
                case .all:
                    title = nil
                }
                eventGroup.title = title

                return eventGroup
            }

            self.eventGroups = titledEventGroups
            return self.eventGroups
        }
    }
    
    fileprivate let service = EventsProvider(session: URLSession.shared)
}
