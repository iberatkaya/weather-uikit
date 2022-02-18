//
//  ViewController.swift
//  weather-ui
//
//  Created by Ibrahim Berat Kaya on 15.02.2022.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    var viewModel = HomeViewModel()
    let locationManager = CLLocationManager()
    var locationStatus: CLAuthorizationStatus?
    var location: CLLocation?
    
    override func viewDidLoad() {
        locationManager.delegate = self
        view.backgroundColor = .white
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationStatus = manager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations[0]
        
        if let myLocs = self.location {
            if myLocs == loc {
                return
            }
        }
        
        self.location = loc
        
        Task {
            await viewModel.loadContent(location: loc)
        }
    }
    
    func getLocationInfo(coordinates location: CLLocation) async {
        do {
            //try await WeatherService.getPoint(location: location.coordinate)
        } catch {}
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
