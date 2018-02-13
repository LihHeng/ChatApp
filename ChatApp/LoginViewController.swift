//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Lih Heng Yew on 08/02/2018.
//  Copyright © 2018 Lih Heng Yew. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit  //FacebookLogin PODS
import Firebase
import GoogleSignIn



class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    
    @IBOutlet weak var googleBtn: GIDSignInButton! {
        didSet {
            googleBtn.addTarget(self, action: #selector(glogin), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func nextButton(_ sender: Any) {
        signInTapped()
    }
    
    //Facebook Login Button
    @IBAction func facebookLoginButton(_ sender: Any) {
        FsigninTapped()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        if Auth.auth().currentUser != nil {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "navigationController") as? UINavigationController else {return}
            
            present(vc, animated: true, completion: nil)
        }
    }
    
    //MARK: SIGN IN USING OWN DATABASE:
    func signInTapped() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let validError = error {
                //show Alert
                self.showAlert(withTitle: "Error", message: validError.localizedDescription)
            }
            if let validUser = user {
                guard let navVC = self.storyboard?.instantiateViewController(withIdentifier: "navigationController") as? UINavigationController else {return}
                
                self.present(navVC, animated: true, completion: nil)
            }
        }
    }
    //MARK: SIGN IN USING FACEBOOK:
    func FsigninTapped() {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                // Present the main view
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "navigationController") {
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    // Facebook Authentication Code
    func facebookShowEmailAddress() {
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {return}
        let credential = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("Something went wrong with our FB user", error ?? "")
                return
            }
            print("Suceesfully login", user ?? "")
        }
    }
    

    @objc func glogin() {
        GIDSignIn.sharedInstance().signIn()
    }

}



// Facebook Login Delegates - To check whether the user has logged in
extension LoginViewController : FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        facebookShowEmailAddress()
        print("Successfully logged in with Facebook")
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("user Logged Out")
    }
}


extension LoginViewController : GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        //3
        if let error = error {return}
        guard let authentication = user.authentication else { return }
        let credentialG = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        // Sign in w Google
        Auth.auth().signIn(with: credentialG) { (user, error) in
            if let validError = error {
                //show Alert
                self.showAlert(withTitle: "Error", message: validError.localizedDescription)
                return
            }
            if let validUser = user {
                guard let navVC = self.storyboard?.instantiateViewController(withIdentifier: "navigationController") as? UINavigationController else {return}
                
                self.present(navVC, animated: true, completion: nil)
            }
        }
        
        
    }
}
