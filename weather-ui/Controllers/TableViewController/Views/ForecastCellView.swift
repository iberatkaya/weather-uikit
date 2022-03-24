import UIKit

class ForecaseCellView: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        container.addSubview(temperature)
        container.addSubview(day)
        
        addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            container.heightAnchor.constraint(equalToConstant: 60),
            container.widthAnchor.constraint(equalTo: widthAnchor),
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            day.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            day.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            temperature.leadingAnchor.constraint(equalTo: day.trailingAnchor, constant: 16),
            temperature.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func setUI() {
        if let temperatures = periods?.map({ $0.temperature }) {
            if temperatures.count == 2 {
                setTemperatureText("\(Int(temperatures[0]!))°/\(Int(temperatures[1]!))°")
            }
            else if temperatures.count == 1 {
                setTemperatureText("\(Int(temperatures[0]!))°")
            }
        }
        
        if let date = periods?.first?.startTime {
            setDayText(date.dayOfWeek())
        }
    }
    
    let container: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 255/255, alpha: 1)
        stack.layer.borderWidth = 1
        stack.layer.borderColor = CGColor(red: 185/255, green: 185/255, blue: 255/255, alpha: 1)
        stack.layer.cornerRadius = 18
        return stack
    }()
    
    let temperature: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = label.font.withSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setTemperatureText(_ text: String?) {
        temperature.text = text
    }
    
    let day: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = label.font.withSize(18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setDayText(_ text: String?) {
        day.text = text
    }
    
    var periods: [Period]? {
        didSet {
            setUI()
        }
    }
}
