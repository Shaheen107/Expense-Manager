import UIKit

class AddIncomeVC: UIViewController {

    @IBOutlet weak var incomField: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var uiviewOutlet: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let selectedCurrency = UserDefaults.standard.string(forKey: "selectedLabelText") {
            print("Currency: \(selectedCurrency)")
            incomField.placeholder = "0.00 \(selectedCurrency.trimmingCharacters(in: .whitespacesAndNewlines))"
        } else {
            print("No currency selected")
            showAlert(title: "Error", message: "Please select a currency.")
        }
         
//        navigationItem.hidesBackButton = true
        
        date.overrideUserInterfaceStyle = .dark
        uiviewOutlet.layer.cornerRadius = 35
    }

    @IBAction func setBtnTapped(_ sender: Any) {
        guard let incomeAmount = incomField.text, !incomeAmount.isEmpty else {
            showAlert(title: "Missing Input", message: "Please enter an income amount.")
            return
        }

        let dateSelected = date.date

        // Save income data to UserDefaults
        var incomes = UserDefaults.standard.array(forKey: "incomes") as? [[String: Any]] ?? []
        let newIncome = ["amount": incomeAmount, "date": dateSelected] as [String : Any]
        incomes.append(newIncome)
        UserDefaults.standard.set(incomes, forKey: "incomes")

        // Navigate back to HomeVC
        if let navigationController = self.navigationController {
            for controller in navigationController.viewControllers {
                if controller is HomeVC {
                    navigationController.popToViewController(controller, animated: true)
                    break
                }
            }
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
