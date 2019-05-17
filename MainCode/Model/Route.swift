//
//  Route.swift
//  MainCode
//
//  Created by tang quang an on 5/16/19.
//  Copyright © 2019 Kien. All rights reserved.
//

import Foundation
class Route: NSObject {
    var distance: String?
    var gms : String?
    var endDate : String?
    var id : String?
    var status : Bool?
    var time : String?
    var userId : String?
    init(dictionary: [String : Any]) {
        self.distance = dictionary["distance"] as? String
        self.gms = dictionary["gms"] as? String
        self.endDate = dictionary["endDate"] as? String
        self.status = dictionary["status"] as? Bool
        self.time = dictionary["time"] as? String
        self.userId = dictionary["userId"] as? String
        self.id = dictionary["id"] as? String
    }
    override init() {
    }
}
