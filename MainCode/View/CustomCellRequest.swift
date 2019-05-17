//
//  CustomCellRequest.swift
//  MainCode
//
//  Created by Apple on 4/23/19.
//  Copyright © 2019 Kien. All rights reserved.
//

import UIKit
import Firebase

protocol TableViewRequest {
    func onClickAccept(index: Int)
    func onClickDeny(index: Int)
}


class CustomCellRequest: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    
    var uid : String!
    var cellDelegate: TableViewRequest?
    var index: IndexPath?
    let currentUserId = Auth.auth().currentUser?.uid
    
    fileprivate func createFriendShip(){
        let id = currentUserId! + uid
        Firestore.firestore().collection("friendship").addDocument(data: ["id": id ,"user2_Id": currentUserId as Any, "user1_Id": uid as Any])
        Firestore.firestore().collection("sharelocation").addDocument(data: [ "sharedUserId": currentUserId as Any, "userId":uid as Any,"status": true ])
        Firestore.firestore().collection("sharelocation").addDocument(data: [ "sharedUserId": uid as Any, "userId":currentUserId as Any,"status": true ])
        let properties = ["text": "Hi there I'm your friend now"]
        sendMessageWithProperties(properties as [String : AnyObject])
    }
    fileprivate func deleteFriendRequest(){
        print("start delete")
        Firestore.firestore().collection("friendrequest").whereField("senderId", isEqualTo: uid as Any).whereField("receiverId", isEqualTo: currentUserId as Any).getDocuments(){
            (querysnapshot,err) in if (err != nil){
                print("cancel error",err as Any)
            }else{
                for document in querysnapshot!.documents{
                    document.reference.delete()
                    print("deleted")
                }
            }
        }
    }
    fileprivate func sendMessageWithProperties(_ properties: [String: AnyObject]) {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        
        let fromId = Auth.auth().currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        
        var values: [String: AnyObject] = ["toId": uid as AnyObject, "fromId": fromId as AnyObject, "timestamp": timestamp as AnyObject]
        
        //append properties dictionary onto values somehow??
        //key $0, value $1
        properties.forEach({values[$0] = $1})
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            
            guard let messageId = childRef.key else { return }
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(self.uid).child(messageId)
            userMessagesRef.setValue(1)
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(self.uid).child(fromId).child(messageId)
            recipientUserMessagesRef.setValue(1)
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
    
    @IBAction func acceptButton(_ sender: UIButton) {
        cellDelegate?.onClickAccept(index: index!.row)
        createFriendShip()
        deleteFriendRequest()
    }
    
    @IBAction func denyButton(_ sender: UIButton) {
        cellDelegate?.onClickDeny(index: index!.row)
        deleteFriendRequest()
    }
    
}
