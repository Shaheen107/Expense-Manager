import UIKit
import Firebase
import GoogleSignIn

class SignUpVC: UIViewController {
    
    @IBOutlet var uiViewOutlet: [UIView]!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var emailOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        setupCornerRadius()
        setupTextFields()
    }
    
    private func setupCornerRadius() {
        let cornerRadius: CGFloat = 40.0
        for view in uiViewOutlet {
            view.layer.cornerRadius = cornerRadius
        }
    }
    
    private func setupTextFields() {
        emailOutlet.borderStyle = .none
        passwordOutlet.borderStyle = .none
        userName.borderStyle = .none

        emailOutlet.delegate = self
        passwordOutlet.delegate = self
        userName.delegate = self

        // Disable autofill for the password field to prevent the yellow background
        passwordOutlet.textContentType = .none
        passwordOutlet.autocorrectionType = .no
        passwordOutlet.spellCheckingType = .no
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        navigateToSignInVC()
    }

    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let email = emailOutlet.text, !email.isEmpty,
              let password = passwordOutlet.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Please fill in all fields.")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.showAlert(title: "Sign Up Error", message: error.localizedDescription)
                return
            }
            self.showAlert(title: "Success", message: "Account created successfully.", completion: {
                self.navigateToSelectCurrencyVC()
            })
        }
    }
    
    @IBAction func SignUpWithGoogleBtnTapped(_ sender: Any) {
        signInWithGoogle()
    }
    
    private func navigateToSelectCurrencyVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let selectCurrencyVC = storyboard.instantiateViewController(withIdentifier: "SelectCurrencyVC") as? SelectCurrencyVC {
            self.navigationController?.pushViewController(selectCurrencyVC, animated: true)
        }
    }
    
    private func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.showAlert(title: "Error", message: "Failed to sign in with Google: \(error.localizedDescription)")
                return
            }
            guard let user = result?.user else {
                strongSelf.showAlert(title: "\(Error.self)", message: "Google authentication failed")
                return
            }
            let idToken = user.idToken!.tokenString
            let accessToken = user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            FirebaseAuth.Auth.auth().signIn(with: credential) { userGD, error in
                guard userGD != nil, error == nil else {
                    if let error = error {
                        strongSelf.showAlert(title: "Error", message: "Firebase authentication error: \(error.localizedDescription)")
                    }
                    return
                }
                strongSelf.navigateToSelectCurrencyVC()
            }
        }
    }
}

extension SignUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
