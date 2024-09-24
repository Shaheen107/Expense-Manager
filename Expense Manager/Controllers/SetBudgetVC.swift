import UIKit

class SetBudgetVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    
    var budgets: [Budget] = []
    var groupedBudgets: [String: [Budget]] = [:] // Grouped budgets by date
    var sortedDates: [String] = [] // Sorted dates for the sections

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        loadBudgetsData() // Load budgets data when the view loads
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Choose an Option", message: nil, preferredStyle: .actionSheet)

        let addBudgetAction = UIAlertAction(title: "Add Budget", style: .default) { _ in
            self.addBudget()
        }

        let addSavingAction = UIAlertAction(title: "Add Budget Amount", style: .default) { _ in
            self.addSaving()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        actionSheet.addAction(addBudgetAction)
        actionSheet.addAction(addSavingAction)
        actionSheet.addAction(cancelAction)

        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        present(actionSheet, animated: true, completion: nil)
    }

    private func addBudget() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addBudgetVC = storyboard.instantiateViewController(withIdentifier: "AddBudgetVC") as! AddBudgetVC
        addBudgetVC.delegate = self
        navigationController?.pushViewController(addBudgetVC, animated: true)
    }

    private func addSaving() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addBudgetAmountVC = storyboard.instantiateViewController(withIdentifier: "AddBudgetAmountVC") as! AddBudgetAmountVC
        addBudgetAmountVC.budgets = budgets // Pass the budgets to AddBudgetAmountVC
        addBudgetAmountVC.delegate = self
        navigationController?.pushViewController(addBudgetAmountVC, animated: true)
    }

    // MARK: - TableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedDates.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dateKey = sortedDates[section]
        return groupedBudgets[dateKey]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetBudgetCell", for: indexPath) as! SetBudgetCell
        let dateKey = sortedDates[indexPath.section]
        if let budget = groupedBudgets[dateKey]?[indexPath.row] {
            cell.budgetNameLbl.text = budget.name
            cell.totalSavedAmountLbl.text = "\(budget.savedAmount)"
            cell.totalBudgetAmountLbl.text = "\(budget.amount)"
            cell.amountProgress.progress = Float(budget.savedAmount / budget.amount)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedDates[section]
    }

    // MARK: - TableView Delegate for Deleting Budgets

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let dateKey = sortedDates[indexPath.section]
            if var budgetsForDate = groupedBudgets[dateKey] {
                // Show a confirmation alert before deletion
                let alert = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete this budget?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                    // Remove the budget from the array
                    let removedBudget = budgetsForDate.remove(at: indexPath.row)
                    self.groupedBudgets[dateKey] = budgetsForDate.isEmpty ? nil : budgetsForDate
                    
                    // Remove the corresponding budget from the budgets array
                    self.budgets.removeAll { $0.name == removedBudget.name && $0.date == removedBudget.date }

                    // If there are no more budgets for this date, remove the date from sortedDates
                    if self.groupedBudgets[dateKey] == nil {
                        self.sortedDates.remove(at: indexPath.section)
                        tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
                    } else {
                        // Delete the row from the table view
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }

                    // Save updated budgets data
                    self.saveBudgetsData()
                }))
                present(alert, animated: true, completion: nil)
            }
        }
    }

    // MARK: - UserDefaults Saving/Loading
    
    private func saveBudgetsData() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(budgets) {
            UserDefaults.standard.set(encoded, forKey: "budgets")
        }
    }

    private func loadBudgetsData() {
        if let savedBudgetsData = UserDefaults.standard.data(forKey: "budgets") {
            let decoder = JSONDecoder()
            if let loadedBudgets = try? decoder.decode([Budget].self, from: savedBudgetsData) {
                budgets = loadedBudgets
            }
        } else {
            // Initialize with default budgets if no data found
            budgets = [
                Budget(name: "Monthly Expenses", amount: 1500.0, date: Date(), savedAmount: 300.0),
                Budget(name: "Yearly Maintenance", amount: 5000.0, date: Date(), savedAmount: 800.0)
            ]
        }

        // Group and sort budgets by date
        groupAndSortBudgets()
        tableview.reloadData()
    }

    private func groupAndSortBudgets() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        groupedBudgets = Dictionary(grouping: budgets) { budget in
            dateFormatter.string(from: budget.date)
        }
        sortedDates = groupedBudgets.keys.sorted()
    }
}

extension SetBudgetVC: AddBudgetVCDelegate {
    func didAddBudget(_ budget: Budget) {
        budgets.append(budget)
        groupAndSortBudgets() // Group and sort after adding a new budget
        saveBudgetsData() // Save budgets data after adding a new budget
        tableview.reloadData()
    }
}

extension SetBudgetVC: AddBudgetAmountVCDelegate {
    func didUpdateBudget(_ budget: Budget, at index: Int) {
        budgets[index] = budget
        groupAndSortBudgets() // Group and sort after updating a budget
        saveBudgetsData() // Save budgets data after updating a budget
        tableview.reloadData()
    }
}
