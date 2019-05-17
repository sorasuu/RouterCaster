//
//  LocationSharingViewController.swift
//  Setting
//
//  Created by tang quang an on 5/9/19.
//  Copyright © 2019 Setting. All rights reserved.
//

import UIKit
import Firebase
class LocationSharingFriend {
    var name: String
    var image: String
    var isSelected: Bool
    var uid : String
    init(name: String, image: String, isSelected: Bool, uid: String) {
        self.name = name
        self.image = image
        self.isSelected = isSelected
        self.uid = uid
    }
}
class LocationSharingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
   
    
    var locationSharingArray = [LocationSharingFriend]()
    var shareUid = [String]()

    
    private func fetchShareUsers(){
        print("fetching")
        let uid = Auth.auth().currentUser?.uid
        Firestore.firestore().collection("sharelocation").whereField("userId", isEqualTo:  uid as Any).getDocuments(){
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
                                    self.locationSharingArray.append(LocationSharingFriend(name: user.name!, image: user.profileImageUrl!, isSelected: true, uid: id as! String ))
                                    DispatchQueue.main.async {
                                      self.friendListTableView.reloadData()
                                        self.preSelectFriend()
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
        for (i, selectedFriend) in locationSharingArray.enumerated() {
            if (selectedFriend.isSelected) {
                self.friendListTableView.selectRow(at: IndexPath.init(row: i, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.middle)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationSharingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LocationSharingFriendCell
        cell.label.text = locationSharingArray[indexPath.row].name
        cell.imageProfile.loadImageUsingCacheWithUrlString(locationSharingArray[indexPath.row].image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Firestore.firestore().collection("sharelocation").document(locationSharingArray[indexPath.row].uid).setData(["status": true],merge: true)
        print("true")
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        Firestore.firestore().collection("sharelocation").document(locationSharingArray[indexPath.row].uid).setData(["status": false],merge: true)
        print("false")
    }
    
    @IBAction func didPressMark(_ sender: UIButton) {
        if (sender.titleLabel?.text == "Mark All") {
            for (i, _) in locationSharingArray.enumerated() {
                self.friendListTableView.selectRow(at: IndexPath.init(row: i, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.middle)

                Firestore.firestore().collection("sharelocation").document(locationSharingArray[i].uid).setData(["status": true],merge: true)
            }
            sender.setTitle("Unmark All", for: .normal)
        } else if (sender.titleLabel?.text == "Unmark All") {
            for (i, _) in locationSharingArray.enumerated() {
                self.friendListTableView.deselectRow(at: IndexPath.init(row: i, section: 0), animated: true)

                Firestore.firestore().collection("sharelocation").document(locationSharingArray[i].uid).setData(["status": false],merge: true)

            }
            sender.setTitle("Mark All", for: .normal)
        }
    }
    
    
    @IBAction func didPressBack(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false) {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Load the location sharing state from the user
        friendListTableView.delegate = self
        friendListTableView.dataSource = self
        friendListTableView.isEditing = true
        // Check for location sharing
        friendListTableView.allowsMultipleSelectionDuringEditing = true
        fetchShareUsers()

    }
    
    @IBOutlet weak var friendListTableView: UITableView!
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
