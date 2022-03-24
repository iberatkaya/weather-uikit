struct Forecast {
    init(point: Point? = nil, periods: [Period]) {
        self.point = point
        self.periods = periods.sorted(by: {
            if let startTimeA = $0.startTime, let startTimeB = $1.startTime {
                return startTimeA.compare(startTimeB) == .orderedAscending
            }
            return false
        })
    }
    
    var point: Point?
    var periods: [Period]
}
