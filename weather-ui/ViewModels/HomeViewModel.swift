import CoreLocation
import Foundation
import Combine

class HomeViewModel {
    private var apiService: WeatherService
    @Published var forecast: Forecast?
    @Published var error: String?
    
    init() {
        self.apiService = WeatherService()
    }
    
    public func fetchForecast(location: CLLocation) async {
        do {
            let myForecast = try await apiService.getForecast(location: location.coordinate)
            print("update forecast")
            self.forecast = myForecast
            self.error = nil
        } catch APIError.networkError {
            self.error = "Check your internet connection"
        } catch APIError.notValidLocationError {
            self.error = "Check your location"
        } catch {
            self.error = "A problem occurred"
        }
    }
}
