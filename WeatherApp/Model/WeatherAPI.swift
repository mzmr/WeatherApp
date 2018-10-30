//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by Maciej on 22/10/2018.
//  Copyright © 2018 Maciej Znamirowski. All rights reserved.
//

import Foundation
import UIKit.UIImage

class WeatherAPI {
    
    func getLocationForecast(locationId: String, callback: @escaping (_: LocationForecast) -> Void) {
        let myUrl = URL(string: "https://www.metaweather.com/api/location/\(locationId)/")
        let urlSession = URLSession.shared
        
        
        if let url = myUrl {
            let dataTask = urlSession.dataTask(with: url, completionHandler: {
                (data, urlResponse, error) in
                
                if error != nil {
                    print("error [WeatherAPI->getLocationForecast()]: \(String(describing: error))")
                } else {
                    if let goodData = data {
                        do {
                            let jsonObject = try JSONSerialization.jsonObject(with: goodData, options: []) as? [String: Any]
                            let forecast = LocationForecast(data: jsonObject!)
                                callback(_:forecast)
                        } catch let err {
                            print("error2: \(err)")
                        }
                    }
                }
            })
            
            dataTask.resume()
        }
    }
    
}
