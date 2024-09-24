import UIKit

struct AccountEntry: Codable {
    let accountName: String
    let date: Date
    let amount: Double
    let currency: String
}

class NewAccountVC: UIViewController {

    @IBOutlet weak var accountNameTextField: UITextField!
    @IBOutlet weak var datePickerOutlet: UIDatePicker!
    @IBOutlet weak var uiviewOutlet: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - UI Configuration
    
    private func configureUI() {

        
        // Apply corner radius to UITextField
        accountNameTextField.layer.cornerRadius = 20
        accountNameTextField.layer.borderWidth = 0.7
        accountNameTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        uiviewOutlet.layer.cornerRadius = 25
        
        // Add left padding to UITextField
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: accountNameTextField.frame.height))
        accountNameTextField.leftView = paddingView
        accountNameTextField.leftViewMode = .always
        
        // Change text color of UIDatePicker
        datePickerOutlet.overrideUserInterfaceStyle = .dark
    }
    
    // MARK: - Button Actions
    
    @IBAction func addBtnTapped(_ sender: Any) {
        guard let accountName = accountNameTextField.text, !accountName.isEmpty else {
            showAlert(message: "Please enter an account name.")
            return
        }
        
        // Since priceTextfieldOutlet is removed, amount is now directly set or hardcoded
        let amount: Double = 0.0 // or set a default value
        
        guard let selectedCurrency = UserDefaults.standard.string(forKey: "selectedLabelText") else {
            showAlert(message: "Please select a currency.")
            return
        }
        
        let date = datePickerOutlet.date
        let newEntry = AccountEntry(accountName: accountName, date: date, amount: amount, currency: selectedCurrency)
        
        saveAccountEntry(newEntry)
        navigateToTabbarController()
    }
    
    // MARK: - Helper Methods
    
    private func saveAccountEntry(_ entry: AccountEntry) {
        var savedEntries = [AccountEntry]()
        
        // Load existing entries from UserDefaults
        if let savedData = UserDefaults.standard.data(forKey: "accountEntries") {
            do {
                let decoder = JSONDecoder()
                savedEntries = try decoder.decode([AccountEntry].self, from: savedData)
            } catch {
                print("Failed to load saved entries: \(error)")
            }
        }
        
        // Add the new entry
        savedEntries.append(entry)
        
        // Save the updated entries to UserDefaults
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(savedEntries)
            UserDefaults.standard.set(data, forKey: "accountEntries")
        } catch {
            print("Failed to save entries: \(error)")
        }
        
        // Print saved entries for debugging
        for entry in savedEntries {
            print("Account: \(entry.accountName), Date: \(entry.date), Amount: \(entry.amount), Currency: \(entry.currency)")
        }
    }
    
    private func navigateToTabbarController() {
        if let tabBarController = storyboard?.instantiateViewController(withIdentifier: "TabbarController") as? TabbarController {
            tabBarController.selectedIndex = 0
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = tabBarController
                UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
            }
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
