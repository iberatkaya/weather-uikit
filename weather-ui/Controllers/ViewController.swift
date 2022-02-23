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
    
    var titleTextView: UILabel = {
        let uiLabel = UILabel()
        uiLabel.translatesAutoresizingMaskIntoConstraints = false
        uiLabel.numberOfLines = 999
        uiLabel.font = uiLabel.font.withSize(16)
        uiLabel.textAlignment = .center
        uiLabel.backgroundColor = UIColor(red: 230/255, green: 220/255, blue: 255/255, alpha: 1)
        return uiLabel
    }()
    
    override func loadView() {
        super.loadView()
        locationManager.delegate = self
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(titleTextView)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "periodCell")

        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleTextView.heightAnchor.constraint(equalToConstant: 240),
            titleTextView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -8),
            titleTextView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        forecastSub = viewModel.$forecast.sink(receiveValue: { val in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.titleTextView.text = val?.periods.first?.description
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "periodCell", for: indexPath)
       
        // Configure the cell’s contents.
        var content = cell.defaultContentConfiguration()
        content.text = self.viewModel.forecast?.periods[indexPath.row + 1].description
        content.textProperties.color = .black
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
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
