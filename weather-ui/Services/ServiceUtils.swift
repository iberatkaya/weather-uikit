import Foundation

struct URLs {
    static func pointUrl(_ latitude: Double, _ longitude: Double) -> URL {
        return URL(string: "https://api.weather.gov/points/\(latitude),\(longitude)")!
    }
}
