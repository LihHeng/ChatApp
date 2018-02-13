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
    var contact : User!
    var chats : Chat!
    var messages : [Message] = []
    var conversationCount : Int = 0
    var chatID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let sender = Auth.auth().currentUser?.uid else {return}
        let receiver = contact.uid
        chatID = [sender,receiver].sorted().joined()
        ref = Database.database().reference()
        observeChat()
    }
    
    @objc func sendMessage() {
        guard let message = inputTextField.text else {return}
        guard let email = Auth.auth().currentUser?.email else {return}
        let timeStamp = Date().timeIntervalSince1970
        guard let sender = Auth.auth().currentUser?.uid else {return}
        let receiver = contact.uid
        
        let participants = ["sender" : sender, "receiver" : receiver]
        let userPost: [String:Any] = ["email": email, "msg" : message, "timeStamp" : timeStamp]

        let chatRef = self.ref.child("chat").childByAutoId()
        
        self.ref.child("chats").child(chatID).child("messages").childByAutoId().setValue(userPost)
        self.ref.child("chats").child(chatID).child("participants").setValue(participants)
        
//        self.ref.child("users").child(String(sender)).child("chat").child(chatRef.key).setValue(true)
//        self.ref.child("users").child(String(receiver)).child("chat").child(chatRef.key).setValue(true)
    }
    
    func observeChat() {
        
        ref.child("chats").child(chatID).child("messages").queryOrdered(byChild: "timeStamp").observe(.childAdded) { (snapshot) in
            guard let chatDict = snapshot.value as? [String:Any] else {return}
            //let message = Chat(uid: snapshot.key, dict: chatDict)
            let message = Message(uid: snapshot.key, dict: chatDict)
            
            DispatchQueue.main.async {
                self.messages.append(message)
                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
            print(snapshot.key)
        }
        
        ref.child("chat").observe(.childRemoved) { (snapshot) in
            print(snapshot.key + "child remove")
        }
        ref.child("chats").observe(.childChanged) { (snapshot) in
            print(snapshot.key + "child changed")
        }
        
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
        cell.textLabel?.text = messages[indexPath.row].email
        cell.detailTextLabel?.text = messages[indexPath.row].message
        return cell
    }
}
