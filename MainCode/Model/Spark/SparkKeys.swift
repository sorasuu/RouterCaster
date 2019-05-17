//
//  SparkSafeKeys.swift
//  TestingFirestoreAuth
//
//  Created by Sora suu on 4/8/19.
//  Copyright © 2019 Sora suu. All rights reserved.
//

import Foundation

struct SparkKeys {
    
    struct SparkUser {
        static let uid = "uid"
        static let name = "name"
        static let email = "email"
        static let profileImageUrl = "profileImageUrl"
        static let accountType = "accountType"
//        static let phone = "phone"
//        static let friends = "friends"
    }
    
    struct CollectionPath {
        static let users = "users"
    }
    
    struct StorageFolder {
        static let profileImages = "profileImages"
    }
}
