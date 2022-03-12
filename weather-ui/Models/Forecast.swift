struct Forecast {
    init(point: Point? = nil, periods: [Period]) {
        self.point = point
        self.periods = periods
    }
    
    var point: Point?
    var periods: [Period]
}
