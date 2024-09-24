import UIKit

protocol AddGoalVCDelegate: AnyObject {
    func didAddGoal(_ goal: Goal)
}

class AddGoalVC: UIViewController {
    
    @IBOutlet weak var goalName: UITextField!
    @IBOutlet weak var setGoalAmount: UITextField!
    @IBOutlet weak var goalSetDate: UIDatePicker!
    
    @IBOutlet weak var uiview: UIView!
    
    weak var delegate: AddGoalVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        uiview.layer.cornerRadius = 36
        goalSetDate.overrideUserInterfaceStyle = .dark
    }
    
    @IBAction func setGoalBtnTapped(_ sender: Any) {
        guard let name = goalName.text, !name.isEmpty,
              let amountText = setGoalAmount.text, let amount = Double(amountText) else {
            // Show error message if input is invalid
            return
        }
        
        let goal = Goal(name: name, amount: amount, date: goalSetDate.date)
        delegate?.didAddGoal(goal)
        navigationController?.popViewController(animated: true)
    }
}
