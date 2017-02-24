//
//  Alert.swift
//  FuturePlatformsWeatherApp
//
//  Created by Laurent Meert on 24/02/17.
//  Copyright © 2017 Laurent Meert. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    class func shouldEnableLocationServices(target : UIViewController) {
        let ac = UIAlertController(title: "Warning", message: "You did not enable location services, which is required for the app to work properly.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Settings", style: .default) { (action) in
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        target.present(ac, animated: true, completion: nil)
    }
    
    class func shouldAuthoriseLocationUsage(target : UIViewController) {
        let ac = UIAlertController(title: "Warning", message: "You did not authorise location services, which is required for the app to work properly.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Settings", style: .default) { (action) in
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        target.present(ac, animated: true, completion: nil)
    }
    
    class func didFailToConnectToNetwork(target : UIViewController) {
        let ac = UIAlertController(title: "Warning", message: "It seems you are offline. Please check your Wifi/Data connection and try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        target.present(ac, animated: true, completion: nil)

    }
}
