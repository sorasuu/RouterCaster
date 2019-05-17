//
//  ShowFriendRouteLocationViewController.swift
//  MainCode
//
//  Created by Apple on 5/4/19.
//  Copyright © 2019 Kien. All rights reserved.
//

import UIKit
import Firebase
protocol ShowFriendRouteLocationViewControllerDelegate {
    func didSelectFriendsRouteLocation()
}

class FriendRouteLocationList {
    var name: String
    var image: String
    var isSelected: Bool
    var uid : String
    init(name: String, image: String, isSelected: Bool, uid : String) {
        self.name = name
        self.image = image
        self.isSelected = isSelected
        self.uid = uid
    }
}

class ShowFriendRouteLocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var segmentsView: UISegmentedControl!
    @IBOutlet weak var friendTableView: UITableView!
    @IBOutlet weak var friendLocationTableView: UITableView!
    
    var friendRouteLocationListArray: [FriendRouteLocationList] = []
    var friendLocationListArray: [FriendRouteLocationList] = []
    var delegate: ShowFriendRouteLocationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchShareLocationUser()
        fetchShareRouteUser()
        setUpFriendList()
        setUpFriendLocationList()
        friendTableView.delegate = self
        friendTableView.dataSource = self
        friendTableView.isEditing = true
        friendTableView.allowsMultipleSelectionDuringEditing = true
        
        friendLocationTableView.delegate = self
        friendLocationTableView.dataSource = self
        friendLocationTableView.isEditing = true
        friendLocationTableView.allowsMultipleSelectionDuringEditing = true

        
        
