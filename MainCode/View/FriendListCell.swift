//
//  CustomCell.swift
//  MainCode
//
//  Created by Apple on 4/22/19.
//  Copyright © 2019 Kien. All rights reserved.
//

import UIKit
import Firebase

class FriendListCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    var uid : String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  

}
