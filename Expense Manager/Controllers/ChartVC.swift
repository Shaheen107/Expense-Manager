import UIKit
import Charts

class ChartViewController: UIViewController {

    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var detailsView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPieChart()
        setupDetailsView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupPieChart()
        setupDetailsView()
    }

    private func setupPieChart() {
        let entries = [
            PieChartDataEntry(value: SharedData.shared.totalBalance, label: "Total Balance: \(String(format: "%.2f", SharedData.shared.totalBalance))"),
            PieChartDataEntry(value: SharedData.shared.totalIncome, label: "Income: \(String(format: "%.2f", SharedData.shared.totalIncome))"),
            PieChartDataEntry(value: SharedData.shared.totalExpense, label: "Expense: \(String(format: "%.2f", SharedData.shared.totalExpense))")
        ]

        let dataSet = PieChartDataSet(entries: entries, label: "")

        // Define colors for each segment
        let colors = [
            UIColor(hexString: "#0B9430"), // Green for total balance
            UIColor(hexString: "#4285F4"), // Blue for income
            UIColor(hexString: "#DB4437")  // Red for expense
        ]
        
        dataSet.colors = colors
        dataSet.sliceSpace = 3
        dataSet.selectionShift = 15
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.4
        dataSet.valueLinePart2Length = 0.6
        dataSet.yValuePosition = .outsideSlice
        dataSet.xValuePosition = .outsideSlice

        let data = PieChartData(dataSet: dataSet)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        data.setValueFont(UIFont.systemFont(ofSize: 14, weight: .bold))
        data.setValueTextColor(.black) // Set label text color to black
        
        pieChartView.data = data

        pieChartView.usePercentValuesEnabled = false // Show absolute values
        pieChartView.legend.enabled = false
        pieChartView.chartDescription.enabled = false
        
        // Customizing the hole
        pieChartView.holeColor = UIColor.clear // Transparent hole
        pieChartView.holeRadiusPercent = 0.45
        pieChartView.transparentCircleRadiusPercent = 0.5
        pieChartView.transparentCircleColor = UIColor.white.withAlphaComponent(0.3)
        
        // Add center text with more detailed and styled attributed string
        let centerText = NSMutableAttributedString()
        centerText.append(NSAttributedString(string: "Financial Overview\n", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor(hexString: "#0B9430")
        ]))
        centerText.append(NSAttributedString(string: "\(String(format: "%.2f", SharedData.shared.totalBalance))", attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.white
        ]))
        pieChartView.centerAttributedText = centerText
        
        // Add animation for both x and y axis
        pieChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .easeOutBack)
    }

    private func setupDetailsView() {
        // Set up gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.darkGray.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = detailsView.bounds
        detailsView.layer.insertSublayer(gradientLayer, at: 0)
        
        // Set rounded corners and shadow
        detailsView.layer.cornerRadius = 15
        detailsView.layer.shadowColor = UIColor.black.cgColor
        detailsView.layer.shadowOffset = CGSize(width: 0, height: 4)
        detailsView.layer.shadowOpacity = 0.7
        detailsView.layer.shadowRadius = 8

        // Remove any existing stack view
        detailsView.subviews.forEach { subview in
            if subview is UIStackView {
                subview.removeFromSuperview()
            }
        }
        
        // Create stack view
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Define items with simplified styling
        let items = [
            ("Total Balance", UIImage(systemName: "dollarsign.circle.fill"), UIColor(hexString: "#0B9430"), SharedData.shared.totalBalance),
            ("Income", UIImage(systemName: "arrow.up.circle.fill"), UIColor.systemBlue, SharedData.shared.totalIncome),
            ("Expense", UIImage(systemName: "arrow.down.circle.fill"), UIColor.systemRed, SharedData.shared.totalExpense)
        ]
        
        for (labelText, icon, color, amount) in items {
            let stackItem = UIStackView()
            stackItem.axis = .horizontal
            stackItem.spacing = 12
            stackItem.alignment = .center
            stackItem.translatesAutoresizingMaskIntoConstraints = false
            
            let iconImageView = UIImageView(image: icon)
            iconImageView.tintColor = color
            iconImageView.translatesAutoresizingMaskIntoConstraints = false
            iconImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
            iconImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
            
            let label = UILabel()
            label.text = "\(labelText): $\(String(format: "%.2f", amount))"
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.translatesAutoresizingMaskIntoConstraints = false
            
            stackItem.addArrangedSubview(iconImageView)
            stackItem.addArrangedSubview(label)
            
            stackView.addArrangedSubview(stackItem)
        }
        
        // Add stack view to details view and set constraints
        detailsView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: detailsView.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: detailsView.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: detailsView.bottomAnchor, constant: -20)
        ])
    }
}

// Extension to handle hex string colors
extension UIColor {
    convenience init(hexString: String) {
        var hex = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hex = hex.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)
        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}



class SharedData {
    static let shared = SharedData()
    
    var totalBalance: Double = 0.0
    var totalIncome: Double = 0.0
    var totalExpense: Double = 0.0
    
    private init() {}
    
    func updateData(totalBalance: Double, totalIncome: Double, totalExpense: Double) {
        self.totalBalance = totalBalance
        self.totalIncome = totalIncome
        self.totalExpense = totalExpense
    }
}
