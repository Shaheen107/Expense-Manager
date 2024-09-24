import UIKit

class SelectCurrencyVC: UIViewController {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var label7: UILabel!
    
    var selectedVariable: String = ""
    
    // Default label properties
    let defaultLabelColor = UIColor.white
    let defaultTextColor = UIColor.gray
    let borderColor = UIColor.darkGray.cgColor
    let borderWidth: CGFloat = 0.6
    let cornerRadius: CGFloat = 10.0
    
    var labels = [UILabel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .always
        
        // Add labels to array
        labels = [label1, label2, label3, label4, label5, label6, label7]
        
        // Enable user interaction and set default properties for labels
        for label in labels {
            label.isUserInteractionEnabled = true
            setupLabel(label: label)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
            label.addGestureRecognizer(tapGesture)
        }
    }
    
    func setupLabel(label: UILabel) {
        label.backgroundColor = defaultLabelColor
        label.textColor = defaultTextColor
        label.layer.cornerRadius = cornerRadius
        label.layer.masksToBounds = true
        label.layer.borderColor = borderColor
        label.layer.borderWidth = borderWidth
        label.textAlignment = .left // Center align the text for better appearance
    }

    // Actions for label taps
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedLabel = sender.view as? UILabel else { return }
        
        // Reset all labels to default color
        resetLabelColors()
        
        // Change tapped label color to black
        tappedLabel.backgroundColor = UIColor.black
        tappedLabel.textColor = UIColor.white
        
        // Save selected label text in UserDefaults
        if let text = tappedLabel.text {
            selectedVariable = text
        }
    
    }
    
    // Function to reset label colors
    func resetLabelColors() {
        for label in labels {
            setupLabel(label: label)
        }
    }
    
    @IBAction func selectBtnTapped(_ sender: Any) {
        if !(selectedVariable == "")  {
            UserDefaults.standard.set(selectedVariable, forKey: "selectedLabelText")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let newAccoutVC = storyboard.instantiateViewController(identifier: "NewAccountVC") as? NewAccountVC {
                navigationController?.pushViewController(newAccoutVC, animated: true)
            }
        } else {
            // No label selected, show alert
            let alert = UIAlertController(title: "Select Currency", message: "Please select a currency type before proceeding.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}
