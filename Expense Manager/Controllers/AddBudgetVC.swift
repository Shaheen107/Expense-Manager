import UIKit

protocol AddBudgetVCDelegate: AnyObject {
    func didAddBudget(_ budget: Budget)
}

class AddBudgetVC: UIViewController {
    
    @IBOutlet weak var budgetName: UITextField!
    @IBOutlet weak var setBudgetAmount: UITextField!
    @IBOutlet weak var budgetSetDate: UIDatePicker!
    
    @IBOutlet weak var uiview: UIView!
    
    weak var delegate: AddBudgetVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        uiview.layer.cornerRadius = 36
        budgetSetDate.overrideUserInterfaceStyle = .dark
    }
    
    @IBAction func setBudgetBtnTapped(_ sender: Any) {
        guard let name = budgetName.text, !name.isEmpty,
              let amountText = setBudgetAmount.text, let amount = Double(amountText) else {
            // Show error message if input is invalid
            return
        }
        
        let budget = Budget(name: name, amount: amount, date: budgetSetDate.date)
        delegate?.didAddBudget(budget)
        navigationController?.popViewController(animated: true)
    }
}
