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
            tableView.delegate = self
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
    var messages : [Message] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        observeFirebase()
       
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

}

extension ContactsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(contacts.count)
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = contacts[indexPath.row].email
        cell.detailTextLabel?.text = contacts[indexPath.row].name
//        cell.detailTextLabel?.text = messages[indexPath.row].lastMessage
        
        return cell
    }
}

extension ContactsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = contacts[indexPath.row]

        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController else {return}
        vc.contact = contact
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

