import UIKit

class ForecaseDetailView: UIView {
    init(period: Period? = nil, location point: Point? = nil) {
        self.period = period
        self.location = point
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        container.addSubview(windSpeedText)
        container.addSubview(windDirection)
        container.addSubview(temperature)
        container.addSubview(temperatureTrend)
        container.addSubview(locationText)
        container.addSubview(shortForecast)
        addSubview(container)
        
        NSLayoutConstraint.activate([
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.heightAnchor.constraint(equalTo: heightAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            temperature.topAnchor.constraint(equalTo: container.topAnchor, constant: 28),
            temperature.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            
            temperatureTrend.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            temperatureTrend.widthAnchor.constraint(equalToConstant: 28),
            temperatureTrend.centerYAnchor.constraint(equalTo: temperature.centerYAnchor),
            temperatureTrend.trailingAnchor.constraint(equalTo: temperature.leadingAnchor, constant: -8),
            
            locationText.topAnchor.constraint(equalTo: temperature.bottomAnchor),
            locationText.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -24),
            
            shortForecast.topAnchor.constraint(equalTo: container.topAnchor, constant: 28),
            shortForecast.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            
            windDirection.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            windDirection.centerYAnchor.constraint(equalTo: windSpeedText.centerYAnchor),
            windDirection.widthAnchor.constraint(equalToConstant: 24),
            windDirection.heightAnchor.constraint(equalToConstant: 24),
            
            windSpeedText.topAnchor.constraint(equalTo: shortForecast.bottomAnchor, constant: 12),
            windSpeedText.leadingAnchor.constraint(equalTo: windDirection.leadingAnchor, constant: 26),
        ])
        
        setUI()
    }
    
    func setUI() {
        if let temperature = period?.temperature {
            setTemperatureText("\(Int(temperature))°")
        }
            
        setShortForecastText(period?.shortForecast)
        
        if let point = location {
            setLocationText("\(point.city ?? ""), \(point.state ?? "")")
        }
        
        setTemperateTrend(period?.temperatureTrend)
        
        setWindSpeedText(period?.windSpeed)
        
        setWindDirection(period?.windDirection)
    }
    
    let container: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = UIColor(red: 175/255, green: 185/255, blue: 255/255, alpha: 1)
        stack.layer.borderWidth = 1
        stack.layer.borderColor = CGColor(red: 105/255, green: 105/255, blue: 205/255, alpha: 1)
        stack.layer.cornerRadius = 18
        return stack
    }()
    
    let decoration: UIView = {
        let myDec = UIView()
        myDec.translatesAutoresizingMaskIntoConstraints = false
        return myDec
    }()
    
    let temperature: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 52, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    func setTemperatureText(_ text: String?) {
        temperature.text = text
    }
    
    let shortForecast: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    func setShortForecastText(_ text: String?) {
        shortForecast.text = text
    }
    
    let locationText: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    
    func setLocationText(_ text: String?) {
        locationText.text = text
    }
    
    let temperatureTrend: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "arrow.down.forward")?.withRenderingMode(.alwaysTemplate)
        image.contentMode = .scaleAspectFit
        image.tintColor = .white.withAlphaComponent(0.7)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    func setTemperateTrend(_ trend: TemperatureTrend?) {
        switch trend {
            case .rising:
                temperatureTrend.image = UIImage(systemName: "arrow.up.right")
            case .falling:
                temperatureTrend.image = UIImage(systemName: "arrow.down.right")
            default:
                temperatureTrend.image = nil
        }
    }
    
    let windSpeedText: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    func setWindSpeedText(_ text: String?) {
        windSpeedText.text = text
    }
    
    let windDirection: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "arrow.down.circle")?.withRenderingMode(.alwaysTemplate)
        image.contentMode = .scaleAspectFit
        image.tintColor = .white.withAlphaComponent(0.7)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    func setWindDirection(_ direction: WindDirection?) {
        switch direction {
            case .north:
                temperatureTrend.image = UIImage(systemName: "arrow.up.circle")
            case .west:
                temperatureTrend.image = UIImage(systemName: "arrow.left.circle")
            case .south:
                temperatureTrend.image = UIImage(systemName: "arrow.down.circle")
            case .east:
                temperatureTrend.image = UIImage(systemName: "arrow.right.circle")
            default:
                temperatureTrend.image = nil
        }
    }
    
    var period: Period? {
        didSet {
            setUI()
        }
    }
    
    var location: Point? {
        didSet {
            setUI()
        }
    }
}
