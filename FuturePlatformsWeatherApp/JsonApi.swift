//
//  JsonApi.swift
//  FuturePlatformsWeatherApp
//
//  Created by Laurent Meert on 23/02/17.
//  Copyright © 2017 Laurent Meert. All rights reserved.
//

import Foundation
import SwiftyJSON

class JsonApi {
    func forecastDidFetch(fromJson json : JSON, completion: @escaping (_ forecasts : Weather) -> Void) {
        
        var finalCityName = "no_name"
        var finalShortDescription = "no_desc"
        var finalLongDescription = "no_desc"
        var finalTemperature = 0.0
        var finalPressure = 0
        var finalHumidity = 0
        var finalIconName = "no_icon"
        var finalWindSpeed = 0.0
        var finalWindOrientation = 0
        
        if let cityName = json["name"].string {
            finalCityName = cityName
        }
        
        if let weatherObject = json["weather"].array?.first {
            
            if let shortDescription = weatherObject["main"].string {
                finalShortDescription = shortDescription
            }
            if let longDescription = weatherObject["description"].string {
                finalLongDescription = longDescription
            }
            if let iconName = weatherObject["icon"].string {
                finalIconName = iconName
            }
            
        }
        let mainObject = json["main"]
        if let temperature = mainObject["temp"].double {
            finalTemperature = temperature - 273.15
        }
        if let pressure = mainObject["pressure"].int {
            finalPressure = pressure
        }
        if let humidity = mainObject["humidity"].int {
            finalHumidity = humidity
        }
        
        let windObject = json["wind"]
        if let windSpeed = windObject["speed"].double {
            finalWindSpeed = windSpeed
        }
        if let windOrientation = windObject["deg"].int {
            finalWindOrientation = windOrientation
        }
        
        completion(Weather(cityName: finalCityName, shortDescription: finalShortDescription, longDescription: finalLongDescription, temperature: finalTemperature, pressure: finalPressure, humidity: finalHumidity, windSpeed: finalWindSpeed, windOrientation: finalWindOrientation, iconName: finalIconName))
    }
}
