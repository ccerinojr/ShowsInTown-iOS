//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation
import EventKit
import PromiseKit
import Contacts

class CalendarManager: NSObject {
    
    enum CalendarManagerError: Error {
        case unauthorized
    }
    
    enum AddEventError: Error {
        case unableToAddEvent
        case eventAlreadyAdded
        case insufficientDateInformation
        case noDefaultCalendar
    }

    enum RemoveEventError: Error {
        case unableToRemoveEvent
    }
    
    func eventExistsInDefaultCalendar(_ event: DiscoveryEvent) -> Bool {
        guard self.calendarEvent(forEvent: event) != nil else {
            self.identifierCache.removeCalendarEventIdentifier(forEventIdentifier: event.identifier)
            return false
        }
        
        return true
    }
    
    func eventCanBeSaveToCalendar(_ event: DiscoveryEvent) -> Bool {
        return self.makeDateInterval(fromEvent: event) != nil
    }
    
    func addEventToDefaultCalendar(event: DiscoveryEvent) -> Promise<Void> {
        return self.requestAccessToDefaultCalendar().then { () -> () in
            guard self.eventExistsInDefaultCalendar(event) == false else { throw AddEventError.eventAlreadyAdded }
            guard let defaultCalendar = self.store.defaultCalendarForNewEvents else { throw AddEventError.noDefaultCalendar }
            try self.add(event, to: defaultCalendar)
        }
    }
    
    func removeEventFromDefaultCalendar(event: DiscoveryEvent) -> Promise<Void> {
        return self.requestAccessToDefaultCalendar().then { () -> () in
            guard let calendarEvent = self.calendarEvent(forEvent: event) else {
                self.identifierCache.removeCalendarEventIdentifier(forEventIdentifier: event.identifier)
                throw RemoveEventError.unableToRemoveEvent
            }
            
            do {
                try self.store.remove(calendarEvent, span: .thisEvent)
                self.identifierCache.removeCalendarEventIdentifier(forEventIdentifier: event.identifier)
            } catch {
                self.identifierCache.removeCalendarEventIdentifier(forEventIdentifier: event.identifier)
                throw RemoveEventError.unableToRemoveEvent
            }
        }
    }
    
    //MARK: Private variables
    
    private let store = EKEventStore()
    private let identifierCache = CalendarEventIdentifierCache()
    
}

private extension CalendarManager {
    
    func calendarEvent(forEvent event: DiscoveryEvent) -> EKEvent? {
        guard let calendarEventIdentifier = self.identifierCache.calendarEventIdentifier(forEventIdentifier: event.identifier) else { return nil }
        return self.store.event(withIdentifier: calendarEventIdentifier)
    }
    
    func requestAccessToDefaultCalendar() -> Promise<Void> {
        
        let pendingPromise = Promise<Void>.pending()
        
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch status {
        case .notDetermined:
            self.store.requestAccess(to: EKEntityType.event, completion: { (allowed, nil) in
                if allowed {
                    pendingPromise.fulfill(())
                } else {
                    pendingPromise.reject(CalendarManagerError.unauthorized)
                }
            })
        case .restricted, .denied:
            pendingPromise.reject(CalendarManagerError.unauthorized)
            return pendingPromise.promise
            
        case .authorized:
            pendingPromise.fulfill(())
            break
        }
        
        return pendingPromise.promise
    }
    
    func add(_ event: DiscoveryEvent, to calendar: EKCalendar) throws {
        guard let dateInformation = self.makeDateInterval(fromEvent: event) else { throw AddEventError.insufficientDateInformation }
        
        let calendarEvent = EKEvent(eventStore: store)
        calendarEvent.calendar = calendar
        calendarEvent.title = event.name
        calendarEvent.startDate = dateInformation.interval.start
        calendarEvent.endDate = dateInformation.interval.end
        calendarEvent.timeZone = dateInformation.timeZone
        
        if let venue = event.venues.first {
            let addressText = venue.address.makeSingleLineAddressText()
            calendarEvent.location = "\(venue.name) \n \(addressText)"
        }
        
        do {
            try store.save(calendarEvent, span: .thisEvent, commit: true)
            self.identifierCache.save(calendarEventIdentifier: calendarEvent.eventIdentifier, forEventIdentifier: event.identifier)
            
        } catch {
            throw AddEventError.unableToAddEvent
        }
    }
    
    func makeDateInterval(fromEvent event: DiscoveryEvent) -> (interval: DateInterval, timeZone: TimeZone)? {
        switch event.date {

        case let .singleDay(startDate, timeDescription, timeZone) where timeDescription == .specific:
            let endDate: Date
            if let nextDay = NSCalendar.current.date(byAdding: .day, value: 1, to: startDate) {
                endDate = NSCalendar.current.startOfDay(for: nextDay)
            } else {
                endDate = startDate
            }
            
            return (interval: DateInterval(start: startDate, end: endDate), timeZone: timeZone)
        
        case let .dateRange(startDate, endDate, timeDescription, timeZone) where timeDescription == .specific:
            return (interval: DateInterval(start: startDate, end: endDate), timeZone: timeZone)
        
        default:
            return nil
        }
    }
}
