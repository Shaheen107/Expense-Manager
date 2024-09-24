import UIKit

extension UIViewController {
    
//    set image in navigation view 
    func setTitleImage(named imageName: String) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: imageName)
        navigationItem.titleView = imageView
    }
    
    
    
    
//    -- navigation Screens --
//    Sign In
    func navigateToSignInVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let signInVC = storyboard.instantiateViewController(identifier: "SignInVC") as? SignInVC{
            navigationController?.pushViewController(signInVC, animated: true)
        }
    }
    
//    Sign Up
     func navigateToSignUpVC(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
         if let SignUpVC = storyboard.instantiateViewController(identifier: "SignUpVC") as? SignUpVC{
             navigationController?.pushViewController(SignUpVC, animated: true)
         }
    }
    
}
