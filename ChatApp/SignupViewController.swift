//
//  SignupViewController.swift
//  ChatApp
//
//  Created by Ying Mei Lum on 09/02/2018.
//  Copyright © 2018 Lih Heng Yew. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignupViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var password1TextField: UITextField!
    @IBOutlet weak var password2TextField: UITextField!
    
    @IBAction func signUpButton(_ sender: Any) {
    //auth
        signUpUser()
    
    }
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    func signUpUser() {
        guard let email = emailTextField.text,
            let password = password1TextField.text,
            let confirmPassword = password2TextField.text else {return}

        if !email.contains("@") {
            //show error //if email not contain @
            showAlert(withTitle: "Invalid Email format", message: "Please input valid Email")
        } else if password.count < 7 {
            //show error
            showAlert(withTitle: "Invalid Password", message: "Password must contain 7 characters")
        } else if password != confirmPassword {
            //show error
            showAlert(withTitle: "Password Do Not Match", message: "Password must match")
        } else {
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                //ERROR HANDLING
                if let validError = error {
                    self.showAlert(withTitle: "Error", message: validError.localizedDescription)
                }
                
                //HANDLE SUCESSFUL CREATION OF USER
                if let validUser = user {
                    //do something
                    
                    let userPost: [String:Any] = ["email": email, "lastMessage": ""]
                    
                    self.ref.child("users").child(validUser.uid).setValue(userPost)
                    
                    guard let navVC = self.storyboard?.instantiateViewController(withIdentifier: "navigationController") as? UINavigationController else {return}
                    
                    self.present(navVC, animated: true, completion: nil)
                    print("sign up method successful")
                }
            })
        }
    }
}