//        // Pre-select
//        for (i, selectedFriendRoute) in friendRouteLocationListArray.enumerated() {
//            if (selectedFriendRoute.isSelected) {
//                self.friendTableView.selectRow(at: IndexPath.init(row: i, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.middle)
//            }
//        }
        
        self.view.backgroundColor = UIColor.init(displayP3Red: 0, green: 0, blue: 0, alpha: 0.0)
        // Do any additional setup after loading the view.
    }
    func fetchShareLocationUser() {
        var newSelectedFriendLocationList: [SelectedFriendLocation] = []
        let currentUserId = Auth.auth().currentUser?.uid
        Firestore.firestore().collection("sharelocation").whereField("sharedUserId", isEqualTo:  currentUserId as Any).whereField("status", isEqualTo: true).getDocuments(){
            (querySnapshot,err) in if (err != nil){
                print("fail to load ",err as Any)
            } else {
                var newSelectedFriendLocationList: [SelectedFriendLocation] = []
                for document in querySnapshot!.documents{
                    let friendId  = document.data()["userId"]
//                    let status = document.data()["status"] as! Bool
                    print("friendId:", friendId as Any)
                        Firestore.firestore().collection("users").whereField("uid", isEqualTo: friendId as Any).getDocuments(){
                            (querySnapshot,err) in if (err != nil){
                                print("faild to load ",err as Any)
                            } else {
                                
                                if let selectedFriendLocation = selectedFriendLocationList.first(where: {$0.friendID == friendId as! String}) {
                                    newSelectedFriendLocationList.append(selectedFriendLocation)
                                } else {
                                    newSelectedFriendLocationList.append(SelectedFriendLocation(friendID: friendId as! String, willDisplay: true))
                                }
                                
                                for document in querySnapshot!.documents{
                                    let user = User()
                                  
                                    user.uid = document.data()["uid"] as? String
                                    user.name = document.data()["name"] as? String
                                    user.profileImageUrl = document.data()["profileImageUrl"] as? String
                                      print("lol",user.name as Any)
                                    
                                    if user.name != nil && user.uid != nil && user.profileImageUrl != nil{
                                        DispatchQueue.main.async {
                                            self.friendLocationListArray.append(FriendRouteLocationList(name: user.name!, image: user.profileImageUrl!, isSelected: true, uid: user.uid!))
//                                            self.friendTableView.reloadData()
                                            self.friendLocationTableView.reloadData()
                                            self.preSelectFriendLocation()
                                        }
                                    }
                                    
                                }
                                selectedFriendLocationList = newSelectedFriendLocationList
                        }
                    }
                }
            }
        }
//        selectedFriendLocationList = newSelectedFriendLocationList
    }

    func fetchShareRouteUser() {
        let currentUserId = Auth.auth().currentUser?.uid
        Firestore.firestore().collection("shareroute").whereField("sharedUserId", isEqualTo:  currentUserId as Any).whereField("status", isEqualTo: true).getDocuments(){
            (querySnapshot,err) in if (err != nil){
                print("fail to load ",err as Any)
            }else{
                var newSelectedFriendRouteList: [SelectedFriendRoute] = []
                for document in querySnapshot!.documents{
                    let friendId  = document.data()["userId"]
                    //                    let status = document.data()["status"] as! Bool
                    print("friendId:", friendId as Any)
                    Firestore.firestore().collection("users").whereField("uid", isEqualTo: friendId as Any).getDocuments(){
                        (querySnapshot,err) in if (err != nil){
                            print("faild to load ",err as Any)
                        }else{
                            
                            if let selectedFriendRoute = selectedFriendRouteList.first(where: {$0.friendID == friendId as! String}) {
                                newSelectedFriendRouteList.append(selectedFriendRoute)
                                
                            } else {
                                newSelectedFriendRouteList.append(SelectedFriendRoute(friendID: friendId as! String, willDisplay: true))
                            }
                            
                            for document in querySnapshot!.documents{
                                let user = User()
                                
                                user.uid = document.data()["uid"] as? String
                                user.name = document.data()["name"] as? String
                                user.profileImageUrl = document.data()["profileImageUrl"] as? String
                                print("lol",user.name as Any)
                                
                                if user.name != nil && user.uid != nil && user.profileImageUrl != nil{
                                    DispatchQueue.main.async {
                                        self.friendRouteLocationListArray.append(FriendRouteLocationList(name: user.name!, image: user.profileImageUrl!, isSelected: true, uid: user.uid!))
                                        //                                            self.friendTableView.reloadData()
                                        self.friendTableView.reloadData()
                                        self.preSelectFriendRoute()
                                    }
                                }
                                
                            }
                            selectedFriendRouteList = newSelectedFriendRouteList
                        }
                    }
                }
            }
        }
    }
    
    func preSelectFriendLocation() {
        // Pre-select
        
        print("Print selected list")
        print(selectedFriendLocationList)
        
        for (i, selectedFriendLocation) in selectedFriendLocationList.enumerated() {
            print("preselected")
            if (selectedFriendLocation.willDisplay) {
                self.friendLocationTableView.selectRow(at: IndexPath.init(row: i, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.middle)
            }
        }
    }
    
    func preSelectFriendRoute() {
        // Pre-select
        
        print("Print selected list")
        print(selectedFriendRouteList)
        
        for (i, selectedFriendRoute) in selectedFriendRouteList.enumerated() {
            print("preselected")
            if (selectedFriendRoute.willDisplay) {
                self.friendTableView.selectRow(at: IndexPath.init(row: i, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.middle)
            }
        }
    }
    
    private func setUpFriendList() {
//        friendRouteLocationListArray.append(FriendRouteLocationList(name: "Bella Nguyen", image: "GPS_Button", isSelected: true))
//        friendRouteLocationListArray.append(FriendRouteLocationList(name: "Thao Nguyen", image: "ThaoImage", isSelected: false))
//        friendRouteLocationListArray.append(FriendRouteLocationList(name: "Vladimir", image: "GPS_Button", isSelected: false))
    }
    
//    private func setUpFriendLocationList() {
//        friendRouteLocationListArray.append(FriendRouteLocationList(name: "Bella Nguyen", image: "BellaImage"))
//        friendRouteLocationListArray.append(FriendRouteLocationList(name: "Thao Nguyen", image: "ThaoImage"))
//        friendRouteLocationListArray.append(FriendRouteLocationList(name: "Vladimir", image: "VladimirImage"))
//        friendRouteLocationListArray.append(FriendRouteLocationList(name: "Bear", image: "BearImage"))
//        friendRouteLocationListArray.append(FriendRouteLocationList(name: "Bella Tran", image: "BellaTranImage"))
//    }
    
    private func setUpFriendLocationList() {
//        friendLocationListArray.append(FriendRouteLocationList(name: "Bella Nguyen", image: "GPS_Button", isSelected: false))
//        friendLocationListArray.append(FriendRouteLocationList(name: "Thao Nguyen", image: "GPS_Button", isSelected: true))
//        friendLocationListArray.append(FriendRouteLocationList(name: "Vladimir", image: "GPS_Button", isSelected: false))
//        friendLocationListArray.append(FriendRouteLocationList(name: "Bear", image: "GPS_Button", isSelected: true))
//        friendLocationListArray.append(FriendRouteLocationList(name: "Bella Tran", image: "GPS_Button", isSelected: true))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == friendTableView {
            return friendRouteLocationListArray.count
        } else {
            return friendLocationListArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == friendTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendRouteLocationCell", for: indexPath) as! FriendRouteLocationCell
            cell.imageProfile.loadImageUsingCacheWithUrlString(friendRouteLocationListArray[indexPath.row].image)
            cell.label.text = friendRouteLocationListArray[indexPath.row].name
            
//            cell.checkBox.addTarget(self, action: #selector(checkBoxButtonClicked(sender:)), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendLocationCell", for: indexPath) as! FriendLocationCell
 cell.imageProfile.loadImageUsingCacheWithUrlString(friendLocationListArray[indexPath.row].image)
            cell.label.text = friendLocationListArray[indexPath.row].name
//            cell.checkBox.addTarget(self, action: #selector(checkBoxLocationButtonClicked(sender:)), for: .touchUpInside)
            return cell

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == friendTableView {
            (selectedFriendRouteList.first(where: {$0.friendID == friendRouteLocationListArray[indexPath.row].uid}))!.willDisplay = true
            
            if (!(selectedFriendLocationList.first(where: {$0.friendID == friendRouteLocationListArray[indexPath.row].uid})!.willDisplay)) {
                (selectedFriendLocationList.first(where: {$0.friendID == friendRouteLocationListArray[indexPath.row].uid}))!.willDisplay = true
                self.friendLocationTableView.selectRow(at: IndexPath(row: selectedFriendLocationList.firstIndex(where: {$0.friendID == friendRouteLocationListArray[indexPath.row].uid})!, section: 0), animated: true, scrollPosition: .middle)
            }
        } else {
            (selectedFriendLocationList.first(where: {$0.friendID == friendLocationListArray[indexPath.row].uid}))!.willDisplay = true
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView == friendTableView {
            (selectedFriendRouteList.first(where: {$0.friendID == friendRouteLocationListArray[indexPath.row].uid}))!.willDisplay = false
        } else {
            print("Did Change logic")
            (selectedFriendLocationList.first(where: {$0.friendID == friendLocationListArray[indexPath.row].uid}))!.willDisplay = false
    
            if let selectedFriend = (selectedFriendRouteList.first(where: {$0.friendID == friendLocationListArray[indexPath.row].uid})) {
                
                if (selectedFriend.willDisplay){
                    print("Did Auto deselect.............")
                    (selectedFriendRouteList.first(where: {$0.friendID == friendLocationListArray[indexPath.row].uid}))!.willDisplay = false
                    self.friendTableView.deselectRow(at: IndexPath(row: selectedFriendRouteList.firstIndex(where: {$0.friendID == friendLocationListArray[indexPath.row].uid})!, section: 0), animated: true)
                }
                
//                print("Did Auto deselect.............")
//                (selectedFriendRouteList.first(where: {$0.friendID == friendLocationListArray[indexPath.row].uid}))!.willDisplay = false
//                self.friendTableView.deselectRow(at: IndexPath(row: selectedFriendRouteList.firstIndex(where: {$0.friendID == friendLocationListArray[indexPath.row].uid})!, section: 0), animated: true)
            }
        }
    }
    
//    @objc func checkBoxButtonClicked( sender: UIButton) {
//        if sender.isSelected {
//            sender.isSelected = false
//        } else {
//            sender.isSelected = true
//        }
//        friendTableView.reloadData()
//    }
//
//    @objc func checkBoxLocationButtonClicked( sender: UIButton) {
//        if sender.isSelected {
//            sender.isSelected = false
//        } else {
//            sender.isSelected = true
//        }
//        friendTableView.reloadData()
//    }
    
    
    @IBAction func onClickSegments(_ sender: UISegmentedControl) {
//        if segmentsView.selectedSegmentIndex == 0 {
//            friendRouteLocationListArray = []
//            setUpFriendList()
//            friendTableView.reloadData()
//        } else {
//            friendRouteLocationListArray = []
//            setUpFriendLocationList()
//            friendTableView.reloadData()
//        }
        if segmentsView.selectedSegmentIndex == 0 {
            friendTableView.isHidden = false
            friendLocationTableView.isHidden = true
        } else {
            friendTableView.isHidden = true
            friendLocationTableView.isHidden = false
        }
    }
    
    @IBAction func hideTabBar(_ sender: UIButton) {
        
        if let selectedFriendLocationRows = friendLocationTableView.indexPathsForSelectedRows {
            // 1
            delegate?.didSelectFriendsRouteLocation()
        }
        removeAnimate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.view.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.7)
        showAnimate()
        
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(translationX: 0.5, y: 0.5)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 1.0) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(translationX: 1.0, y: 1.0)
        }
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 1.0, animations: {
            self.view.transform = CGAffineTransform(translationX: 0.5, y: 0.5)
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
