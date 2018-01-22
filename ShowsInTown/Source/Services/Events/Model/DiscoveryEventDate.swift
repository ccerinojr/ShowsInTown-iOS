//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation

public extension DiscoveryEvent {
    public enum EventDate: Decodable {
        public enum TimeDescription {
            case specific
            case none
            case tba
        }

        case singleDay(date: Date, timeDescription: TimeDescription, timezone: TimeZone)
        case dateRange(start: Date, end: Date, timeDescription: TimeDescription, timezone: TimeZone)
        case tba
        case tbd
    }
}

public extension DiscoveryEvent.EventDate {
    
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.isLenient = true
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return dateFormatter
    }()
    
    private enum CodingKeys: String, CodingKey {
        case start
        case end
        case timeZone = "timezone"
    }
    
    private enum StartDateCodingKeys: String, CodingKey {
        case dateTime
        case dateTBD
        case dateTBA
        case timeTBA
        case noSpecificTime
    }
    
    private enum EndDateCodingKeys: String, CodingKey {
        case dateTime
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        guard let timeZoneIdentifier = try container.decodeIfPresent(String.self, forKey: .timeZone),
            let timeZone = TimeZone(identifier: timeZoneIdentifier) else {
                self = .tbd
                return
        }
        
        let startContainer = try container.nestedContainer(keyedBy: StartDateCodingKeys.self, forKey: .start)
        let dateTBD = try startContainer.decodeIfPresent(Bool.self, forKey: .dateTBD) ?? false
        let dateTBA = try startContainer.decodeIfPresent(Bool.self, forKey: .dateTBA) ?? false
        let timeTBA = try startContainer.decodeIfPresent(Bool.self, forKey: .timeTBA) ?? false
        let noSpecificTime = try startContainer.decodeIfPresent(Bool.self, forKey: .noSpecificTime) ?? false
        let startAsString = try startContainer.decodeIfPresent(String.self, forKey: .dateTime)
        
        if dateTBD {
            self = .tbd
        } else if dateTBA {
            self = .tba
        } else if let startAsString = startAsString,
            let start = DiscoveryEvent.EventDate.dateFormatter.date(from: startAsString) {
            
            let timeDescription: DiscoveryEvent.EventDate.TimeDescription
            if timeTBA {
                timeDescription = .tba
            } else if noSpecificTime {
                timeDescription = .none
            } else {
                timeDescription = .specific
            }
            
            if container.contains(.end) {
                let endContainer = try container.nestedContainer(keyedBy: EndDateCodingKeys.self, forKey: .end)
                
                if let endAsString = try endContainer.decodeIfPresent(String.self, forKey: .dateTime), let end = DiscoveryEvent.EventDate.dateFormatter.date(from: endAsString) {
                    self =  .dateRange(start: start, end: end, timeDescription: timeDescription, timezone: timeZone)
                } else {
                    self = .tbd
                }
                
                
            } else {
                self = .singleDay(date: start, timeDescription: timeDescription, timezone: timeZone)
            }
            
        } else {
            self = .tbd
        }
    }
}
