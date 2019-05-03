//
//  AddFriendCell.swift
//  MainCode
//
//  Created by Apple on 5/2/19.
//  Copyright © 2019 Kien. All rights reserved.
//

import UIKit

class AddFriendCell: UITableViewCell {
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var addButtonView: UIView!
    @IBOutlet weak var cancelButtonView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addButton(_ sender: UIButton) {
        addButtonView.isHidden = true
        cancelButtonView.isHidden = false
    }
    @IBAction func cancelButton(_ sender: UIButton) {
        addButtonView.isHidden = false
        cancelButtonView.isHidden = true
    }
    
}
