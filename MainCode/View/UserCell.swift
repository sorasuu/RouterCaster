//
//  UserCell.swift
//  gameofchats
//
//  Created by Brian Voong on 7/8/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    
    var message: Message? {
        didSet {
            setupNameAndProfileImage()
            
            detailTextLabel?.text = message?.text
            
            if let seconds = message?.timestamp?.doubleValue {
                let timestampDate = Date(timeIntervalSince1970: seconds)
                
                let calendar = Calendar.current
                let dateFormatter = DateFormatter()
                if (calendar.isDateInToday(timestampDate)) {
                    dateFormatter.dateFormat = "hh:mm"
                } else {
                    dateFormatter.dateFormat = "MM/dd"
                }
                timeLabel.text = dateFormatter.string(from: timestampDate)
            }
            
            
        }
    }
    
    fileprivate func setupNameAndProfileImage() {
        
        if let id = message?.chatPartnerId() {Firestore.firestore().collection("users").whereField("uid", isEqualTo: id).getDocuments(){(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                DispatchQueue.main.async {
                    for document in querySnapshot!.documents {
                       let dictionary = document.data()
                        self.textLabel?.text = dictionary["name"] as? String
                            if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                    self.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)}
                    }
                    
                }}
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.font = UIFont.init(name: "Avenir", size: 22)
        detailTextLabel?.font = UIFont.init(name: "Avenir", size: 18)
        
        textLabel?.frame = CGRect(x: 107, y: textLabel!.frame.origin.y - 2, width: timeLabel.frame.origin.x - (textLabel?.frame.origin.x)! - 10, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 107, y: detailTextLabel!.frame.origin.y + 2, width: timeLabel.frame.origin.x - (textLabel?.frame.origin.x)! - 10, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
//        label.text = "HH:MM:SS"
        label.font = UIFont.init(name: "Avenir", size: 14)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(timeLabel)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 21).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 68).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 68).isActive = true
        
        //need x,y,width,height anchors
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -27).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 38).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 19).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
