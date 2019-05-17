//
//  AddFriendCell.swift
//  MainCode
//
//  Created by Apple on 5/2/19.
//  Copyright © 2019 Kien. All rights reserved.
//

import UIKit
import Firebase

class AddFriendCell: UITableViewCell {
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var addButtonView: UIView!
    @IBOutlet weak var cancelButtonView: UIView!
    
    var uid : String!
    let currentUserId = Auth.auth().currentUser?.uid
    
    fileprivate func createFriendRequest(){
        let id = currentUserId! + uid
        Firestore.firestore().collection("friendrequest").addDocument(data: ["id": id ,"senderId": currentUserId as Any, "receiverId": uid as Any])
        
    }
    fileprivate func cancelFriendRequest(){
        let id = currentUserId! + uid
        Firestore.firestore().collection("friendrequest").whereField("id", isEqualTo: id).getDocuments(){
            (querysnapshot,err) in if (err != nil){
                print("cancel error",err as Any)
            }else{
                for document in querysnapshot!.documents{
                    document.reference.delete()
                }
            }
        }
    }
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
        createFriendRequest()
        
        
    }
    @IBAction func cancelButton(_ sender: UIButton) {
        addButtonView.isHidden = false
        cancelButtonView.isHidden = true
        cancelFriendRequest()
    }
    
}
