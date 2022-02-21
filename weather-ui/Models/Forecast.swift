struct Forecast: CustomStringConvertible {
    init(point: Point? = nil, periods: [Period]) {
        self.point = point
        self.periods = periods
    }
    
    var point: Point?
    var periods: [Period]
    
    
    var description: String {
        var desc = "Forecast:\n"
        desc += point != nil ? String(describing: point) : ""
        desc += periods.map({ "\($0)" }).joined(separator: "\n")
        return desc
    }
}
