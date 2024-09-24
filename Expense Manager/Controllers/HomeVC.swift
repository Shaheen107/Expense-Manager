import UIKit
import FirebaseAuth

class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var curencyLbl: UILabel!
    @IBOutlet weak var expencePriceLbl: UILabel!
    
    @IBOutlet weak var curencyLbl2: UILabel!
    @IBOutlet weak var incomeAmountLbl: UILabel!
    
    @IBOutlet weak var totalBalance: UILabel!
    
    @IBOutlet var uiview: [UIView]!
    
    @IBOutlet weak var totalBalanceUiView: UIView!
    
    var expenses: [(date: Date, category: String, amount: String)] = []
    var incomes: [(date: Date, amount: String)] = []
    var goals: [(name: String, savedAmount: Double)] = []
    var groupedExpenses: [String: [(category: String, amount: String)]] = [:]
    var sortedDates: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem?.isEnabled = false

        tableview.dataSource = self
        tableview.delegate = self
        
        checkAccountNameExists()

        setupCornerRadius()
        handleNewAccountEntry()
        
        // Observe notification
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewAccountEntry), name: NSNotification.Name("NewAccountEntryAdded"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleNewAccountEntry()
    }
    
    
    private func checkAccountNameExists() {
        if let savedData = UserDefaults.standard.data(forKey: "accountEntries") {
            do {
                let decoder = JSONDecoder()
                let savedEntries = try decoder.decode([AccountEntry].self, from: savedData)
                if savedEntries.isEmpty {
                    navigateToFirstScreenStartVC()  // No account entries, go to the first screen
                }
            } catch {
                print("Failed to load saved entries: \(error)")
                navigateToFirstScreenStartVC()  // If there's an error loading entries, go to the first screen
            }
        } else {
            navigateToFirstScreenStartVC()  // No account data found, go to the first screen
        }
    }

    private func navigateToFirstScreenStartVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "FirstScreenStartVC") as? FirstScreenStartVC {
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
    
    @objc func handleNewAccountEntry() {
        loadAccountData()
        loadSavedData()
        updateSharedData()
    }

    private func setupCornerRadius() {
        let cornerRadius: CGFloat = 20.0
        for view in uiview {
            view.layer.cornerRadius = cornerRadius
        }
    }

    private func loadAccountData() {
        if let savedData = UserDefaults.standard.data(forKey: "accountEntries") {
            do {
                let decoder = JSONDecoder()
                let savedEntries = try decoder.decode([AccountEntry].self, from: savedData)
                if let lastEntry = savedEntries.last {
                    self.navigationItem.title = lastEntry.accountName
                    totalBalance.text = "\(lastEntry.amount) \(lastEntry.currency)"
                    
                    // Change color based on the total balance
                    totalBalanceUiView.backgroundColor = lastEntry.amount < 0 ? .systemRed : UIColor(hex: "#0B9430")
                }
            } catch {
                print("Failed to load saved entries: \(error)")
            }
        }
    }

    func loadSavedData() {
        // Set currency labels
        if let selectedCurrency = UserDefaults.standard.string(forKey: "selectedLabelText") {
            let trimmedCurrency = selectedCurrency.trimmingCharacters(in: .whitespacesAndNewlines)
            curencyLbl.text = trimmedCurrency
            curencyLbl2.text = trimmedCurrency
        } else {
            curencyLbl.text = "No currency selected"
            curencyLbl2.text = "No currency selected"
        }

        // Load expenses
        if let savedExpenses = UserDefaults.standard.array(forKey: "expenses") as? [[String: Any]] {
            expenses = savedExpenses.compactMap {
                if let date = $0["date"] as? Date, let category = $0["category"] as? String, let amount = $0["amount"] as? String {
                    return (date, category, amount)
                }
                return nil
            }
        }

        // Load incomes
        if let savedIncomes = UserDefaults.standard.array(forKey: "incomes") as? [[String: Any]] {
            incomes = savedIncomes.compactMap {
                if let date = $0["date"] as? Date, let amount = $0["amount"] as? String {
                    return (date, amount)
                }
                return nil
            }
        }

        // Load goals and treat them as expenses
        if let savedGoals = UserDefaults.standard.array(forKey: "goals") as? [[String: Any]] {
            goals = savedGoals.compactMap {
                if let name = $0["name"] as? String, let savedAmount = $0["savedAmount"] as? Double {
                    expenses.append((Date(), "Saving: \(name)", String(savedAmount)))
                    return (name, savedAmount)
                }
                return nil
            }
        }

        // Group expenses by date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        groupedExpenses = Dictionary(grouping: expenses) { expense in
            dateFormatter.string(from: expense.date)
        }.mapValues { expenses in
            expenses.map { ($0.category, $0.amount) }
        }
        sortedDates = groupedExpenses.keys.sorted()

        // Calculate total expense amount
        let totalExpenses = expenses.reduce(0.0) { (result, expense) -> Double in
            if let amount = Double(expense.amount) {
                return result + amount
            }
            return result
        }

        // Calculate total income amount
        let totalIncomes = incomes.reduce(0.0) { (result, income) -> Double in
            if let amount = Double(income.amount) {
                return result + amount
            }
            return result
        }

        // Calculate total balance
        let balance = totalIncomes - totalExpenses

        // Update labels
        expencePriceLbl.text = "\(String(format: "%.2f", totalExpenses))"
        incomeAmountLbl.text = "\(String(format: "%.2f", totalIncomes))"
        totalBalance.text = "\(String(format: "%.2f", balance))"

        // Reload table view
        tableview.reloadData()
        
        // Set the background view based on the table view data
        if expenses.isEmpty && incomes.isEmpty {
            setBackgroundView()
        } else {
            tableview.backgroundView = nil
        }
    }

    private func updateSharedData() {
        let totalExpenses = Double(expencePriceLbl.text ?? "0") ?? 0.0
        let totalIncomes = Double(incomeAmountLbl.text ?? "0") ?? 0.0
        let balance = Double(totalBalance.text ?? "0") ?? 0.0
        
        SharedData.shared.updateData(totalBalance: balance, totalIncome: totalIncomes, totalExpense: totalExpenses)
    }

    @IBAction func tabBarBtn(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Choose an Option", message: nil, preferredStyle: .actionSheet)

        let addIncomeAction = UIAlertAction(title: "Add Income", style: .default) { _ in
            self.addIncome()
        }

        let addExpenseAction = UIAlertAction(title: "Add Expense", style: .default) { _ in
            self.addExpense()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        actionSheet.addAction(addIncomeAction)
        actionSheet.addAction(addExpenseAction)
        actionSheet.addAction(cancelAction)

        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        present(actionSheet, animated: true, completion: nil)
    }

    func addIncome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let incomeVC = storyboard.instantiateViewController(identifier: "AddIncomeVC") as! AddIncomeVC
        navigationController?.pushViewController(incomeVC, animated: true)
    }

    func addExpense() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let expenceVC = storyboard.instantiateViewController(identifier: "AddExpenseVC") as! AddExpenseVC
        navigationController?.pushViewController(expenceVC, animated: true)
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedDates.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dateKey = sortedDates[section]
        return groupedExpenses[dateKey]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableCell", for: indexPath) as! HomeTableCell
        let dateKey = sortedDates[indexPath.section]
        if let expense = groupedExpenses[dateKey]?[indexPath.row] {
            cell.catagaryLbl.text = expense.category
            cell.expencePrice.text = expense.amount
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedDates[section]
    }

    private func setBackgroundView() {
        let noRecordImage = UIImage(named: "No Record Box")
        let imageView = UIImageView(image: noRecordImage)
        imageView.contentMode = .center
        tableview.backgroundView = imageView
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexString = hexString.hasPrefix("#") ? String(hexString.dropFirst()) : hexString
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
