import UIKit

protocol AddGoalAmountVCDelegate: AnyObject {
    func didUpdateGoal(_ goal: Goal, at index: Int)
}

class AddGoalAmountVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var savingAmount: UITextField!
    @IBOutlet weak var savingAmountDate: UIDatePicker!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var uiview: UIView!
    
    
    var goals: [Goal] = []
    weak var delegate: AddGoalAmountVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        
        uiview.layer.cornerRadius = 36
        
        savingAmountDate.overrideUserInterfaceStyle = .dark
    }

    @IBAction func addSaving(_ sender: Any) {
        guard let amountText = savingAmount.text, let amount = Double(amountText) else {
            // Show error message if input is invalid
            return
        }

        if let selectedIndexPath = tableview.indexPathForSelectedRow {
            var selectedGoal = goals[selectedIndexPath.row]
            selectedGoal.savedAmount += amount
            delegate?.didUpdateGoal(selectedGoal, at: selectedIndexPath.row)
            navigationController?.popViewController(animated: true)
        } else {
            // Show error message if no goal is selected
        }
    }

    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddGoalAmountCell", for: indexPath) as! AddGoalAmountCell
        cell.savingTitleLbl.text = goals[indexPath.row].name
        return cell
    }
}
