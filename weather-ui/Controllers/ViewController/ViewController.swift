//
//  ViewController.swift
//  weather-ui
//
//  Created by Ibrahim Berat Kaya on 15.02.2022.
//

import Combine
import CoreLocation
import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, CLLocationManagerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = pages.firstIndex(of: viewController) {
            if index > 0 {
                return pages[index - 1]
            } else {
                return nil
            }
        }

        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = pages.firstIndex(of: viewController) {
            if index < pages.count - 1 {
                return pages[index + 1]
            } else {
                return nil
            }
        }

        return nil
    }
    
    let locationManager = CLLocationManager()
    var locationStatus: CLAuthorizationStatus?
    var location: CLLocation?
    private var forecastSub: AnyCancellable?
    private var errorSub: AnyCancellable?
    var viewModel = HomeViewModel()
    private var tableViewController = TableViewController()
    private var pages: [UIViewController] = []
    
    var forecaseDetailView: ForecaseDetailView = {
        let forecastView = ForecaseDetailView()
        forecastView.translatesAutoresizingMaskIntoConstraints = false
        return forecastView
    }()
    
    var pageViewController: UIPageViewController = {
        let pageView = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageView.view.translatesAutoresizingMaskIntoConstraints = false
        return pageView
    }()
    
    override func loadView() {
        super.loadView()
        view.addSubview(forecaseDetailView)
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)

        locationManager.delegate = self
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        pages = [tableViewController, UIViewController()]
        
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: true)
        
        NSLayoutConstraint.activate([
            forecaseDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            forecaseDetailView.heightAnchor.constraint(equalToConstant: 140),
            forecaseDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            forecaseDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            forecaseDetailView.bottomAnchor.constraint(equalTo: pageViewController.view.topAnchor),
            
            pageViewController.view.topAnchor.constraint(equalTo: forecaseDetailView.bottomAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        forecastSub = viewModel.$forecast.sink(receiveValue: { val in
            DispatchQueue.main.async {
                self.tableViewController.forecast = val
                self.forecaseDetailView.period = val?.periods.first
                self.forecaseDetailView.location = val?.point
                self.forecaseDetailView.setNeedsDisplay()
            }
        })
        
        errorSub = viewModel.$error.sink(receiveValue: { err in
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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
