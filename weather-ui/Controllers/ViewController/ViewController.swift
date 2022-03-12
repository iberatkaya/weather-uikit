//
//  ViewController.swift
//  weather-ui
//
//  Created by Ibrahim Berat Kaya on 15.02.2022.
//

import Combine
import CoreLocation
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var locationStatus: CLAuthorizationStatus?
    var location: CLLocation?
    private var forecastSub: AnyCancellable?
    private var errorSub: AnyCancellable?
    var viewModel = HomeViewModel()
    
    var tableView: UITableView = {
        var table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    var forecaseDetailView: ForecaseDetailView = {
        let forecastView = ForecaseDetailView()
        forecastView.translatesAutoresizingMaskIntoConstraints = false
        return forecastView
    }()
    
    override func loadView() {
        super.loadView()
        view.addSubview(forecaseDetailView)
        view.addSubview(tableView)

        locationManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        tableView.register(ForecaseCellView.self, forCellReuseIdentifier: "periodCell")

        NSLayoutConstraint.activate([
            forecaseDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            forecaseDetailView.heightAnchor.constraint(equalToConstant: 140),
            forecaseDetailView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -8),
            forecaseDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            forecaseDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        forecastSub = viewModel.$forecast.sink(receiveValue: { val in
            DispatchQueue.main.async {
                print(val)
                self.tableView.reloadData()
                self.forecaseDetailView.period = val?.periods.first
                self.forecaseDetailView.location = val?.point
                self.forecaseDetailView.setNeedsDisplay()
            }
        })
        
        errorSub = viewModel.$error.sink(receiveValue: { err in
            print("err", err)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let forecast = viewModel.forecast {
            return forecast.periods.count - 1
        }
        return 0
    }

    // Provide a cell object for each row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "periodCell", for: indexPath) as! ForecaseCellView
        
        cell.period = self.viewModel.forecast?.periods[indexPath.item]
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
