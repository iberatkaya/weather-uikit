import SwiftyJSON

struct Point {
    init(city: String? = nil, state: String? = nil, timezone: String? = nil, gridId: String? = nil, lat: Double? = nil, long: Double? = nil, gridX: Int? = nil, gridY: Int? = nil) {
        self.city = city
        self.state = state
        self.timezone = timezone
        self.gridId = gridId
        self.lat = lat
        self.long = long
        self.gridX = gridX
        self.gridY = gridY
    }
    
    
    init(json: JSON) {
        self.city = json["properties"]["relativeLocation"]["properties"]["city"].string
        self.state = json["properties"]["relativeLocation"]["properties"]["state"].string
        self.timezone = json["properties"]["timeZone"].string
        self.gridId = json["properties"]["cwa"].string
        self.lat = json["geometry"]["coordinates"][0].double
        self.long = json["geometry"]["coordinates"][1].double
        self.gridX = json["properties"]["gridX"].int
        self.gridY = json["properties"]["gridY"].int
    }
    
    var city: String?
    var state: String?
    var timezone: String?
    var gridId: String?
    var lat: Double?
    var long: Double?
    var gridX: Int?
    var gridY: Int?
}
