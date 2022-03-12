import Foundation
import SwiftyJSON

struct Period {
    init(number: Int? = nil, name: String? = nil, startTime: Date? = nil, endTime: Date? = nil, isDaytime: Bool? = nil, temperature: Double? = nil, temperatureUnit: String? = nil, temperatureTrend: TemperatureTrend? = nil, windSpeed: String? = nil, windDirection: WindDirection? = nil, icon: String? = nil, shortForecast: String? = nil, detailedForecast: String? = nil) {
        self.number = number
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        self.isDaytime = isDaytime
        self.temperature = temperature
        self.temperatureUnit = temperatureUnit
        self.temperatureTrend = temperatureTrend
        self.windSpeed = windSpeed
        self.windDirection = windDirection
        self.icon = icon
        self.shortForecast = shortForecast
        self.detailedForecast = detailedForecast
    }
    
    init(json: JSON) {
        self.number = json["number"].int
        self.name = json["name"].string
        if let startD = json["startTime"].string {
            self.startTime = ISO8601DateFormatter().date(from: startD)
        }
        
        if let endD = json["endTime"].string {
            self.endTime = ISO8601DateFormatter().date(from: endD)
        }
        
        self.isDaytime = json["isDaytime"].bool
        self.temperature = json["temperature"].double
        self.temperatureUnit = json["temperatureUnit"].string
        self.temperatureTrend = TemperatureTrend(rawValue: json["temperatureTrend"].string ?? "")
        self.windSpeed = json["windSpeed"].string
        self.windDirection = WindDirection(rawValue: json["windDirection"].string ?? "")
        self.icon = json["icon"].string
        self.shortForecast = json["shortForecast"].string
        self.detailedForecast = json["detailedForecast"].string
    }
    
    var number: Int?
    var name: String?
    var startTime: Date?
    var endTime: Date?
    var isDaytime: Bool?
    var temperature: Double?
    var temperatureUnit: String?
    var temperatureTrend: TemperatureTrend?
    var windSpeed: String?
    var windDirection: WindDirection?
    var icon: String?
    var shortForecast: String?
    var detailedForecast: String?
}
