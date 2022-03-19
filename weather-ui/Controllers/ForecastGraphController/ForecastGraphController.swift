import Charts
import UIKit

class ForecastGraphController: UIViewController {
    let barChartView: BarChartView = {
        let barChart = BarChartView()
        barChart.fitBars = true
        barChart.xAxis.labelPosition = .bottom
        barChart.isUserInteractionEnabled = false
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
        
        set.colors = ChartColorTemplates.material()
        
        barChartView.data = BarChartData(dataSet: set)
        barChartView.notifyDataSetChanged()
    }
}
