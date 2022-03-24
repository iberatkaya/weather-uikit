import Charts
import Foundation
import UIKit

public class BarChartDayFormatter: AxisValueFormatter {
    var months: [String]! = ["Sun", "Mon", "Tues", "Wed", "Thur", "Fri", "Sat"]

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[((Int(value) / 2) + (Date().dayNumberOfWeek() ?? 0) - 1) % 7]
    }
}

public class TemperatureValueFormatter: ValueFormatter {
    public func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return "\(Int(value))°"
    }
}
