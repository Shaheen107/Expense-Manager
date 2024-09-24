import UIKit

class FirstScreenStartVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setTitleImage(named: "leftBar")
    }
    
    @IBAction func skipBtnTapped(_ sender: Any) {
        navigateToSelectCurrencyVC()
    }
    
    private func navigateToSelectCurrencyVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let selectCurrencyVC = storyboard.instantiateViewController(withIdentifier: "SelectCurrencyVC") as? SelectCurrencyVC {
            self.navigationController?.pushViewController(selectCurrencyVC, animated: true)
        }
    }
    
}

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setTitleImage(named: "midBar")
    }
    
    @IBAction func skipBtnTapped(_ sender: Any) {
        navigateToSelectCurrencyVC()
    }
    
    private func navigateToSelectCurrencyVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let selectCurrencyVC = storyboard.instantiateViewController(withIdentifier: "SelectCurrencyVC") as? SelectCurrencyVC {
            self.navigationController?.pushViewController(selectCurrencyVC, animated: true)
        }
    }
    
}

class ThirdViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setTitleImage(named: "rightBar")
    }
    @IBAction func getStartedBtnTapped(_ sender: Any) {
        navigateToSelectCurrencyVC()
    }
    
    @IBAction func skipBtnTapped(_ sender: Any) {
        navigateToSelectCurrencyVC()
    }
    private func navigateToSelectCurrencyVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let selectCurrencyVC = storyboard.instantiateViewController(withIdentifier: "SelectCurrencyVC") as? SelectCurrencyVC {
            self.navigationController?.pushViewController(selectCurrencyVC, animated: true)
        }
    }
    
}

