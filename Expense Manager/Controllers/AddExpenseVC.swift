import UIKit

class AddExpenseVC: UIViewController {

    @IBOutlet weak var expencePrice: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var uiviewOutlet: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedCurrency = UserDefaults.standard.string(forKey: "selectedLabelText") {
            print("Currency: \(selectedCurrency)")
            expencePrice.placeholder = "0.00 \(selectedCurrency.trimmingCharacters(in: .whitespacesAndNewlines))"
        } else {
            print("No currency selected")
            showAlert(title: "Error", message: "Please select a currency.")
        }
        date.overrideUserInterfaceStyle = .dark
        uiviewOutlet.layer.cornerRadius = 35
//        navigationItem.hidesBackButton = true
    }

    @IBAction func setBtnTapped(_ sender: Any) {
        guard let expenceAmount = expencePrice.text, !expenceAmount.isEmpty else {
            showAlert(title: "Missing Input", message: "Please enter an expense amount.")
            return
        }

        let dateSelected = date.date

        // Save expense data to UserDefaults
        var expenses = UserDefaults.standard.array(forKey: "expenses") as? [[String: Any]] ?? []
        let newExpense = ["amount": expenceAmount, "date": dateSelected] as [String : Any]
        expenses.append(newExpense)
        UserDefaults.standard.set(expenses, forKey: "expenses")

        // Navigate to AddCategoriesVC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addCategoriesVC = storyboard.instantiateViewController(withIdentifier: "AddCategoriesVC") as? AddCategoriesVC {
            addCategoriesVC.expenseAmount = expenceAmount
            navigationController?.pushViewController(addCategoriesVC, animated: true)
        } else {
            print("Could not instantiate AddCategoriesVC")
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
