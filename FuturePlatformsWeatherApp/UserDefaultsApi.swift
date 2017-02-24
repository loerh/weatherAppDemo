//
//  UserDefaultsApi.swift
//  FuturePlatformsWeatherApp
//
//  Created by Laurent Meert on 24/02/17.
//  Copyright © 2017 Laurent Meert. All rights reserved.
//

import Foundation


class UserDefaultsApi {
    
    private struct UserDefaultsApiConstants {
        static let nameKey = "name"
        static let shortDescKey = "shortDesc"
        static let longDescKey = "longDesc"
        static let tempKey = "temp"
        static let pressureKey = "pressure"
        static let humidityKey = "humidity"
        static let windSpeedKey = "windSpeed"
        static let windOrientationKey = "windOrientation"
        static let iconNameKey = "iconName"
    }
    
    // fetching current backup of last remote api request (if existing)
    func getBackup() -> Weather? {
        let defaults = UserDefaults.standard
        if let name = defaults.string(forKey: UserDefaultsApiConstants.nameKey),
            let shortDesc = defaults.string(forKey: UserDefaultsApiConstants.shortDescKey),
            let iconName = defaults.string(forKey: UserDefaultsApiConstants.iconNameKey) {
            let temperature = defaults.double(forKey: UserDefaultsApiConstants.tempKey)
            let windSpeed = defaults.double(forKey: UserDefaultsApiConstants.windSpeedKey)
            let windOrientation = defaults.integer(forKey: UserDefaultsApiConstants.windOrientationKey)
            return Weather(cityName: name, shortDescription: shortDesc, longDescription: "N/A", temperature: temperature, pressure: 0, humidity: 0, windSpeed: windSpeed, windOrientation: windOrientation, iconName: iconName)
        }
        return nil
    }
    
    // updating or creating new backup of latest remote api request 
    func updateBackup(weather : Weather) {
        
        let defaults = UserDefaults.standard
        defaults.set(weather.getCityName(), forKey: UserDefaultsApiConstants.nameKey)
        defaults.set(weather.getShortDescription(), forKey: UserDefaultsApiConstants.shortDescKey)
        defaults.set(weather.getIconName(), forKey: UserDefaultsApiConstants.iconNameKey)
        defaults.set(weather.getTemperature(), forKey: UserDefaultsApiConstants.tempKey)
        defaults.set(weather.getWindSpeed(), forKey: UserDefaultsApiConstants.windSpeedKey)
        defaults.set(weather.getWindOrientation(), forKey: UserDefaultsApiConstants.windOrientationKey)
        
        UserDefaults.standard.synchronize()
        print("UserDefaults UPDATED")
    }
    
}
