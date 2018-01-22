//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation

struct EventViewModel {
    let mainAttraction: String
    let openingAttractions: String
    let dateText: String
    let venueName: String?
    let images: [DiscoveryRemoteImage]
    
    init(event: DiscoveryEvent) {
        
        if let mainAttraction = event.attractions.first {
            
            self.mainAttraction = mainAttraction.name
            var otherAttractions = event.attractions
            otherAttractions.removeFirst()
            
            let otherAttractionsText: String
            if otherAttractions.count > 0 {
                otherAttractionsText = otherAttractions.map{ $0.name }.joined(separator: ", ")
                self.openingAttractions = NSLocalizedString("with \(otherAttractionsText)", comment: "Opening attractions subtitle")
            } else {
                self.openingAttractions = otherAttractions.map{ $0.name }.joined(separator: ", ")
            }
            
            self.images = mainAttraction.images
            
        } else {
            self.mainAttraction = event.name
            self.images = event.images
            self.openingAttractions = ""
        }
        
        
        let formatter = TMDateFormatter()
        let style = TMDateFormatter.DateFormatStyle(eventDate: event.date)
        
        var format: String = "MMMd"
        if let thisWeek = Calendar.current.thisWeek() {
            switch event.date {
            case .singleDay(let date, _, _), .dateRange(let date, _, _, _):
                format = thisWeek.contains(date) ? "EEE" : format
            default:
                break
            }
        }
        
        self.dateText = formatter.string(withFormatStyle: style, dateTemplate: format).localizedUppercase
        
        self.venueName = event.venues.first?.name
    }
}
