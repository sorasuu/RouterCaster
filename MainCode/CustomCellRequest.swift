//
//  CustomCellRequest.swift
//  MainCode
//
//  Created by Apple on 4/23/19.
//  Copyright © 2019 Kien. All rights reserved.
//

import UIKit

protocol TableViewRequest {
    func onClickAccept(index: Int)
    func onClickDeny(index: Int)
}


class CustomCellRequest: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    
    var cellDelegate: TableViewRequest?
    var index: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func acceptButton(_ sender: UIButton) {
        cellDelegate?.onClickAccept(index: index!.row)
    }
    
    @IBAction func denyButton(_ sender: UIButton) {
        cellDelegate?.onClickDeny(index: index!.row)
    }
    
}
