//
//  ViewController.swift
//  MainCode
//
//  Created by Apple on 4/22/19.
//  Copyright © 2019 Kien. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import JGProgressHUD
import SwiftyJSON
import FirebaseStorage
import Dwifft
//class Person {
//    var name: String = ""
//    var image: UIImage
//
//    init(name: String, image: UIImage) {
//
//    }
//}

@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
}

class FriendList {
    var name: String
    var image: String
    var uid: String
    init(name: String, image: String, uid : String) {
        self.uid = uid
        self.name = name
        self.image = image
    }
}



class FriendlistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var mainViewSideBar: UIView!
    @IBOutlet weak var testSideBar: UIView!
    @IBOutlet weak var moveViewMagic: UIView!
    @IBOutlet weak var navigationIcon: UIImageView!
    @IBOutlet weak var navigationText: UILabel!
    @IBOutlet weak var messengerIcon: UIImageView!
    @IBOutlet weak var chatsText: UILabel!
    @IBOutlet weak var peopleIcon: UIImageView!
    @IBOutlet weak var friendlistText: UILabel!
    @IBOutlet weak var statisticsIcon: UIImageView!
    @IBOutlet weak var statisticsText: UILabel!
    @IBOutlet weak var settingsIcon: UIImageView!
    @IBOutlet weak var settingsText: UILabel!
    

    @IBOutlet weak var defaultProfile: UIImageView!
    @IBOutlet weak var profilebarname: UILabel!
    
    
    
    var friendListArray = [FriendList]()
    var searchString: [FriendList] = []
    var deleteSearchString: [FriendList] = []
    var addFriendListArray: [FriendList] = []
    var searchAddFriendString: [FriendList] = []
    var users = [User]()
    var friends = [User]()
    var strangers = [User]()
    var searching = false
    var deleteSearching = false
    
    func combineTwoArray(indexPathRow: Int) {
        
        friendListArray = friendListArray.filter({ friendList -> Bool in
            !friendList.uid.contains("\(searchString[indexPathRow].uid)")
        })
        
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
                                    friend.name = document.data()["name"] as? String
                                    friend.profileImageUrl = document.data()["profileImageUrl"] as? String
                                    friend.uid = document["uid"] as? String
                                    self.friendListArray.append(FriendList(name: friend.name! , image: friend.profileImageUrl!,uid: friend.uid!))
                                    self.whoAreStranger(friend: friend)
                                    DispatchQueue.main.async(execute: {
                                        self.listTableView.reloadData()
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
                                    friend.name = document.data()["name"] as? String
                                    friend.profileImageUrl = document.data()["profileImageUrl"] as? String
                                    friend.uid = document["uid"] as? String
                                    self.friendListArray.append(FriendList(name: friend.name! , image: friend.profileImageUrl!,uid: friend.uid!))
                                    self.whoAreStranger( friend: friend)
                                    DispatchQueue.main.async(execute: {
                                        self.listTableView.reloadData()
                                    })
                                }}}
                    }
                }
                
            }
            
            

        }
    }
    private func fetchAllUsers() {
        
        Firestore.firestore().collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let user = User()
                    
                    //                    print("\(document.documentID) => \(document.data())")
                    let userdata = document.data()
                    user.email = userdata["email"] as? String
                    user.name = userdata["name"] as? String
                    user.uid = userdata["uid"] as? String
                    user.profileImageUrl = userdata["profileImageUrl"] as? String
                    print(user.profileImageUrl as Any)
                    print(user.name as Any)
                    
                    self.users.append(user)
                    self.addFriendListArray.append(FriendList(name: user.name!, image: user.profileImageUrl!, uid: user.uid!))
                    
                    //                    self.addFriendListArray.append(FriendList(name: user.name!, image: user.profileImageUrl!, uid: user.uid!))
                    //this will crash because of background thread, so lets use dispatch_async to fix
                    DispatchQueue.main.async(execute: {
                        self.listTableView.reloadData()
                    })
                    
                    
                }
                
                
                var indexPathsToReload = [IndexPath]()
                for index in self.friendListArray.indices {
                    let indexPath = IndexPath(row: index, section: 0)
                    indexPathsToReload.append(indexPath)
                }
                
                self.listTableView.reloadData()
                //                 DispatchQueue.main.async {
                //                    self.listTableView.reloadRows(at: indexPathsToReload, with: .fade)}
            }
            self.strangers = self.users
        }
        
        fetchAllFriend()

    }
    func whoAreStranger( friend :User ) {
      
        self.addFriendListArray.removeAll()
        var index1 = 0
        var removeindex1 = [Int]()
        
        for user in strangers{
            
            if (user.uid==friend.uid){
                print("remove this index")
                removeindex1.append(index1)
            }
            index1 += 1
        }
        for i in removeindex1{
            self.strangers.remove(at: i)
        }
        for stranger in strangers {
            self.addFriendListArray.append(FriendList(name: stranger.name!, image: stranger.profileImageUrl!, uid: stranger.uid!))
        }
        
        print(strangers.count)
    }
    
    
    func fetchCurrentUser() {
        
        Spark.fetchCurrentSparkUser { (message, err, sparkUser) in
            if let err = err {
                SparkService.dismissHud(self.hud, text: "Error", detailText: "\(message) \(err.localizedDescription)", delay: 0)
                return
            }
            guard let sparkUser = sparkUser else {
                SparkService.dismissHud(self.hud, text: "Error", detailText: "Failed to fetch user", delay: 0 )
                return
            }
            
            DispatchQueue.main.async {
                self.defaultProfile.loadImageUsingCacheWithUrlString(sparkUser.profileImageUrl)
                
                self.profilebarname.text = sparkUser.name
                
                
            }
            
            SparkService.dismissHud(self.hud, text: "Success", detailText: "Successfully fetched user", delay: 0)
            
        }
    }
    // Mark: -
    // Mark: Fetch users profile img
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if searching == true {
                return searchString.count
            }
            else if searching == false && deleteSearching == true {
                return friendListArray.count
            }
            else {
                return friendListArray.count
            }
        } else {
            if searching == true {
                return searchAddFriendString.count
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FriendListCell
            
            if searching == true {
                DispatchQueue.main.async(execute: {
                    print("search user",self.searchString[indexPath.row].name)
                    cell.uid = self.searchString[indexPath.row].uid
                    cell.label.text = self.searchString[indexPath.row].name
                    let profileUrl = self.searchString[indexPath.row].image
                    cell.imageProfile.loadImageUsingCacheWithUrlString(profileUrl)})
                print("reload1")
            }
            else if searching == false && deleteSearching == true {
                
                DispatchQueue.main.async(execute: {
                    cell.uid = self.friendListArray[indexPath.row].uid
                    cell.label.text = self.friendListArray[indexPath.row].name
                    let profileUrl = self.friendListArray[indexPath.row].image
                    cell.imageProfile.loadImageUsingCacheWithUrlString(profileUrl)})
            }
            else {
                DispatchQueue.main.async(execute: {
                    cell.uid = self.friendListArray[indexPath.row].uid
                    cell.label.text = self.friendListArray[indexPath.row].name
                    let profileUrl = self.friendListArray[indexPath.row].image
                    print("profileurl is: ", profileUrl)
                    cell.imageProfile.loadImageUsingCacheWithUrlString(profileUrl)}
                )
                
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addFriendCell", for: indexPath) as! AddFriendCell
            if searching == true {
                print("num users that we are searching ",searchString.count)
                print("number of stranger", addFriendListArray.count)
                cell.uid = self.searchAddFriendString[indexPath.row].uid
                print("search add friend list", searchAddFriendString.count)
                cell.label.text = self.searchAddFriendString[indexPath.row].name
                let profileUrl = self.searchAddFriendString[indexPath.row].image
                cell.imageProfile.loadImageUsingCacheWithUrlString(profileUrl)
                
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //        deleteSearching = true
        
        let unfriend = UIContextualAction(style: .destructive, title: "Unfriend") { (action, view, completionHandler) in
            //            self.friendListArray.remove(at: indexPath.row)
            //            tableView.deleteRows(at: [indexPath], with: .fade)
            //            completionHandler(true)
            if self.searching == true {
                print("\(indexPath.row)")
                let uid = self.searchString[indexPath.row].uid
                self.friendListArray.remove(at: indexPath.row)
                                tableView.deleteRows(at: [indexPath], with: .fade)
                                completionHandler(true)
                                self.searchBar.text = ""
                                self.searching = false
                                self.deleteSearching = true
                                self.listTableView.reloadData()
                self.destroyFrienShip(friendId: uid)
                
                
            } else {
                let uid = self.friendListArray[indexPath.row].uid
                self.friendListArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                completionHandler(true)
                self.destroyFrienShip(friendId: uid)
               
            }
        }
        return UISwipeActionsConfiguration(actions: [unfriend])
    }
    func destroyFrienShip(friendId:String ){
        let currentUserId = Auth.auth().currentUser?.uid
        Firestore.firestore().collection("friendship").whereField("user1_Id", isEqualTo: friendId).whereField("user2_Id", isEqualTo: currentUserId as Any).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                DispatchQueue.main.async {
                    for document in querySnapshot!.documents {
                        document.reference.delete()
                    }
                    
                }}
        }
        Firestore.firestore().collection("friendship").whereField("user1_Id", isEqualTo: currentUserId as Any).whereField("user2_Id", isEqualTo: friendId).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                DispatchQueue.main.async {
                    for document in querySnapshot!.documents {
                        document.reference.delete()
                    }
                    
                }}
        }
        Firestore.firestore().collection("sharelocation").whereField("sharedUserId", isEqualTo: currentUserId as Any).whereField("userId", isEqualTo: friendId).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                DispatchQueue.main.async {
                    for document in querySnapshot!.documents {
                        document.reference.delete()
                    }
                    
                }
            }}
        Firestore.firestore().collection("sharelocation").whereField("sharedUserId", isEqualTo: friendId as Any).whereField("userId", isEqualTo: currentUserId as Any).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                DispatchQueue.main.async {
                    for document in querySnapshot!.documents {
                        document.reference.delete()
                    }
                    
                }
            }}
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAllUsers()
        fetchCurrentUser()
        showFriendlistView()
        
        //        setUpFriendList()
        //        setUpAddFriendList()
        // Do any additional setup after loading the view.
        
        
        self.statisticsIcon.tintColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
        self.view.frame.origin.x += self.view.frame.size.width
        
        
        
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        testSideBar.frame.origin.x -= testSideBar.frame.size.width
  
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        testSideBar.frame.origin.x -= testSideBar.frame.size.width
    }
    //    private func setUpFriendList() {
    //        friendListArray.append(FriendList(name: "Thao Nguyen", image: "ThaoImage"))
    //        friendListArray.append(FriendList(name: "Linh Nguyen", image: "LinhImage"))
    //        friendListArray.append(FriendList(name: "Bella Nguyen", image: "BellaImage"))
    //        friendListArray.append(FriendList(name: "Vladimir", image: "VladimirImage"))
    //        friendListArray.append(FriendList(name: "Bear", image: "BearImage"))
    //        friendListArray.append(FriendList(name: "Bella Tran", image: "BellaTranImage"))
    //    }
    //
    //    private func setUpAddFriendList() {
    //        addFriendListArray.append(FriendList(name: "Thao Le", image: "ThaoLeImage"))
    //        addFriendListArray.append(FriendList(name: "Nguyen Lam Thao", image: "NguyenLamThaoImage"))
    //        addFriendListArray.append(FriendList(name: "Le Thao", image: "LeThaoImage"))
    //        addFriendListArray.append(FriendList(name: "Tran Le Thao", image: "TranLeThaoImage"))
    //        addFriendListArray.append(FriendList(name: "Nguyen Le Thao", image: "NguyenLeThaoImage"))
    //    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            
            let orient = UIApplication.shared.statusBarOrientation
            
            switch orient {
                
            case .portrait:
                if self.testSideBar.isHidden == true {
                    self.testSideBar.frame.origin.x = self.view.frame.origin.x
                    self.testSideBar.frame.origin.x -= self.testSideBar.frame.size.width
                } else {
                    self.testSideBar.frame.origin.x = self.view.frame.origin.x
                    //                    self.testSideBar.frame.origin.x += self.testSideBar.frame.size.width
                }
                //                self.testSideBar.frame.origin.x -= self.testSideBar.frame.size.width
                print(self.testSideBar.frame.origin.x)
                print("Portrait")
                
            case .landscapeLeft,.landscapeRight :
                if self.testSideBar.isHidden == true {
                    self.testSideBar.frame.origin.x = self.view.frame.origin.x
                    self.testSideBar.frame.origin.x -= self.testSideBar.frame.size.width
                } else {
                    self.testSideBar.frame.origin.x = self.view.frame.origin.x
                    //                    self.testSideBar.frame.origin.x += self.testSideBar.frame.size.width
                }
                print(self.testSideBar.frame.origin.x)
                print("Landscape")
                
            default:
                self.testSideBar.frame.origin.x -= self.testSideBar.frame.size.width
                print("Anything But Portrait")
            }
            
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            //refresh view once rotation is completed not in will transition as it returns incorrect frame size.Refresh here
            
        })
        super.viewWillTransition(to: size, with: coordinator)
        
    }
    
    
    @IBAction func requestPopup(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    //logout
    @IBAction func logOutButton(_ sender: UIButton) {
        handleSignOutButtonTapped()
    }
    
    
    @objc func handleSignOutButtonTapped() {
        Spark.logout { (result, err) in
            if let err = err {
                SparkService.showAlert(style: .alert, title: "Sign Out Error", message: "Failed to sign out with error: \(err.localizedDescription)")
                return
            }
            
            if result {
                let loginVC = UIStoryboard(name: "SignInSignUp", bundle: nil).instantiateViewController(withIdentifier: "sbLoginID") as! LoginViewController
                
                self.present(loginVC, animated: false, completion: {
                    self.presentingViewController?.dismiss(animated: false, completion: {
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window!.rootViewController!.present(loginVC, animated: false, completion: nil)
                    })
                })
            } else {
                SparkService.showAlert(style: .alert, title: "Sign Out Error", message: "Failed to sign out")
            }
        }
    }
    
    //Navigation
    @IBAction func menuSideBar(_ sender: UIButton) {
        
        showTestSideBar()
    }
    
    @IBAction func onClickMoveToNavigation(_ sender: UIButton) {
        closeSideBarToMoveToNavigation()
    }
    
    @IBAction func onClickMoveToChats(_ sender: UIButton) {
        closeSideBarToMoveToChats()
    }
    
    @IBAction func onClickMoveToFriendlist(_ sender: UIButton) {
        closeTestSideBar()
    }
    
    @IBAction func onClickMoveToStatistic(_ sender: UIButton) {
        closeSideBarToMoveToStatistic()
    }
    
    @IBAction func onClickMoveToSettings(_ sender: UIButton) {
        closeSideBarToMoveToSettings()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        closeTestSideBar()
    }
    
    func showTestSideBar() {
        mainViewSideBar.isHidden = false
        testSideBar.isHidden = false
        
        UIView.animate(withDuration: 0.5) {
            self.testSideBar.frame.origin.x += self.testSideBar.frame.size.width
        }
    }
    
    func closeTestSideBar() {
        //testSideBar.frame.origin.x = testSideBar.frame.origin.x
        UIView.animate(withDuration: 0.5, animations: {
            self.testSideBar.frame.origin.x -= self.testSideBar.frame.size.width
        }) { completed in
            self.testSideBar.isHidden = true
            self.mainViewSideBar.isHidden = true
        }
    }
    
    func closeSideBarToMoveToStatistic() {
        UIView.animate(withDuration: 0.2, animations: {
            self.moveViewMagic.frame.origin.y = self.statisticsIcon.frame.origin.y - 13
            self.peopleIcon.tintColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
            self.friendlistText.textColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
            self.statisticsIcon.tintColor = UIColor(red: CGFloat(255)/255.0, green: CGFloat(255)/255.0, blue: CGFloat(255)/255.0, alpha: 1)
            self.statisticsText.textColor = UIColor(red: CGFloat(255)/255.0, green: CGFloat(255)/255.0, blue: CGFloat(255)/255.0, alpha: 1)
        }) { completed in
            UIView.animate(withDuration: 0.2, animations: {
                self.testSideBar.frame.origin.x -= self.testSideBar.frame.size.width
            }) { completed in
                UIView.animate(withDuration: 0.2, animations: {
                    self.testSideBar.isHidden = true
                    self.mainViewSideBar.isHidden = true
                }, completion: { completed in
                    
                    
                    let statisticVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbStatisticsID") as! StatisticsViewController
                    statisticVC.backInfo = ""
                    
                    self.present(statisticVC, animated: false, completion: {
                        self.presentingViewController?.dismiss(animated: false, completion: {
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window!.rootViewController!.present(statisticVC, animated: false, completion: nil)
                        })
                    })
                })
            }
        }
        
    }
    
    func closeSideBarToMoveToNavigation() {
        UIView.animate(withDuration: 0.2, animations: {
            self.moveViewMagic.frame.origin.y = self.navigationIcon.frame.origin.y - 10
            self.peopleIcon.tintColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
            self.friendlistText.textColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
            self.navigationIcon.tintColor = UIColor(red: CGFloat(255)/255.0, green: CGFloat(255)/255.0, blue: CGFloat(255)/255.0, alpha: 1)
            self.navigationText.textColor = UIColor(red: CGFloat(255)/255.0, green: CGFloat(255)/255.0, blue: CGFloat(255)/255.0, alpha: 1)
        }) { completed in
            UIView.animate(withDuration: 0.2, animations: {
                self.testSideBar.frame.origin.x -= self.testSideBar.frame.size.width
            }) { completed in
                UIView.animate(withDuration: 0.2, animations: {
                    self.testSideBar.isHidden = true
                    self.mainViewSideBar.isHidden = true
                }, completion: { completed in
                    
                    let mapVC = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "mapVC") as! MapViewController
                    
                    self.present(mapVC, animated: false, completion: {
                        self.presentingViewController?.dismiss(animated: false, completion: {
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window!.rootViewController!.present(mapVC, animated: false, completion: nil)
                        })
                    })
                })
            }
        }
        
    }
    
    func closeSideBarToMoveToChats() {
        UIView.animate(withDuration: 0.2, animations: {
            self.moveViewMagic.frame.origin.y = self.messengerIcon.frame.origin.y - 10
            self.peopleIcon.tintColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
            self.friendlistText.textColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
            self.messengerIcon.tintColor = UIColor(red: CGFloat(255)/255.0, green: CGFloat(255)/255.0, blue: CGFloat(255)/255.0, alpha: 1)
            self.chatsText.textColor = UIColor(red: CGFloat(255)/255.0, green: CGFloat(255)/255.0, blue: CGFloat(255)/255.0, alpha: 1)
        }) { completed in
            UIView.animate(withDuration: 0.2, animations: {
                self.testSideBar.frame.origin.x -= self.testSideBar.frame.size.width
            }) { completed in
                UIView.animate(withDuration: 0.2, animations: {
                    self.testSideBar.isHidden = true
                    self.mainViewSideBar.isHidden = true
                }, completion: { completed in
                    
                    let chatVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbMessageID") as! MessagesController
                    
                    self.present(chatVC, animated: false, completion: {
                        self.presentingViewController?.dismiss(animated: false, completion: {
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window!.rootViewController!.present(chatVC, animated: false, completion: nil)
                        })
                    })
                })
            }
        }
        
    }
    
    func closeSideBarToMoveToSettings() {
        UIView.animate(withDuration: 0.2, animations: {
            self.moveViewMagic.frame.origin.y = self.settingsIcon.frame.origin.y - 10
            self.peopleIcon.tintColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
            self.friendlistText.textColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
            self.settingsIcon.tintColor = UIColor(red: CGFloat(255)/255.0, green: CGFloat(255)/255.0, blue: CGFloat(255)/255.0, alpha: 1)
            self.settingsText.textColor = UIColor(red: CGFloat(255)/255.0, green: CGFloat(255)/255.0, blue: CGFloat(255)/255.0, alpha: 1)
        }) { completed in
            UIView.animate(withDuration: 0.2, animations: {
                self.testSideBar.frame.origin.x -= self.testSideBar.frame.size.width
            }) { completed in
                UIView.animate(withDuration: 0.2, animations: {
                    self.testSideBar.isHidden = true
                    self.mainViewSideBar.isHidden = true
                }, completion: { completed in
                    
                    let settingVC = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "settingVC") as! SettingViewController
                    
                    self.present(settingVC, animated: false, completion: {
                        self.presentingViewController?.dismiss(animated: false, completion: {
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window!.rootViewController!.present(settingVC, animated: false, completion: nil)
                        })
                    })
                })
            }
        }
        
    }

    
    
    
    func showFriendlistView() {
        UIView.animate(withDuration: 0.5) {
            //            self.view.alpha = 1
            //            self.mainScrollView.frame.origin.x -= self.mainScrollView.frame.size.width
            self.view.frame.origin.x -= self.view.frame.size.width
        }
    }
    
//    func showMainMenu() {
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
//            self.mainView.frame.origin.x += self.mainView.frame.origin.x
//        }, completion: nil)
//    }
    
}

extension FriendlistViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            searching = false
            view.endEditing(true)
            listTableView.reloadData()
        } else {
            searching = true
            searchString = friendListArray.filter({$0.name.lowercased().prefix(searchText.count) == searchText.lowercased()})
            searchAddFriendString = addFriendListArray.filter({$0.name.lowercased().prefix(searchText.count) == searchText.lowercased()})
            listTableView.reloadData()
        }
    }
}
extension Array where Element: Equatable {
    mutating func removeDuplicates() {
        var result = [Element]()
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        self = result
    }
}

