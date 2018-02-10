//
//  User.swift
//  ChatApp
//
//  Created by Ying Mei Lum on 09/02/2018.
//  Copyright © 2018 Lih Heng Yew. All rights reserved.
//

import Foundation

class User {
    
    var uid : String = ""
    var email : String = ""
    var name : String = ""
    
    init(uid: String, dict: [String:Any]) {
        
        self.uid = uid
        self.email = dict["email"] as? String ?? "no email"
        self.name = dict["name"] as? String ?? "No name"
    }
}
