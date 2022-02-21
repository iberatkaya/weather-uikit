//
//  ViewController.swift
//  weather-ui
//
//  Created by Ibrahim Berat Kaya on 15.02.2022.
//

import CoreLocation
import UIKit
import Combine

class ViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var locationStatus: CLAuthorizationStatus?
    var location: CLLocation?
    private var forecastSub: AnyCancellable?
    private var errorSub: AnyCancellable?
    var viewModel = HomeViewModel()
    
    var textView: UILabel = {
        let uiLabel = UILabel()
        uiLabel.translatesAutoresizingMaskIntoConstraints = false
        uiLabel.numberOfLines = 999
        uiLabel.font = uiLabel.font.withSize(12)
        uiLabel.textAlignment = .center
        return uiLabel
    }()
    
    override func viewDidLoad() {
        locationManager.delegate = self
        view.backgroundColor = .white
        view.addSubview(textView)

        NSLayoutConstraint.activate([
            textView.heightAnchor.constraint(equalTo: view.heightAnchor),
            textView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        forecastSub = viewModel.$forecast.sink(receiveValue: { val in
            print("$forecast", val)
            DispatchQueue.main.async {
                self.textView.text = "\(val)"
            }
        })
        errorSub = viewModel.$error.sink(receiveValue: {err in
            print("err", err)
        })
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationStatus = manager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations[0]
        
        if let myLocs = location {
            if myLocs == loc {
                return
            }
        }
        
        location = loc
        
        Task {
            await viewModel.fetchForecast(location: loc)
        }
    }
    
    func getLocationInfo(coordinates location: CLLocation) async {
        do {
            // try await WeatherService.getPoint(location: location.coordinate)
        } catch {}
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
