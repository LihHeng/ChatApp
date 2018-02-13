//
//  ContactsViewController.swift
//  ChatApp
//
//  Created by Ying Mei Lum on 09/02/2018.
//  Copyright © 2018 Lih Heng Yew. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class ContactsViewController: UIViewController {
    
  
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
        }
    }
    @IBAction func logoutBtnTapped(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch {
              FBSDKLoginManager().logOut()
             self.dismiss(animated: true, completion: nil)
        }
        GIDSignIn.sharedInstance().signOut()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    var ref: DatabaseReference!
    var contacts : [User] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
       
    }

    
    func observeFirebase() {
        
        ref.child("users").observe(.value) { (snapshot) in
            print("testing")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        ref.child("users").observe(.childAdded) { (snapshot) in
            
            guard let userDict = snapshot.value as? [String:Any] else {return}
            
            let contact = User(uid: snapshot.key, dict: userDict)
            
            DispatchQueue.main.async {
                self.contacts.append(contact)
                let indexPath = IndexPath(row: self.contacts.count - 1, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
            
            print(snapshot.key)
            
            print("testing")
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

   

}

extension ContactsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = contacts[indexPath.row].name
        cell.detailTextLabel?.text = contacts[indexPath.row].email
        
        return cell
    }
}
