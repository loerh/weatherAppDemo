//
//  ViewController.swift
//  FuturePlatformsWeatherApp
//
//  Created by Laurent Meert on 23/02/17.
//  Copyright © 2017 Laurent Meert. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    
    //MARK: IBOUTLETS
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    
    @IBOutlet weak var upperStackView: UIStackView!
    @IBOutlet weak var lowerStackView: UIStackView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIButton!
    
    //MARK: IBACTIONS
    
    @IBAction func refreshData() {
        self.shouldFetch()
    }
    
    //MARK: VARS
    
    private lazy var locationManager = CLLocationManager()
    private var cityName : String!
    private lazy var userDefaultsApi = UserDefaultsApi()
    
    //MARK: CORE FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [UIColor.colorWithHexString("#001199"), UIColor.colorWithHexString("#004586")]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.view.layer.insertSublayer(gradient, at: 0)
        
        self.shouldFetch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (!Reachability.isConnectedToNetwork()) {
            Alert.didFailToConnectToNetwork(target: self)
        }
    }
    
    //MARK: OTHER FUNCTIONS
    
    private func shouldFetch() {
        self.prepareUiBeforeFetch()
        if (Reachability.isConnectedToNetwork()) {
            self.checkCoreLocation()
        } else {
            if self.view.window != nil { Alert.didFailToConnectToNetwork(target: self) }
            // Checking if previous existing record in UserDefaults
            if let backupWeather = self.userDefaultsApi.getBackup() {
                self.setContent(weather: backupWeather, data: nil)
            }
            self.prepareUiAfterFetch()
        }
    }
    
    //MARK: UI FUNCTIONS
    
    private func setContent(weather : Weather, data : Data?) {
        self.cityLabel.text = weather.getCityName()
        if (data != nil) { self.conditionImageView.image = UIImage(data: data!) }
        self.conditionLabel.text = weather.getShortDescription()
        self.temperatureLabel.text = "\(String(format: "%.1f", weather.getTemperature())) °C"
        self.windSpeedLabel.text = "\(weather.getWindSpeed()) Kph"
        self.windDirectionLabel.text = weather.getWindDirection()
    }
    
    private func prepareUiBeforeFetch() {
        self.refreshButton.isHidden = true
        self.upperStackView.isHidden = true
        self.lowerStackView.isHidden = true
        self.activityIndicator.startAnimating()
    }
    
    private func prepareUiAfterFetch() {
        self.refreshButton.isHidden = false
        self.upperStackView.isHidden = false
        self.lowerStackView.isHidden = false
        self.activityIndicator.stopAnimating()
    }
    
    //MARK: FETCH FUNCTIONS
    
    private func fetchData(cityName : String) {
        
        //Fetching data using the request api
        let requestApi = RequestApi()
        requestApi.fetch(cityName: cityName) { (json) in
            
            // Transform json into a "Weather" object
            let jsonApi = JsonApi()
            jsonApi.forecastDidFetch(fromJson: json) { (weather) in
                
                //Storing fetched info in UserDefaults
                self.userDefaultsApi.updateBackup(weather: weather)
                
                requestApi.fetchImageData(fromImageName: weather.getIconName()) { (data) in
                    
                    //Going back to main queue before updating UI
                    DispatchQueue.main.async {
                        self.setContent(weather: weather, data: data)
                        self.prepareUiAfterFetch()
                    }
                }
            }
        }
    }
    
    //MARK: CORE LOCATION FUNCTIONS
    
    private func checkCoreLocation() {
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
                self.locationManager.startUpdatingLocation()
            } else {
                Alert.shouldEnableLocationServices(target: self)
            }
        } else {
            Alert.shouldAuthoriseLocationUsage(target: self)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            if (location.horizontalAccuracy <= manager.desiredAccuracy) {
                self.getCityNameFromCoordinate(coordinate: location.coordinate) { cityName in
                    self.fetchData(cityName: cityName)
                }
                self.locationManager.stopUpdatingLocation()
                self.locationManager.delegate = nil
            }
        }
    }
    
    private func getCityNameFromCoordinate(coordinate : CLLocationCoordinate2D, completion: @escaping (_ cityName : String) -> Void) {
        let geocoder = CLGeocoder();
        let currentLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude);
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?.first, let locality = placemark.locality {
                    completion(locality)
                }
            } else {
                print("Error reversing with geocoder: \(error!)")
            }
        }
    }
}

