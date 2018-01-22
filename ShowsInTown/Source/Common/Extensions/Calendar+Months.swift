//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation

extension Calendar {
    
    func startOfMonth(for date: Date) -> Date? {
        let currentDateComponents = self.dateComponents([.year, .month], from: date)
        return self.date(from: currentDateComponents)
    }
    
    func dateByAddingMonths(_ monthsToAdd: Int, to date: Date) -> Date? {
        var months = DateComponents()
        months.month = monthsToAdd
        return self.date(byAdding: months, to: date)
    }
    
    func endOfMonth(for date: Date) -> Date? {
        
        guard let plusOneMonthDate = self.dateByAddingMonths(1, to: date) else { return nil }
        
        let plusOneMonthDateComponents = self.dateComponents([.year, .month], from: plusOneMonthDate)
        guard let endOfMonth = self.date(from: plusOneMonthDateComponents) else { return nil }
        
        return self.date(byAdding: .second, value: -1, to: endOfMonth)
    }
}
