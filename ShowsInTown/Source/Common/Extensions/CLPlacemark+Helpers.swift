//
//  CLPlacemark+Helpers.swift
//  FruitLoops
//
//  Created by Carmen Cerino on 1/11/17.
//  Copyright © 2017 Soundcheck. All rights reserved.
//

import Foundation
import CoreLocation

extension CLPlacemark {
    
    var cityStateText: String? {
        guard let state = self.administrativeArea, let city = self.locality else {
            return nil
        }
        
        return "\(city), \(state)"
    }
}
