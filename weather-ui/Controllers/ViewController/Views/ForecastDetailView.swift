import UIKit

class ForecaseDetailView: UIView {
    init(period: Period? = nil) {
        self.period = period
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        self.period = nil
        super.init(coder: coder)
        self.setupView()
    }
    
    func setupView() {
        container.addSubview(title)
        addSubview(container)
        
        container.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        title.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        title.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        setTitle()
    }
    
    func setTitle() {
        if let temperature = self.period?.temperature, let unit = self.period?.temperatureUnit {
            self.title.text = "\(temperature)°\(unit)"
        }
    }
    
    let container: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .red
        return stack
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var period: Period? {
        didSet {
            setTitle()
        }
    }
}
