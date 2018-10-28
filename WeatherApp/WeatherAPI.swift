//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by Maciej on 22/10/2018.
//  Copyright © 2018 Maciej Znamirowski. All rights reserved.
//

import Foundation

class WeatherAPI {
    
    var currentDayNumber = Int()
    var currentCityData = [String: Any]()
    var currentDayData = [String: Any]()
    
    func getLocationForecast(locationId: String, callback: ((_: LocationForecast) -> Void)) {
        let myUrl = URL(string: "https://www.metaweather.com/api/location/523920/") // warszawa
        let urlSession = URLSession.shared
        
        
        if let url = myUrl {
            let dataTask = urlSession.dataTask(with: url, completionHandler: {
                (data, urlResponse, error) in
                
                if error != nil {
                    
                } else {
                    if let goodData = data {
                        do {
                            let jsonObject = try JSONSerialization.jsonObject(with: goodData, options: []) as? [String: Any]
                            
                            
                            
                        } catch let err {
                            print("error: \(err)")
                        }
                    }
                }
            })
            
            dataTask.resume()
        }
    }
}
