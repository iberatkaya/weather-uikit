import CoreLocation
import Foundation

class HomeViewModel {
    private var apiService: WeatherService
    
    var onError: ((String) -> Void)?
    
    init() {
        self.apiService = WeatherService()
    }
    
    func loadContent(location: CLLocation) async {
        do {
            try await apiService.getPoint(location: location.coordinate)
        }
        catch APIError.networkError {
            onError?("Check your internet connection")
        }
        catch {
            onError?("A problem occurred")
        }
    }
}
