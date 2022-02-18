import CoreLocation
import SwiftyJSON

class WeatherService {
    
    func getPoint(location coordinates: CLLocationCoordinate2D) async throws {
        do {
            let url = URLs.pointUrl(coordinates.latitude, coordinates.longitude)
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("com.kaya.weather", forHTTPHeaderField: "User-Agent")

            let (data, _) = try await URLSession.shared.data(from: url)
            
            let jsonData = JSON(data)
            print(jsonData)
        } catch {
            throw APIError.networkError
        }
    }
}
