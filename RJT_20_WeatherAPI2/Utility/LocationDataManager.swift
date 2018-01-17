//
//  FileParser.swift
//  RJT_20_WeatherAPI2
//
//  Created by Mark on 12/31/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import Foundation
import CoreLocation

class LocationDataManager {
    static let shareInstance = LocationDataManager()
    
    // make a static var to allow global access of this locationData
    private var data = [String: CLLocationCoordinate2D]()
    private var geoData = [String: String]()   // e,g 60174: "St.Charles, IL, 60174, US"
    private init() {}
    
    typealias GetDeoDataCompletionHandler = () -> Void
    typealias ParseDataCompletionHandler = () -> Void
    // get only
    var locationData: [String: CLLocationCoordinate2D] {
        return data
    }
    
    var zipToAdressData: [String: String] {
        return geoData
    }
    
    func parse(completion: @escaping ParseDataCompletionHandler) {
        guard let url = Bundle.main.url(forResource: "locationData", withExtension: ".csv") else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let locationInfoArry = try String(contentsOf: url).split(separator: "\n")
                
                // parse each line into correct format
                for locationInfo in locationInfoArry {
                    let locationInfoComponents = locationInfo.split(separator: ",")
                    
                    guard let latitude = Double(locationInfoComponents[1].trimmingCharacters(in: .whitespacesAndNewlines)) else { return }
                    guard let longitude = Double(locationInfoComponents[2].trimmingCharacters(in: .whitespacesAndNewlines)) else { return }
                    
                    let zipCode = locationInfoComponents[0].trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    
                    // zipcode -> key, coordinate -> value
                    self.data[zipCode] = coordinate
                }

                completion()
            } catch let error {
                print(error.localizedDescription)
                completion()
            }
        }
    }
    
//    func getGeoData(completion: @escaping GetDeoDataCompletionHandler) {
//        let coder = CLGeocoder()
//        
//        for (zipcode, coordinate) in data {
//            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
//
//            coder.reverseGeocodeLocation(location) { (placeMarks, error) in
//                guard error == nil else { return }
//                guard let placeMark = placeMarks?.last else { return }
//                guard let address = placeMark.compactAddress else { return }
//                print(address)
//                self.geoData[zipcode] = address
//            }
//        }
//        
//        print("all finished")
//        completion()
//    }
}
