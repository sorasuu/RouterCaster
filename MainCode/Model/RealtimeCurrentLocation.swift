//
//  RealtimeLocation.swift
//  MainCode
//
//  Created by tang quang an on 5/15/19.
//  Copyright © 2019 Kien. All rights reserved.
//
import UIKit

class RealtimeCurrentLocation: NSObject{
    var latti: String?
    var longti: String?
    var userId: String?
    var lid : String?
    init(dictionary: [String: Any]) {
        self.latti = dictionary["lati"] as? String
        self.longti = dictionary["longti"] as? String
        self.userId = dictionary["userId"] as? String
        self.lid = dictionary["lid"] as? String
    }
    override init() {
        
    }
}

