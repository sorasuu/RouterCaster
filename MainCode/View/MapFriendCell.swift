//
//  MapFriendCell.swift
//  UITest
//
//  Created by tang quang an on 4/29/19.
//  Copyright © 2019 tang quang an. All rights reserved.
//

import UIKit

class MapFriendCell: UITableViewCell {

    
    @IBOutlet weak var imageProfile: UIImageView!

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {}
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)
        let viewForHighlight = UIView()
        self.selectedBackgroundView = viewForHighlight
        if self.isEditing {
            viewForHighlight.backgroundColor = UIColor.clear
        } else {
            viewForHighlight.backgroundColor = UIColor.gray
        }
    }

}
