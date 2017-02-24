//
//  RequestApi.swift
//  FuturePlatformsWeatherApp
//
//  Created by Laurent Meert on 23/02/17.
//  Copyright © 2017 Laurent Meert. All rights reserved.
//

import Foundation
import SwiftyJSON

class RequestApi {
    private struct ApiConstants {
        static let baseUrl = "http://api.openweathermap.org/data/2.5"
        static let currentWeather = "/weather?q="
        static let apiKey = "&APPID=305e8138d126c1e47b0cfd11f291cbb7"
        static let imageUrl = "http://openweathermap.org/img/w/"
    }
    
    func fetch(cityName : String, completion: @escaping (_ jsonForecasts : JSON) -> Void) {
        if let url = URL(string: "\(ApiConstants.baseUrl)\(ApiConstants.currentWeather)\(cityName)\(ApiConstants.apiKey)") {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error == nil && data != nil {
                    completion(JSON(data: data!))
                } else if error != nil {
                    print(error!)
                }
                if let httpResponse = response as? HTTPURLResponse {
                    print("========HTTP Response=======")
                    print("\(httpResponse.statusCode) :")
                    switch (httpResponse.statusCode) {
                    case 100..<200: print("Informational")
                    case 200..<300: print("Success")
                    case 300..<400: print("Redirection")
                    case 400..<500: print("Client Error")
                    case 500..<600: print("Server Error")
                    default:
                        break
                    }
                    print("============================")
                }
                
            }).resume()
        }
    }
    
    func fetchImageData(fromImageName name: String, completion: @escaping (_ data: Data) -> Void) {
        
        let finalUrlString = "\(ApiConstants.imageUrl)\(name).png"
        if let url = URL(string : finalUrlString) {
            do {
                let data = try Data(contentsOf: url)
                completion(data)
            } catch let error {
                print("Error fetching image data: \(error)")
            }
        }
    }
}
