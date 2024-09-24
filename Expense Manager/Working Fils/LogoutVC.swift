import UIKit
import Firebase

class LogoutVC: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        displayUserData()
    }
    
    private func displayUserData() {
        guard let user = Auth.auth().currentUser else { return }
        
        // Assuming you stored the username and password in the user's profile or somewhere else
        userNameLabel.text = user.displayName ?? "No username available"
        emailLabel.text = user.email ?? "No email available"
        
        // Firebase doesn't store the password, so if you want to show it,
        // you'll need to handle storing and retrieving it securely yourself.
        passwordLabel.text = "******" // For security, you might want to mask this or not show it at all.
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            SignInVC()
        } catch let signOutError as NSError {
            showAlert(title: "Logout Error", message: signOutError.localizedDescription)
        }
    }
    
    private func SignInVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInVC") as? SignInVC {
            // Access the scene delegate to change the root view controller
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController = signInVC
                sceneDelegate.window?.makeKeyAndVisible()
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
