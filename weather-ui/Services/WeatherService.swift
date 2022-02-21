import CoreLocation
import SwiftyJSON

class WeatherService {
    func getPoint(location coordinates: CLLocationCoordinate2D) async throws -> Point {
        let pointUrl = URLs.pointUrl(coordinates.latitude, coordinates.longitude)
            
        var request = URLRequest(url: pointUrl)
        request.httpMethod = "GET"
        request.addValue("com.kaya.weather", forHTTPHeaderField: "User-Agent")

        let (data, _) = try await URLSession.shared.data(for: request)
            
        let jsonData = JSON(data)
            
        let point = Point(json: jsonData)
            
        return point
    }
    
    func getForecast(location coordinates: CLLocationCoordinate2D) async throws -> Forecast {
        let point = try await getPoint(location: coordinates)
        
        guard let gridId = point.gridId, let gridX = point.gridX, let gridY = point.gridY else {
            throw APIError.notValidLocationError
        }
        
        let forecastUrl = URLs.gridpointForecast(office: gridId, gridX: gridX, gridY: gridY)
        
        var request = URLRequest(url: forecastUrl)
        request.httpMethod = "GET"
        request.addValue("com.kaya.weather", forHTTPHeaderField: "User-Agent")

        let (data, _) = try await URLSession.shared.data(for: request)
        
        let jsonData = JSON(data)
        
        let periodsJSON = jsonData["properties"]["periods"].array
        
        let periods = periodsJSON?.map({ json in
            Period(json: json)
        }) ?? []
        
        let forecast = Forecast(point: point, periods: periods)
        
        return forecast
    }
}
