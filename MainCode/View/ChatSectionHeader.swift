//
//  ChatSectionHeader.swift
//  MainCode
//
//  Created by tang quang an on 5/14/19.
//  Copyright © 2019 Kien. All rights reserved.
//

import UIKit

class ChatSectionHeader: UICollectionReusableView {
    
    let timeLb: UILabel = {
       let myLb = UILabel()
        return myLb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.timeLb)
        timeLb.font = UIFont(name: "Avenir", size: 14)
        timeLb.textColor = .gray
        timeLb.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 25)
        timeLb.translatesAutoresizingMaskIntoConstraints = false
        timeLb.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        timeLb.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
