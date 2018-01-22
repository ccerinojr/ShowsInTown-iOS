//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation

/**
    A class that encapsulates the multiple date formatting options for
    for Ticketmaster.
 
    - Note: All formatting is done using the localized date templates
            via `setLocalizedDateFormatFromTemplate()`
            on `NSDateFormater`. Thus all formatted date
            strings do not guarentee anything in regards to visual
            appearance. `NSDateFormatter` picks the best format
            for the user's current locale.
 */

public class TMDateFormatter: NSObject {
    
    public enum TimeDescription {
        case specific
        case none
        case tba
    }
    
    /// A representation of a period of time in a given time zone.
    public struct DateRange: Equatable {
        let start: Date
        let end: Date
        let timeZone: TimeZone

        public init(start: Date, end: Date, timeZone: TimeZone) {
            self.start = start
            self.end = end
            self.timeZone = timeZone
        }
        
        public static func ==(lhs: DateRange, rhs: DateRange) -> Bool {
            let startDatesMatch = lhs.start == rhs.start
            let endDatesMatch = lhs.end == rhs.end
            let timeZonesMatch = lhs.timeZone == rhs.timeZone
            return startDatesMatch && endDatesMatch && timeZonesMatch
        }
    }
    

    /// The available date styles the formatter can produce.
    public indirect enum DateFormatStyle: Equatable {
        /**
            Used to format a single date. The default representation
            includes the following date components: `EEEMMMd`
         
            - Parameters:
                - date: The date to format.
                - timeZone: The time zone to represent the date in.
                - timeDescription: Describes how the time components should be interpreted.
         */
        case singleDay(date: Date, timeZone: TimeZone, timeDescription: TimeDescription)
        
        /**
            Used to format a period of time. The default representation
            includes the following date components: `EEEMMMd`. The resulting
            formatted string will appear as follows: `EEEMMMd - EEEMMMd`.
         
            - Parameters:
                - dateRange: The date period to format.
         */
        case dateRange(DateRange)
        
        /**
            An option that causes the formatter to return the
            following string: "Multiple Dates & Times".
        */
        case multiDate

        /**
            An option that causes the formatter to return the
            following string: "Date TBA".
        */
        case tba
        
        /**
         An option that causes the formatter to return the
         following string: "Date TBD".
         */
        case tbd

        public static func ==(lhs: DateFormatStyle, rhs: DateFormatStyle) -> Bool {
            switch (lhs, rhs) {
            case (let .singleDay(date1, timeZone1, options1), let .singleDay(date2, timeZone2, options2)):
                return date1 == date2 && timeZone1 == timeZone2 && options1 == options2
            case (let .dateRange(range1), let .dateRange(range2)):
                return range1 == range2
            case (.multiDate, .multiDate):
                return true
            case (.tba, .tba):
                return true
            case (.tbd, .tbd):
                return true

            default:
                return false
            }
        }
    }

//MARK: - Date String Methods
    
    /**
     Returns a formatted date string for the given date style using the default templates.
     
     - Parameter formatStyle: The date style to create a formatted date string for.
     
     - Returns: A formatted date string.
     */
    public func string(withFormatStyle formatStyle: DateFormatStyle) -> String {
        let templates = TMDateFormatter.defaultTemplates(for: formatStyle)
        return self.string(withFormatStyle: formatStyle, dateTemplate: templates.date, timeTemplate: templates.time)
    }
    
    /**
     Returns a formatted date string for the given date style using the given date template and default time template.
     
     - Parameter formatStyle: The date style to create a formatted date string for.
     - Parameter dateTemplate: The localized template used for displaying date information.
     
     - Returns: A formatted date string.
     */
    public func string(withFormatStyle formatStyle: DateFormatStyle, dateTemplate: String) -> String {
        let templates = TMDateFormatter.defaultTemplates(for: formatStyle)
        return self.string(withFormatStyle: formatStyle, dateTemplate: dateTemplate, timeTemplate: templates.time)
    }
    
    /**
         Returns a formatted date string for the given date style using the given templates.
         
         - Parameter formatStyle: The date style to create a formatted date string for.
         - Parameter dateTemplate: The localized template used for displaying date information.
         - Parameter timeTemplate: The localized template used for displaying time information.
         
         - Returns: A formatted date string.
     */
    public func string(withFormatStyle formatStyle: DateFormatStyle, dateTemplate: String, timeTemplate: String?) -> String {
        switch formatStyle {
        case .dateRange(let dateRange):
            
            var template = dateTemplate
            if let timeTemplate = timeTemplate {
                template += timeTemplate
            }
            
            let formatter = TMDateFormatter.dateIntervalFormatter
            formatter.timeZone = dateRange.timeZone
            formatter.dateTemplate = template
            
            return formatter.string(from: dateRange.start, to: dateRange.end)
        
        case .singleDay(let date, let timeZone, let timeDescription):
            
            var template = dateTemplate
            
            if let timeTemplate = timeTemplate, timeDescription == .specific {
                template += timeTemplate
            }
            
            var dateText = ""
            if template.isEmpty == false {
                let formatter = TMDateFormatter.dateFormatter
                formatter.timeZone = timeZone
                formatter.setLocalizedDateFormatFromTemplate(template)
                dateText = formatter.string(from: date)
            }
            
            if timeDescription == .tba && timeTemplate != nil {
                let tbaTime = NSLocalizedString("Time TBA", comment: "Time TBA")
                dateText = dateText.isEmpty ? tbaTime : "\(dateText) \(tbaTime)"
            }
            
            return dateText
            
        case .multiDate:
            return NSLocalizedString("Multiple Dates & Times", comment: "Multiple Dates & Times")
            
        case .tba:
            return NSLocalizedString("Date TBA", comment: "Date TBA")
        case .tbd:
            return NSLocalizedString("Date TBD", comment: "Date TBD")

        }
    }
    
    //MARK: - Private
    private static let timeComponets: [Calendar.Component] = [.hour, .minute, .second, .nanosecond]
    private static let defaultDateTemplate = "EEMMMd"
    private static let defaultTimeTemplate = "hmma"
    
    private static let dateFormatter = DateFormatter()
    
    private static func defaultTemplates(for formatStyle: DateFormatStyle) -> (date: String, time: String?) {
        switch formatStyle {
        case .dateRange:
            return (date: self.defaultDateTemplate, time: nil)
            
        case .singleDay(_, _, let timeDescription):
            let timeTemplate: String? = timeDescription == .specific ? self.defaultTimeTemplate : nil
            return (date: self.defaultDateTemplate, time: timeTemplate)
            
        default:
            return (date: self.defaultDateTemplate, time: self.defaultTimeTemplate)
        }
    }
    
    private static let dateIntervalFormatter: DateIntervalFormatter = {
        let formatter = DateIntervalFormatter()
        formatter.dateTemplate = "EEMMMd"
        return formatter
    }()
}


