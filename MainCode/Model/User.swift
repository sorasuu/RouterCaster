//
//  User.swift
//  MainCode
//
//  Created by Sora suu on 5/8/19.
//  Copyright © 2019 Sorasuu. All rights reserved.
//


import UIKit

class User: NSObject {
    var name: String?
    var email: String?
    var profileImageUrl: String?
    var uid:  String?
    var accountType: String?
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
        self.uid = dictionary["uid"] as? String
        self.accountType = dictionary["accountType"] as? String
    }
    override init() {
        
    }
}
