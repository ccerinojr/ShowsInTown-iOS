//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import UIKit

class EventDetailsViewController: UITableViewController {

    var event: DiscoveryEvent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = .white
        self.tableView.contentInset.bottom = 16.0
        self.tableView.separatorStyle = .none
        
        if let addToCalendarController = AddToCalendarController(event: self.event, delegate: self) {
            self.addToCalendarController = addToCalendarController
            self.navigationItem.rightBarButtonItem = addToCalendarController.calendarButton
        }

        var sections = [TableViewSectionController]()
        sections.append(self.makeAttractionsSection(fromEvent: self.event))
        sections.append(contentsOf: self.makeVenueDetailsSections(fromEvent: self.event))

        self.routingTableController = RoutingTableViewController()
        self.routingTableController.tableView = self.tableView
        self.routingTableController.sections = sections
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == EventDetailsViewController.showAttractionDetailsSegueIdentifier else { return }
        guard let adp = segue.destination as? AttractionDetailsViewController, let attraction = sender as? Attraction else { return }
        adp.attraction = attraction
    }

    //MARK: - Private Variables
    
    fileprivate static let showAttractionDetailsSegueIdentifier = "showAttractionDetails"
    fileprivate var routingTableController: RoutingTableViewController!
    fileprivate let calendarManager = CalendarManager()
    fileprivate var addToCalendarController: AddToCalendarController?
}

//MARK: - AddToCalendarControllerDelegate

extension EventDetailsViewController: AddToCalendarControllerDelegate {
    func controller(_ controller: AddToCalendarController, requestedAlertControllerBePresented alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
    
    func controller(_ controller: AddToCalendarController, didUpdateCalendarButton button: UIBarButtonItem) {
        self.navigationItem.setRightBarButton(button, animated: true)
    }
}

//MARK: - Private Helpers

private extension EventDetailsViewController {
    
    func makeAttractionsSection(fromEvent event: DiscoveryEvent) -> TableViewSectionController {
        
        let attractions = Attraction.makeAttractions(from: event)
        
        let formatter = TMDateFormatter()
        let style = TMDateFormatter.DateFormatStyle(eventDate: self.event.date)
        let date = formatter.string(withFormatStyle: style, dateTemplate: "EEEEMMMMd", timeTemplate: nil)
        let time = formatter.string(withFormatStyle: style, dateTemplate: "", timeTemplate: "hmma")

        let subtitle: String
        if let venue = event.venues.first {
            subtitle = NSLocalizedString("\(time) at \(venue.name)", comment: "Attraction section subtitle")
        } else {
            subtitle = time
        }
        
        let header = (title: date, subtitle: subtitle)
        let attractionsSection = AttractionsSectionController(attractions: attractions, sectionHeader: header, tableView: self.tableView)
        attractionsSection.attractionSelectedHandler = { [unowned self] (attraction: Attraction) -> () in
            self.performSegue(withIdentifier: EventDetailsViewController.showAttractionDetailsSegueIdentifier, sender: attraction)
        }
        
        return attractionsSection
    }
    
    func makeVenueDetailsSections(fromEvent event: DiscoveryEvent) -> [TableViewSectionController] {
        var sections = [TableViewSectionController]()
        
        if let venue = event.venues.first {
            sections.append(VenueInfoSectionController(venue: venue, tableView: self.tableView))
            
            if venue.boxOfficeInfo.isEmpty == false {
                let notes = venue.boxOfficeInfo.map({ VenueNotesSectionController.Note(title: String(describing: $0), notes: $1) })
                sections.append(VenueNotesSectionController(title: NSLocalizedString("Box Office Information", comment: "Box Office Infromation"), notes: notes, tableView: self.tableView))
            }
            
            if venue.generalInfo.isEmpty == false {
                let notes = venue.generalInfo.map({ VenueNotesSectionController.Note(title: String(describing: $0), notes: $1) })
                sections.append(VenueNotesSectionController(title: NSLocalizedString("General Information", comment: "General Infromation"), notes: notes, tableView: self.tableView))
            }
        }
        
        return sections
    }
}

