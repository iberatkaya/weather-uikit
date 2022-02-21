import Foundation
import SwiftyJSON

struct Period: CustomStringConvertible {
    init(number: Int? = nil, name: String? = nil, startTime: Date? = nil, endTime: Date? = nil, isDaytime: Bool? = nil, temperature: Double? = nil, temperatureUnit: String? = nil, temperatureTrend: String? = nil, windSpeed: String? = nil, windDirection: String? = nil, icon: String? = nil, shortForecast: String? = nil, detailedForecast: String? = nil) {
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
        self.temperatureTrend = json["temperatureTrend"].string
        self.windSpeed = json["windSpeed"].string
        self.windDirection = json["windDirection"].string
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
    var temperatureTrend: String?
    var windSpeed: String?
    var windDirection: String?
    var icon: String?
    var shortForecast: String?
    var detailedForecast: String?
    
    var description: String {
        var desc = "\(startTime?.formatted() ?? "Start"), \(endTime?.formatted() ?? "End")\n"
        desc += "\(temperature ?? -1)°\(temperatureUnit ?? "?")\n"
        desc += shortForecast ?? ""
        return desc
    }
}
