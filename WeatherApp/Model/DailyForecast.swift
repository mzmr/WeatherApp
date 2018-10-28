//
//  DailyForecast.swift
//  WeatherApp
//
//  Created by Student on 23/10/2018.
//  Copyright © 2018 Maciej Znamirowski. All rights reserved.
//

import Foundation

class DailyForecast {
    
    var stateAbbr = String()
    var conditions = String()
    var tempMin = String()
    var tempMax = String()
    var windSpeed = String()
    var airPressure = String()
    var date = String()
    var windDir = String()
    
    init(data: [String: Any]) {
        stateAbbr = paramToString(param: "weather_state_abbr", data: data)
        conditions = paramToString(param: "weather_state_name", data: data)
        
        tempMin = getRoundedValue(name: "min_temp", data: data)
        tempMax = getRoundedValue(name: "max_temp", data: data)
        windSpeed = getRoundedValue(name: "wind_speed", data: data)
        airPressure = getRoundedValue(name: "air_pressure", data: data)
        
        date = paramToString(param: "applicable_date", data: data)
        windDir = paramToString(param: "wind_direction", data: data)
    }
    
    private func getRoundedValue(name: String, data: [String: Any]) -> String {
        var theValue = paramToString(param: name, data: data)
        if let dotRange = theValue.range(of: ".") {
            theValue.removeSubrange(dotRange.lowerBound ..< theValue.endIndex)
        }
        return theValue
    }
    
    private func paramToString(param: String, data: [String: Any]) -> String {
        return "\(data[param]!)"
    }
}
