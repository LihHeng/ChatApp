//
//  Chat.swift
//  ChatApp
//
//  Created by Lih Heng Yew on 09/02/2018.
//  Copyright © 2018 Lih Heng Yew. All rights reserved.
//

import Foundation

class Chat {
    
    var uid : String = ""
    var email : String = ""
    var message : String = ""
    var timeStamp : Double = 0
    
    init(uid: String, dict: [String:Any]) {
        
        self.uid = uid
        //?? let me set default value if nothing is found
        email = dict["email"] as? String ?? "no email"
        message = dict["msg"] as? String ?? "no msg"
        timeStamp = dict["timeStamp"] as? Double ?? 0
        
        message += "(\(timeStamp))"
    }
}
