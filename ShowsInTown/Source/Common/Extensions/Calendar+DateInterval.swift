//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation

extension Calendar {
    
    func dateIntervalForThisYear(start: Date = Date()) -> DateInterval? {
        guard let thisYear = Calendar.current.dateInterval(of: .year, for: start) else { return nil }
        return DateInterval(start: start , end: thisYear.end)
    }
    
    func dateIntervalForNumberOfWeeks(_ numberOfWeeks: Int, start: Date = Date(), includesWeekend: Bool = false) -> DateInterval? {
        guard let nWeeksAway = Calendar.current.date(byAdding: .weekOfYear, value: numberOfWeeks, to: start) else { return nil }
        guard includesWeekend else { return DateInterval(start: start, end: nWeeksAway) }
        
        guard  let nWeeksAwayWeekend = Calendar.current.nextWeekend(startingAfter: nWeeksAway) else { return nil }
        return DateInterval(start: start, end: nWeeksAwayWeekend.end)
    }
    
    func thisWeek() -> DateInterval? {
        
        //Bound weeks from Sunday through next Sunday
        
        let today = Date()
        var startOfTheWeek = Date()
        var interval = TimeInterval(0)
        
        let success = Calendar.current.dateInterval(of: .weekOfMonth, start: &startOfTheWeek, interval: &interval, for: today)
        guard success else { return nil }
        
        guard let endOfWeek = self.date(byAdding: .day, value: 1, to: startOfTheWeek.addingTimeInterval(interval)) else { return nil }

        return DateInterval(start: today, end: endOfWeek)
    }
}
