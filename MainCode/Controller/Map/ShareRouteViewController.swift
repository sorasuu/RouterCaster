//
//  ShareRouteViewController.swift
//  UITest
//
//  Created by tang quang an on 4/29/19.
//  Copyright © 2019 tang quang an. All rights reserved.
//

import UIKit
import Firebase
class RouteSharingFriend {
    var name: String
    var image: String
    var isSelected: Bool
    var id : String
    var uid :String
    init(name: String, image: String, isSelected: Bool, uid: String,id:String) {
        self.name = name
        self.image = image
        self.isSelected = isSelected
        self.id = id
        self.uid = uid
        
    }
}
protocol ShareRouteViewControllerDelegate {
    func didCompleteShareList(shareList: [String])
}

class ShareRouteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var routeSharingArray = [RouteSharingFriend]()
    var shareUid = [String]()
    var shareList: [String] = []
    var delegate: ShareRouteViewControllerDelegate?
    
    
    private func fetchShareUsers(){
        print("fetching")
        let uid = Auth.auth().currentUser?.uid
        Firestore.firestore().collection("sharelocation").whereField("userId", isEqualTo:  uid as Any).whereField("status", isEqualTo: true).getDocuments(){
            (querySnapshot,err) in if (err != nil){
                print("fail to load ",err as Any)
            } else {
                for document in querySnapshot!.documents{
                    let friendId  = document.data()["sharedUserId"]
                    let id = document.documentID
                    let status = document.data()["status"]
                    print("friendId",friendId)
                    //                    let status = document.data()["status"] as! Bool
                    print("friendId:", friendId as Any)
                    Firestore.firestore().collection("users").whereField("uid", isEqualTo: friendId as Any).getDocuments(){
                        (querySnapshot,err) in if (err != nil){
                            print("faild to load ",err as Any)
                        } else {
                            
                            for document in querySnapshot!.documents{
                                let user = User()
                                
                                user.uid = document.data()["uid"] as? String
                                user.name = document.data()["name"] as? String
                                user.profileImageUrl = document.data()["profileImageUrl"] as? String
                                
                                print("lol",user.name as Any)
                                
                                if user.name != nil && user.uid != nil && user.profileImageUrl != nil{
                                    self.routeSharingArray.append(RouteSharingFriend(name: user.name!, image: user.profileImageUrl!, isSelected: status as! Bool, uid : user.uid!, id: id as! String))
                                    DispatchQueue.main.async {
                                        self.friendListTableView.reloadData()
//                                        self.preSelectFriend()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func preSelectFriend() {
        // Load for user previous selection
        for (friendId) in shareList {
            if let friendOffset = routeSharingArray.firstIndex(where: {$0.uid == friendId}) {
                self.friendListTableView.selectRow(at: IndexPath.init(row: friendOffset, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.middle)
            }
        }
    }
    
    @IBOutlet weak var friendListTableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeSharingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MapFriendCell
        cell.label.text = routeSharingArray[indexPath.row].name
        cell.imageProfile.loadImageUsingCacheWithUrlString( routeSharingArray[indexPath.row].image)
        return cell
    }

    @IBAction func didPressDone(_ sender: UIButton) {
        
        if let selectedRows = friendListTableView.indexPathsForSelectedRows {
            
            self.shareList = []
            for index in selectedRows {
                shareList.append(routeSharingArray[index.item].uid)
            }
            
            delegate?.didCompleteShareList(shareList: shareList)
        }
        
        self.removeAnimate()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchShareUsers()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.init(displayP3Red: 0, green: 0, blue: 0, alpha: 0.1)
//        self.view.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.7)
        
        self.showAnimate()
        
        friendListTableView.delegate = self
        friendListTableView.dataSource = self
        friendListTableView.isEditing = true
        friendListTableView.allowsMultipleSelectionDuringEditing = true
        
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }) { completed in
            self.view.removeFromSuperview()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
