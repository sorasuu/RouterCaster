//
//  NewMessageController.swift
//  
//
//
//  Created by Rmit on 4/24/19.
//  Copyright © 2019 SoraSuu. All rights reserved.
//


import UIKit
import Firebase

class NewMessageController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "cellId"
    @IBOutlet var tableView: UITableView!
    var users = [User]()

    
    @IBAction func didPressBack(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        
        self.dismiss(animated: false
            , completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
     fetchAllFriend()
    }
    
  
    private func fetchAllFriend(){
        let uid = Auth.auth().currentUser?.uid
        if uid != nil{
            Firestore.firestore().collection("friendship").whereField("user1_Id", isEqualTo: uid as Any).getDocuments(){
                (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let friendId1 = document.data()["user2_Id"] as? String
                        Firestore.firestore().collection("users").whereField("uid", isEqualTo: friendId1 as Any).getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                for document in querySnapshot!.documents {
                                    let friend = User()
                                    friend.email = document.data()["email"] as? String
                                    friend.name = document.data()["name"] as? String
                                    friend.profileImageUrl = document.data()["profileImageUrl"] as? String
                                    friend.uid = document["uid"] as? String
                                   self.users.append(friend)
                                    DispatchQueue.main.async(execute: {
                                        self.tableView.reloadData()
                                    })
                                }}}
                    }
                }
                
            }
            Firestore.firestore().collection("friendship").whereField("user2_Id", isEqualTo: uid as Any).getDocuments(){
                (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let friendId1 = document.data()["user1_Id"] as? String
                        Firestore.firestore().collection("users").whereField("uid", isEqualTo: friendId1 as Any).getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                for document in querySnapshot!.documents {
                                    let friend = User()
                                    friend.email = document.data()["email"] as? String
                                    friend.name = document.data()["name"] as? String
                                    friend.profileImageUrl = document.data()["profileImageUrl"] as? String
                                    friend.uid = document["uid"] as? String
                                    self.users.append(friend)
                                    DispatchQueue.main.async(execute: {
                                        self.tableView.reloadData()
                                    })
                                }}}
                    }
                }
                
            }
            
            
            
        }
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.profileImageUrl {            
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let pvc = (self.presentingViewController as! MessagesController)
        
        dismiss(animated: false) {
            print("Dismiss completed")
            let user = self.users[indexPath.row]
            pvc.showChatControllerForUser(user)
        }
    }

}








