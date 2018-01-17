//
//  ViewController.swift
//  RJT_20_WeatherAPI2
//
//  Created by Mark on 12/31/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit
import CoreLocation
import SVProgressHUD

class WeatherSearchController: UIViewController {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var miniTemp: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherTime: UILabel!
    
    var searchController: UISearchController!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearching()
        setupLocationService()
    }
}

private extension WeatherSearchController {
    func updateWeather(with weather: Weather) {
        print("update UI with\(weather)")
        icon.image = UIImage(named: weather.title)
        condition.text = weather.condition.rawValue
        maxTemp.text = "\(weather.tempHigh)°"
        miniTemp.text = "\(weather.tempLow)°"
        currentTemp.text = "\(weather.temp)°"
        cityName.text = weather.cityName
        weatherTime.text = weather.time
    }
    
    func setupLocationService() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
    }
    
    func setUpSearching() {
        // initialize searchResult Controller
        let searchResultVC = storyboard?.instantiateViewController(withIdentifier: "SearchResultController") as! SearchResultController
        
        // setup delegate for didSelectPlace
        searchResultVC.delegate = self
        
        // configure searchController
        searchController = UISearchController(searchResultsController: searchResultVC)
        searchController.searchResultsUpdater = searchResultVC
        searchController.dimsBackgroundDuringPresentation = true
        
        // Set this to false, since we want the search bar accessible at all times.
        searchController.hidesNavigationBarDuringPresentation = false
        
        // configure searchbar
        let searchBar = searchController.searchBar
        searchBar.sizeToFit()
        searchBar.keyboardType = .numberPad
        searchBar.placeholder = "Search by Zipcode..."
        
        // associated searchBar to navigationItem's title area
        navigationItem.titleView = searchBar
        
        // By default, the modal overlay will take up the entire screen, covering the search bar. definesPresentationContext limits the overlap area to just the View Controller’s frame instead of the whole Navigation Controller.
        definesPresentationContext = true
    }
    
    // MARK: fetchWeatherData with any coordinate and display to UI
    func fetchWeatherData(with coordinate: CLLocationCoordinate2D) {
        // fetch weather data
        SVProgressHUD.show()
        
        APIClient.callApiForWeatherInfo(with: coordinate) { (newWeather) in
            DispatchQueue.main.async {
                
                guard let weather = newWeather else { return }
                
                // fetchCityInfo with reverseGeoCoding
                self.fetchCityInfo(with: coordinate, for: weather)
            }
        }
    }
    
    func fetchCityInfo(with coordinate: CLLocationCoordinate2D, for weather: Weather) {
        let coder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        var currentWeather = weather
        coder.reverseGeocodeLocation(location) { (placeMarks, error) in
            SVProgressHUD.dismiss()
            guard error == nil else { return }
            guard let placeMark = placeMarks?.last else { return }
            currentWeather.cityName = placeMark.locality!
            
            // update UI with weather
            self.updateWeather(with: currentWeather)
        }
    }
}

extension WeatherSearchController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard currentLocation == nil else { return }
        
        if let newLocation = locations.last {
            currentLocation = newLocation
            print(newLocation.coordinate.latitude)
            print(newLocation.coordinate.longitude)
            fetchWeatherData(with: newLocation.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension WeatherSearchController: SearchResultControllerDelegate {
    func didSelectZipCodeWith(_ coordinate: CLLocationCoordinate2D) {
        fetchWeatherData(with: coordinate)
    }
}
