//
//  Location.swift
//  WeatherApp
//
//  Created by Maciej on 07/11/2018.
//  Copyright © 2018 Maciej Znamirowski. All rights reserved.
//

import Foundation

class Location {
    
    let name: String
    let lat: String
    let lon: String
    
    init(name: String, lat: String, lon: String) {
        self.name = name
        self.lat = lat
        self.lon = lon
    }

}
