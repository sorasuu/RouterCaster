//
//  SelectedFriendLocation.swift
//  MainCode
//
//  Created by tang quang an on 5/15/19.
//  Copyright © 2019 Kien. All rights reserved.
//

import Foundation

class SelectedFriendLocation {
    let friendID: String
    var willDisplay: Bool
    
    init(friendID: String, willDisplay: Bool) {
        self.friendID = friendID
        self.willDisplay = willDisplay
    }
}
