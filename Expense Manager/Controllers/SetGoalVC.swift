import UIKit

class SetGoalVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    
    var goals: [Goal] = []
    var groupedGoals: [String: [Goal]] = [:] // Grouped goals by date
    var sortedDates: [String] = [] // Sorted dates for the sections

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        loadGoalsData() // Load goals data when the view loads
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Choose an Option", message: nil, preferredStyle: .actionSheet)

        let addGoalAction = UIAlertAction(title: "Add Goal", style: .default) { _ in
            self.addGoal()
        }

        let addSavingAction = UIAlertAction(title: "Add Saving Goal Amount", style: .default) { _ in
            self.addSaving()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        actionSheet.addAction(addGoalAction)
        actionSheet.addAction(addSavingAction)
        actionSheet.addAction(cancelAction)

        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        present(actionSheet, animated: true, completion: nil)
    }

    private func addGoal() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addGoalVC = storyboard.instantiateViewController(withIdentifier: "AddGoalVC") as! AddGoalVC
        addGoalVC.delegate = self
        navigationController?.pushViewController(addGoalVC, animated: true)
    }

    private func addSaving() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addGoalAmountVC = storyboard.instantiateViewController(withIdentifier: "AddGoalAmountVC") as! AddGoalAmountVC
        addGoalAmountVC.goals = goals // Pass the goals to AddGoalAmountVC
        addGoalAmountVC.delegate = self
        navigationController?.pushViewController(addGoalAmountVC, animated: true)
    }

    // MARK: - TableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedDates.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dateKey = sortedDates[section]
        return groupedGoals[dateKey]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetGoalCell", for: indexPath) as! SetGoalCell
        let dateKey = sortedDates[indexPath.section]
        if let goal = groupedGoals[dateKey]?[indexPath.row] {
            cell.GoalNameLbl.text = goal.name
            cell.totalsavedAmountLbl.text = "\(goal.savedAmount)"
            cell.totalgoalAmountLbl.text = "\(goal.amount)"
            cell.amountProcess.progress = Float(goal.savedAmount / goal.amount)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedDates[section]
    }

    // MARK: - TableView Delegate for Deleting Goals

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let dateKey = sortedDates[indexPath.section]
            if var goalsForDate = groupedGoals[dateKey] {
                // Show a confirmation alert before deletion
                let alert = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete this goal?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                    // Remove the goal from the array
                    let removedGoal = goalsForDate.remove(at: indexPath.row)
                    self.groupedGoals[dateKey] = goalsForDate.isEmpty ? nil : goalsForDate
                    
                    // Remove the corresponding goal from the goals array
                    self.goals.removeAll { $0.name == removedGoal.name && $0.date == removedGoal.date }

                    // If there are no more goals for this date, remove the date from sortedDates
                    if self.groupedGoals[dateKey] == nil {
                        self.sortedDates.remove(at: indexPath.section)
                        tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
                    } else {
                        // Delete the row from the table view
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }

                    // Save updated goals data
                    self.saveGoalsData()
                }))
                present(alert, animated: true, completion: nil)
            }
        }
    }

    // MARK: - UserDefaults Saving/Loading
    
    private func saveGoalsData() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(goals) {
            UserDefaults.standard.set(encoded, forKey: "goals")
        }
    }

    private func loadGoalsData() {
        if let savedGoalsData = UserDefaults.standard.data(forKey: "goals") {
            let decoder = JSONDecoder()
            if let loadedGoals = try? decoder.decode([Goal].self, from: savedGoalsData) {
                goals = loadedGoals
            }
        } else {
            // Initialize with default goals if no data found
            goals = [
                Goal(name: "Vacation", amount: 2000.0, date: Date(), savedAmount: 500.0),
                Goal(name: "New Car", amount: 10000.0, date: Date(), savedAmount: 1500.0)
            ]
        }

        // Group and sort goals by date
        groupAndSortGoals()
        tableview.reloadData()
    }

    private func groupAndSortGoals() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        groupedGoals = Dictionary(grouping: goals) { goal in
            dateFormatter.string(from: goal.date)
        }
        sortedDates = groupedGoals.keys.sorted()
    }
}

extension SetGoalVC: AddGoalVCDelegate {
    func didAddGoal(_ goal: Goal) {
        goals.append(goal)
        groupAndSortGoals() // Group and sort after adding a new goal
        saveGoalsData() // Save goals data after adding a new goal
        tableview.reloadData()
    }
}

extension SetGoalVC: AddGoalAmountVCDelegate {
    func didUpdateGoal(_ goal: Goal, at index: Int) {
        goals[index] = goal
        groupAndSortGoals() // Group and sort after updating a goal
        saveGoalsData() // Save goals data after updating a goal
        tableview.reloadData()
    }
}
