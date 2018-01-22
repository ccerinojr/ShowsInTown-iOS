//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

protocol AddToCalendarControllerDelegate: class {
    func controller(_ controller:AddToCalendarController, requestedAlertControllerBePresented alertController: UIAlertController)
    func controller(_ controller: AddToCalendarController, didUpdateCalendarButton button: UIBarButtonItem)
}

class AddToCalendarController: NSObject {
    
    private(set) lazy var calendarButton: UIBarButtonItem = {
        return self.calendar.eventExistsInDefaultCalendar(self.event) ? self.removeFromCalendarButton : self.addToCalendarButton
    }()
    
    var shouldShowAddToCalendarButton: Bool {
        return self.calendar.eventCanBeSaveToCalendar(self.event)
    }
    
    init?(event: DiscoveryEvent, delegate: AddToCalendarControllerDelegate) {
        let calendar = CalendarManager()
        
        guard calendar.eventCanBeSaveToCalendar(event) else { return nil }
        
        self.event = event
        self.calendar = calendar
        self.delegate = delegate
    }
    
    @objc func addEventToCalendar() {
        
        let addAction = UIAlertAction(title: NSLocalizedString("Add", comment: "Add"), style: .default) { (_) in
            self.calendar.addEventToDefaultCalendar(event: self.event).then { () -> () in
                let title = NSLocalizedString("Event Saved", comment: "Event Saved")
                let message = NSLocalizedString("Successfully saved \(self.event.name) to calendar", comment: "Successfully saved event to calendar")
                
                let action = UIAlertAction.okayAction({ (_) in
                    self.updateCalendarButtonForCurrentState()
                })
                
                self.showAlertWith(title: title, message: message, actions: [action])
                
            }.catch { (error) in
                
                 if let error = error as? CalendarManager.CalendarManagerError, error == .unauthorized {
                    
                    let title = NSLocalizedString("Calendar Access Required", comment: "Calendar Access Required")
                    let message = NSLocalizedString("ShowsInTown needs permission to access your calendar to add events", comment: "Error message for when the application has been denied access to the calendar")
                    self.showAlertWith(title: title, message: message, actions: [UIAlertAction.okayAction()])
                
                 } else if let error = error as? CalendarManager.AddEventError {
                 
                    let title: String
                    let message: String
                    var action = UIAlertAction.okayAction()
                    
                    switch error {
                    case .eventAlreadyAdded:
                        title = NSLocalizedString("Event Already Added", comment: "Event Already Added")
                        message = NSLocalizedString("There is an event for \"\(self.event.name)\" already in your calendar", comment: "Error message for when an event already exists in the user's calendar")
                        action = UIAlertAction.okayAction({ (_) in
                            self.updateCalendarButtonForCurrentState()
                        })
                        
                    case .unableToAddEvent, .insufficientDateInformation:
                        title = NSLocalizedString("Failed to Add Event", comment: "Failed to Add Event")
                        message = NSLocalizedString("We were unable to add the event to your calendar", comment: "Error message for when the app fails to add an event to the user's calendar")
                        
                    case .noDefaultCalendar:
                        title = NSLocalizedString("No Calendars", comment: "No Calendar")
                        message = NSLocalizedString("There are no calendars available to add events to", comment: "Error message for when there are no calendars available")
                    }
                    
                    self.showAlertWith(title: title, message: message, actions: [action])
                    
                } else {
                    let title = NSLocalizedString("Failed to Add Event", comment: "Failed to Add Event")
                    let message = NSLocalizedString("We were unable to add the event to your calendar", comment: "Error message for when the app fails to add an event to the user's calendar")
                    self.showAlertWith(title: title, message: message, actions: [UIAlertAction.okayAction()])
                }
            }
        }
        
        
        let title = NSLocalizedString("Add Event to Calendar", comment: "Add Event to Calendar")
        let message = NSLocalizedString("Add \(event.name) to Calendar", comment: "Add event to Calendar")
        self.showAlertWith(title: title, message: message, actions: [addAction, UIAlertAction.cancelAction()])
    }

    @objc func removeEventFromCalendar() {
        
        let addAction = UIAlertAction(title: NSLocalizedString("Remove", comment: "Remove"), style: .destructive) { (_) in
            
            self.calendar.removeEventFromDefaultCalendar(event: self.event).then { () -> () in
                let title = NSLocalizedString("Event Removed", comment: "Event Removed")
                let message = NSLocalizedString("Successfully removed \(self.event.name) from your calendar", comment: "Successfully removed event from the calendar")
                
                let action = UIAlertAction.okayAction({ (_) in
                    self.updateCalendarButtonForCurrentState()
                })
                
                self.showAlertWith(title: title, message: message, actions: [action])
                
            }.catch { (error) in
                
                if let error = error as? CalendarManager.CalendarManagerError, error == .unauthorized {
                    let title = NSLocalizedString("Calendar Access Required", comment: "Calendar Access Required")
                    let message = NSLocalizedString("ShowsInTown needs permission to access your calendar to remove events", comment: "Error message for when the application has been denied access to the calendar")
                    self.showAlertWith(title: title, message: message, actions: [UIAlertAction.okayAction()])
                    
                } else {
                    let title = NSLocalizedString("Failed to Properly Remove Event", comment: "Failed to Remove Event")
                    let message = NSLocalizedString("We were unable to properly remove the event from your calendar. ShowsInTown is no longer tracking the event in your calendar, but the event may still be there. Please check your calendar and manually remove the event if it still exists.", comment: "Error message for when the app fails to remove an event from the user's calendar")
                    let action = UIAlertAction.okayAction({ (_) in
                        self.updateCalendarButtonForCurrentState()
                    })
                    
                    self.showAlertWith(title: title, message: message, actions: [action])
                }
            }
        }
        
        
        let title = NSLocalizedString("Remove Event from Calendar", comment: "Remove Event from Calendar")
        let message = NSLocalizedString("Remove \(event.name) from Calendar", comment: "Remove event from Calendar")
        self.showAlertWith(title: title, message: message, actions: [addAction, UIAlertAction.cancelAction()])
    }
    
    //MARK: - Private
    
    private let event: DiscoveryEvent
    private let calendar: CalendarManager
    private weak var delegate: AddToCalendarControllerDelegate?
    
    private(set) lazy var addToCalendarButton: UIBarButtonItem = {
        return UIBarButtonItem(title: NSLocalizedString("Add to Calendar", comment: "Add to Calendar"), style: .plain, target: self, action: #selector(AddToCalendarController.addEventToCalendar))
    }()
    
    private(set) lazy var removeFromCalendarButton: UIBarButtonItem = {
        return UIBarButtonItem(title: NSLocalizedString("Remove from Calendar", comment: "Add from Calendar"), style: .plain, target: self, action: #selector(AddToCalendarController.removeEventFromCalendar))
    }()
    
    private func showAlertWith(title: String, message: String, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach({alertController.addAction($0)})
        self.delegate?.controller(self, requestedAlertControllerBePresented: alertController)
    }
    
    func updateCalendarButtonForCurrentState() {
        self.calendarButton = self.calendar.eventExistsInDefaultCalendar(self.event) ? self.removeFromCalendarButton : self.addToCalendarButton
        self.delegate?.controller(self, didUpdateCalendarButton: self.calendarButton)
    }
}
