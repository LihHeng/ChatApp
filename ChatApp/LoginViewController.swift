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



class LoginViewController: UIViewController {
    @IBOutlet weak var googleImageView: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        signInTapped()
    
    }

    
    //Facebook Login Button
    @IBAction func facebookLoginButton(_ sender: Any) {
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
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                }
                
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if Auth.auth().currentUser != nil {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "navigationController") as? UINavigationController else {return}
            
            present(vc, animated: true, completion: nil)
        
            
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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








