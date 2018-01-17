//
//  APIClient.swift
//  RJT_20_WeatherAPI2
//
//  Created by Mark on 1/1/18.
//  Copyright © 2018 Mark. All rights reserved.
//

import Foundation
import CoreLocation

struct APIClient {
    static let shareInstance = APIClient()
    private init() {}
    
    static let APIKey = "06305c03d0e3897b9366e6aba0e02a99"
    typealias resultHandler = (Weather?) -> ()
    
    static func callApiForWeatherInfo(with coordinate: CLLocationCoordinate2D, completion: @escaping resultHandler) {
        
        var weatherUrlComponents = URLComponents()
        weatherUrlComponents.scheme = "https"
        weatherUrlComponents.host = "api.darksky.net"
        weatherUrlComponents.path = "/forecast/\(APIKey)/\(coordinate.latitude),\(coordinate.longitude)"
        
        let queryItemExclude = URLQueryItem(name: "exclude", value: "[minutely,hourly,flags]")
        let queryItemUnits = URLQueryItem(name: "units", value: "si")
        
        weatherUrlComponents.queryItems = [queryItemExclude, queryItemUnits]
        let weatherUrl = weatherUrlComponents.url!
        
        URLSession.shared.dataTask(with: weatherUrl) { (data, response, error) in
            guard error == nil else { return }
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any],
                    let temp = (jsonResult["currently"] as? [String: Any])!["temperature"] as? Float,
                    let unixTime = (jsonResult["currently"] as? [String: Any])!["time"] as? Int,
                    let tempHigh = (((jsonResult["daily"] as? [String: Any])!["data"] as? [Any])![0] as? [String: Any])!["temperatureHigh"] as? Float,
                    let tempLow = (((jsonResult["daily"] as? [String: Any])!["data"] as? [Any])![0] as? [String: Any])!["temperatureLow"] as? Float,
                    let pressure = (jsonResult["currently"] as? [String: Any])!["pressure"] as? Float,
                    let humidity = (jsonResult["currently"] as? [String: Any])!["humidity"] as? Float,
                    let condition = (jsonResult["currently"] as? [String: Any])!["summary"] as? String {
                    
                    let dateStr = Date(timeIntervalSince1970: Double(unixTime)).description
                    let cityName = ""
                    
                    let weather = Weather(cityName: cityName,
                                          time: dateStr,
                                          temp: Int(temp),
                                          tempHigh: Int(tempHigh),
                                          tempLow: Int(tempLow),
                                          pressure: pressure,
                                          humidity: humidity,
                                          condition: Weather.Condition(rawValue: condition)!)
                    completion(weather)
                }
            
                // Swifty JSON
                //                let json = try JSON(data: data!)
                //                guard let cityName = json["name"].string else { return }
                //                guard let temp = json["main"]["temp"].float else { return }
                //                guard let pressure = json["main"]["pressure"].int else { return }
                //                guard let humidity = json["main"]["humidity"].int else { return }
                //                guard let description = json["weather"][0]["description"].string else { return }
                //
                //                let weather = Weather(cityName: cityName,
                //                                      temp: temp,
                //                                      pressure: pressure,
                //                                      humidity: humidity,
                //                                      condition: Weather.Condition(rawValue: description.capitalizingFirstLetter())!)
                //
                //                completion(weather)
                //
            } catch let error {
                print(error)
                completion(nil)
            }
        }.resume()
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
