//
//  Weather.swift
//  FuturePlatformsWeatherApp
//
//  Created by Laurent Meert on 23/02/17.
//  Copyright © 2017 Laurent Meert. All rights reserved.
//

import Foundation

class Weather {
    private var cityName : String
    private var shortDescription : String
    private var longDescription : String
    private var temperature : Double
    private var pressure : Int
    private var humidity : Int
    private var windSpeed : Double
    private var windOrientation : Int
    private var iconName : String
    
    init(cityName : String, shortDescription : String, longDescription : String, temperature : Double, pressure : Int, humidity : Int, windSpeed : Double, windOrientation : Int, iconName : String) {
        self.cityName = cityName
        self.shortDescription = shortDescription
        self.longDescription = longDescription
        self.temperature = temperature
        self.pressure = pressure
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.windOrientation = windOrientation
        self.iconName = iconName
    }
    
    func getCityName() -> String {
        return self.cityName
    }
    func getShortDescription() -> String {
        return self.shortDescription
    }
    func getLongDescription() -> String {
        return self.longDescription
    }
    func getTemperature() -> Double {
        return self.temperature
    }
    func getPressure() -> Int {
        return self.getPressure()
    }
    func getHumidity() -> Int {
        return self.humidity
    }
    func getWindSpeed() -> Double {
        return self.windSpeed
    }
    func getWindOrientation() -> Int {
        return self.windOrientation
    }
    func getWindDirection() -> String {
        return self.convertDegreesNorthToCardinalDirection(degrees: self.windOrientation)
    }
    func getIconName() -> String {
        return self.iconName
    }
    
    private func convertDegreesNorthToCardinalDirection(degrees: Int) -> String {
        
        let cardinals: [String] = [ "North",
                                    "Northeast",
                                    "East",
                                    "Southeast",
                                    "South",
                                    "Southwest",
                                    "West",
                                    "Northwest",
                                    "North" ]
        
        let index = Int(round(Double(degrees).truncatingRemainder(dividingBy: 360) / 45))
        
        return cardinals[index]
        
    }
}
