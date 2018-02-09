//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Lih Heng Yew on 08/02/2018.
//  Copyright © 2018 Lih Heng Yew. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var googleImageView: UIImageView!
    
    @IBOutlet weak var facebookImageView: UIImageView!
    
    @IBOutlet weak var userTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func nextButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

