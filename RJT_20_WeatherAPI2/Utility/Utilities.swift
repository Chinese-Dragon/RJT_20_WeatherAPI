//
//  Utilities.swift
//  RJT_20_WeatherAPI2
//
//  Created by Mark on 1/1/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import Foundation

import Foundation
import CoreLocation

extension CLPlacemark {
    
    var compactAddress: String? {
        var result = ""

        let city = locality != nil ? (locality! + ", ") : ""
        let state = administrativeArea != nil ? (administrativeArea! + " ") : ""
        let postoal = postalCode != nil ? (postalCode! + ", ") : ""
        let ctry = country != nil ? country! : ""
        
        result = city + state + postoal + ctry
        
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}
