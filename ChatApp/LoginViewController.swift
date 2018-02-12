//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Lih Heng Yew on 08/02/2018.
//  Copyright © 2018 Lih Heng Yew. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBOutlet weak var googleImageView: GIDSignInButton! {
        didSet {
//            Auth.auth().signIn(with: credential) { (user, error) in
//                if let error = error {
//                    // ...
//                    return
//                }
//            }
//            
//            
//            Auth.auth().signIn(with: <#T##AuthCredential#>, completion: <#T##AuthResultCallback?##AuthResultCallback?##(User?, Error?) -> Void#>)
        }
    }
        
        
        
        @IBOutlet weak var emailTextField: UITextField!
        
        @IBOutlet weak var passwordTextField: UITextField!
        
        @IBAction func nextButton(_ sender: Any) {
        signInTapped()
        }
        
        override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if Auth.auth().currentUser != nil {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "navigationController") as? UINavigationController else {return}
        
        present(vc, animated: true, completion: nil)
        }
//            GIDSignIn.sharedInstance().delegate = self as! GIDSignInDelegate
//        GIDSignIn.sharedInstance().signIn()
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

    
extension LoginViewController: GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        //do something
        
    }
}
