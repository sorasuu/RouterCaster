//
//  SparkModels.swift
//  TestingFirestoreAuth
//
//  Created by Sora suu on 4/8/19.
//  Copyright © 2019 Sora suu. All rights reserved.
//

import Foundation

protocol DocumentSerializable {
    init?(documentData: [String: Any])
}

struct SparkUser {
    let uid: String
    let name: String
    let email: String
    let profileImageUrl: String
//    let phone: String
//    let friends: [String]
    
    var dictionary: [String: Any] {
        return [
            SparkKeys.SparkUser.uid: uid,
            SparkKeys.SparkUser.name: name,
            SparkKeys.SparkUser.email: email,
            SparkKeys.SparkUser.profileImageUrl: profileImageUrl,
//            SparkKeys.SparkUser.phone: phone,
//            SparkKeys.SparkUser.friends: friends
        ]
    }
}

extension SparkUser: DocumentSerializable {
    init?(documentData: [String : Any]) {
        guard
            let uid = documentData[SparkKeys.SparkUser.uid] as? String,
            let name = documentData[SparkKeys.SparkUser.name] as? String,
            let email = documentData[SparkKeys.SparkUser.email] as? String,
            let profileImageUrl = documentData[SparkKeys.SparkUser.profileImageUrl] as? String
//            let phone = documentData[SparkKeys.SparkUser.phone] as? String,
//            let friends = documentData[SparkKeys.SparkUser.friends] as? [String]
            else { return nil }
        self.init(uid: uid,
                  name: name,
                  email: email,
                  profileImageUrl: profileImageUrl
//                  phone: phone,
//                  friends: friends
        )
    }
}
