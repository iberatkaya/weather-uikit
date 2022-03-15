import Combine
import CoreLocation
import UIKit

class TableViewController: UITableViewController {
    var forecast: Forecast? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        tableView.register(ForecaseCellView.self, forCellReuseIdentifier: "periodCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let myForecast = forecast {
            return myForecast.periods.count - 1
        }
        return 0
    }

    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "periodCell", for: indexPath) as! ForecaseCellView
        
        cell.period = forecast?.periods[indexPath.item]
        
        return cell
    }
    
    // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
