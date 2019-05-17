//
//  SparkSetup.swift
//  TestingFirestoreAuth
//
//  Created by Sora suu on 4/8/19.
//  Copyright © 2019 Sora suu. All rights reserved.
//

import Firebase

extension Spark {
    static let Firestore_Users_Collection = firestoreDatabase.collection(SparkKeys.CollectionPath.users)
    static let Storage_Profile_Images = Storage.storage().reference().child(SparkKeys.StorageFolder.profileImages)
}
