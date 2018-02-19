//
//  Chat.swift
//  ChatApp
//
//  Created by Lih Heng Yew on 09/02/2018.
//  Copyright © 2018 Lih Heng Yew. All rights reserved.
//

import Foundation

class Chat {
    
    var messages : [Message] = []
    
    var chatID : String = ""
    var userID1 : String = ""
    var userID2 : String = ""

    init(chatID: String, dict: [String:Any]) {
        self.chatID = chatID
        userID1 = dict["userID1"] as? String ?? "no userID1"
        userID2 = dict["userID2"] as? String ?? "no userID2"
    }
}

class Message {
    
    var uid : String = ""
    var email : String = ""
    var message : String = ""
    var timeStamp : NSNumber = 0
    
    init(uid: String, dict: [String:Any]) {
        
        self.uid = uid
        //?? set default value if nothing is found
        email = dict["email"] as? String ?? "no email"
        message = dict["msg"] as? String ?? "no msg"
        timeStamp = dict["timeStamp"] as? NSNumber ?? 0

        
//        message += "(\(timeStamp))"
        
        let seconds = timeStamp.doubleValue
        let timestampDate = NSDate(timeIntervalSince1970: seconds)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        
        message += "(\(dateFormatter.string(from: timestampDate as Date)))"
    }
}
