import UIKit

class AddCategoriesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addCatagary: UIBarButtonItem!
    
    var categories: [(String, String)] = []
    var selectedCategories: [String] = []
    var expenseAmount: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        addCatagary.target = self
        addCatagary.action = #selector(addNewCategory)

        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }

    @objc func addNewCategory() {
        let alert = UIAlertController(title: "Add New Category", message: "Enter the name of the new category:", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Category"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] (_) in
            if let textField = alert.textFields?.first, let text = textField.text, !text.isEmpty {
                self?.categories.append((text, ""))
                self?.saveCategories()
                self?.tableView.reloadData()
            }
        }
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        let category = categories[indexPath.row]

        cell.label1.text = category.0
        cell.label2.text = category.1

        cell.label2.isHidden = category.1.isEmpty

        cell.label1.backgroundColor = selectedCategories.contains(category.0) ? .black : .white
        cell.label1.textColor = selectedCategories.contains(category.0) ? .white : .gray

        cell.label2.backgroundColor = selectedCategories.contains(category.1) ? .black : .white
        cell.label2.textColor = selectedCategories.contains(category.1) ? .white : .gray

        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        cell.label1.addGestureRecognizer(tapGesture1)
        cell.label1.isUserInteractionEnabled = true

        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        cell.label2.addGestureRecognizer(tapGesture2)
        cell.label2.isUserInteractionEnabled = true

        return cell
    }

    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else { return }
        guard let text = label.text else { return }

        if selectedCategories.contains(text) {
            selectedCategories.removeAll { $0 == text }
            label.backgroundColor = .white
            label.textColor = .gray
        } else {
            selectedCategories.append(text)
            label.backgroundColor = .black
            label.textColor = .white
        }

        UserDefaults.standard.set(selectedCategories, forKey: "selectedCategories")
        print("Selected Categories: \(selectedCategories)")
    }

    @IBAction func doneBtnTapped(_ sender: Any) {
        if !selectedCategories.isEmpty {
            UserDefaults.standard.set(selectedCategories, forKey: "selectedCategories")

            if let expenseAmount = expenseAmount, let selectedCategory = selectedCategories.first {
                var expenses = UserDefaults.standard.array(forKey: "expenses") as? [[String: Any]] ?? []
                var lastExpense = expenses.removeLast()
                lastExpense["category"] = selectedCategory
                expenses.append(lastExpense)
                UserDefaults.standard.set(expenses, forKey: "expenses")
            }

            navigateBackToHome()
        } else {
            let alert = UIAlertController(title: "Select Categories", message: "Please select at least one category before proceeding.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    func saveCategories() {
        let categoryArrays = categories.map { [ $0.0, $0.1 ] }
        UserDefaults.standard.set(categoryArrays, forKey: "categories")
    }

    func loadCategories() {
        if let savedCategories = UserDefaults.standard.array(forKey: "categories") as? [[String]] {
            categories = savedCategories.map { ($0[0], $0[1]) }
        } else {
            categories = [("Food", "Mobile"), ("Electricity", "Gas"), ("Transport", "Fuel"), ("Education", "Internet"), ("House Rent", "Gaming"), ("Gym", "Health"), ("Medicine", "Pet"), ("Clothes", "Skin Care"), ("Entertainment", "Sport"), ("Coffee", "Drinks"), ("Online Packages", "Gift"), ("Shopping", "Beauty"), ("Trip", "Other")]
        }
    }

    func navigateBackToHome() {
        if let viewControllers = navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is HomeVC {
                    navigationController?.popToViewController(viewController, animated: true)
                    return
                }
            }
        }
        
    }
}
