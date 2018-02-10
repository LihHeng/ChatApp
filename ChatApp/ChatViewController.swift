//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Ying Mei Lum on 09/02/2018.
//  Copyright © 2018 Lih Heng Yew. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton! {
        didSet {
            sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        }
    }
    
    var ref : DatabaseReference!
    var chats : [Chat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeChat()
    }
    
    @objc func sendMessage() {
        guard let message = inputTextField.text else {return}
        guard let email = Auth.auth().currentUser?.email else {return}
        let timeStamp = Date().timeIntervalSince1970
        let userPost: [String:Any] = ["email": email, "msg" : message, "timeStamp" : timeStamp]
        //add to database
        self.ref.child("chat").childByAutoId().setValue(userPost)
        //        self.ref.child("chat").remove
    }
    
    func observeChat() {
        ref.child("chat").queryOrdered(byChild: "timeStamp").observe(.childAdded) { (snapshot) in
            guard let chatDict = snapshot.value as? [String:Any] else {return}
            let message = Chat(uid: snapshot.key, dict: chatDict)
            
            DispatchQueue.main.async {
                self.chats.append(message)
                let indexPath = IndexPath(row: self.chats.count - 1, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
            print(snapshot.key)
        }
        
        ref.child("chat").observe(.childRemoved) { (snapshot) in
            print(snapshot.key + "child remove")
        }
        ref.child("chat").observe(.childChanged) { (snapshot) in
            print(snapshot.key + "child changed")
        }
        
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
        cell.textLabel?.text = chats[indexPath.row].email
        cell.detailTextLabel?.text = chats[indexPath.row].message
        return cell
    }
}
