import Charts
import UIKit

class ForecastGraphController: UIViewController {
    let barChartView: BarChartView = {
        let barChart = BarChartView()
        barChart.fitBars = true
        barChart.xAxis.drawAxisLineEnabled = false
        barChart.leftAxis.drawAxisLineEnabled = false
        barChart.isUserInteractionEnabled = false
        barChart.drawGridBackgroundEnabled = false
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.xAxis.valueFormatter = BarChartDayFormatter()
        barChart.xAxis.avoidFirstLastClippingEnabled = false
        barChart.xAxis.labelPosition = .bottom
        barChart.drawGridBackgroundEnabled = false
        barChart.rightAxis.enabled = false
        return barChart
    }()
    
    var forecast: Forecast? {
        didSet {
            setData()
        }
    }

    override func loadView() {
        super.loadView()
        
        view.addSubview(barChartView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        barChartView.frame = view.frame
    }
    
    func setData() {
        let set = BarChartDataSet(entries: self.forecast?.periods.enumerated().map { (index, item) in
            BarChartDataEntry(x: Double(index), y: Double(item.temperature ?? 0))
        } ?? [], label: "Forecast")
        
        set.colors = self.forecast?.periods.enumerated().map({ (index, item) -> NSUIColor in
            if (item.startTime?.dayNumberOfWeek() ?? 0) % 2 == 0 {
                return UIColor(red: 125/255, green: 145/255, blue: 255/255, alpha: 1)
            }
            return UIColor(red: 105/255, green: 85/255, blue: 205/255, alpha: 1)
        }) ?? [NSUIColor.blue]
        
        set.valueFormatter = TemperatureValueFormatter()
        
        barChartView.data = BarChartData(dataSet: set)
        barChartView.notifyDataSetChanged()
    }
}
