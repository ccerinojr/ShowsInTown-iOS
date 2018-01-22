//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation

public protocol SystemTimeStyleProviderType {
    
    var uses24HourTimeStyle: Bool { get }
}

public struct SystemTimeStyleProvider: SystemTimeStyleProviderType {
   
    private static let timeStyleFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    public var uses24HourTimeStyle: Bool {
        var components = DateComponents()
        components.hour = 22
        
        if let testDate = Calendar.current.date(from: components) {
            let dateString = SystemTimeStyleProvider.timeStyleFormatter.string(from: testDate)
            
            return dateString[dateString.startIndex] == "2" && dateString[dateString.index(after: dateString.startIndex)] == "2"
        }
        
        return false
    }
}
