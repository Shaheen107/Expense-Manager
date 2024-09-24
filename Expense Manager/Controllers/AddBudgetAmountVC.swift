import UIKit

protocol AddBudgetAmountVCDelegate: AnyObject {
    func didUpdateBudget(_ budget: Budget, at index: Int)
}

class AddBudgetAmountVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var savingAmount: UITextField!
    @IBOutlet weak var savingAmountDate: UIDatePicker!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var uiview: UIView!
    
    var budgets: [Budget] = []
    weak var delegate: AddBudgetAmountVCDelegate?

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
            var selectedBudget = budgets[selectedIndexPath.row]
            selectedBudget.savedAmount += amount
            delegate?.didUpdateBudget(selectedBudget, at: selectedIndexPath.row)
            navigationController?.popViewController(animated: true)
        } else {
            // Show error message if no budget is selected
        }
    }

    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return budgets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddBudgetAmountCell", for: indexPath) as! AddBudgetAmountCell
        cell.savingTitleLbl.text = budgets[indexPath.row].name
        return cell
    }
}
