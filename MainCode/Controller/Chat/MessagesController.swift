//
//  ViewController.swift
//
//
//  Created by Rmit on 4/24/19.
//  Copyright © 2019 SoraSuu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import JGProgressHUD
import SwiftyJSON
import FirebaseStorage
import Dwifft

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class MessagesController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    

    let cellId = "cellId"
    @IBOutlet weak var tableView: UITableView!
    
    //Navigation
    @IBOutlet weak var mainViewSideBar: UIView!
    @IBOutlet weak var testSideBar: UIView!
    @IBOutlet weak var moveMagicView: UIView!
    @IBOutlet weak var navigationIcon: UIImageView!
    @IBOutlet weak var navigationText: UILabel!
    @IBOutlet weak var messengerIcon: UIImageView!
    @IBOutlet weak var chatsText: UILabel!
    @IBOutlet weak var peopleIcon: UIImageView!
    @IBOutlet weak var friendlistText: UILabel!
    @IBOutlet weak var statisticIcon: UIImageView!
    @IBOutlet weak var statisticsText: UILabel!
    @IBOutlet weak var settingsIcon: UIImageView!
    @IBOutlet weak var settingsText: UILabel!
    
    @IBOutlet weak var profilebarname: UILabel!
    @IBOutlet weak var defaultProfile: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrentUser()
        
        
        testSideBar.frame.origin.x -= testSideBar.frame.size.width
        
        //Navigation Configuration
        self.messengerIcon.tintColor = .white
        self.peopleIcon.tintColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
        self.statisticIcon.tintColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
        
        
//        let image = UIImage(named: "new_message_icon")
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
        checkIfUserIsLoggedIn()
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
//        observeMessages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        DispatchQueue.global(qos: .background).async {
//            DispatchQueue.main.async {
//                self.view.frame.origin.x += self.view.frame.size.width
//                self.showMessagesView()
//            }
//        }
//        DispatchQueue.main.async {
//            self.view.frame.origin.x += self.view.frame.size.width
//            self.showMessagesView()
//        }
        self.view.frame.origin.x += self.view.frame.size.width
        self.showMessagesView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        testSideBar.frame.origin.x -= testSideBar.frame.size.width
    }
    
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
    
    
    //fetch current user
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
    @IBAction func onClickMenuSideBar(_ sender: UIButton) {
        showTestSideBar()
    }
    
    
    @IBAction func onClickToCloseSideBar(_ sender: UIButton) {
        closeTestSideBar()
    }
    
    
    @IBAction func onClickMovetoNavigation(_ sender: UIButton) {
        closeSideBarToMoveToNavigation()
    }
    
    @IBAction func onClickMoveToChats(_ sender: UIButton) {
        closeTestSideBar()
    }
    
    @IBAction func onClickMoveToFriendlist(_ sender: UIButton) {
        closeSideBarToMoveToFriendlist()
    }
    
    @IBAction func onClickMoveToStatistics(_ sender: UIButton) {
        closeSideBarToMoveToStatistic()
    }
    
    @IBAction func onClickMoveToSettings(_ sender: UIButton) {
        closeSideBarToMoveToSettings()
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
            self.moveMagicView.frame.origin.y = self.statisticIcon.frame.origin.y - 13
            self.messengerIcon.tintColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
            self.chatsText.textColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
            self.statisticIcon.tintColor = UIColor(red: CGFloat(255)/255.0, green: CGFloat(255)/255.0, blue: CGFloat(255)/255.0, alpha: 1)
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
            self.moveMagicView.frame.origin.y = self.navigationIcon.frame.origin.y - 10
            self.messengerIcon.tintColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
            self.chatsText.textColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
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
                    
//                    DispatchQueue.main.async {
//                        self.present(mapVC, animated: false, completion: {
//                            self.presentingViewController?.dismiss(animated: false, completion: {
//                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                                appDelegate.window!.rootViewController!.present(mapVC, animated: false, completion: nil)
//                            })
//                        })
//                    }
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
//                        self.present(mapVC, animated: false, completion: {
//                            self.presentingViewController?.dismiss(animated: false, completion: {
//                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                                appDelegate.window!.rootViewController!.present(mapVC, animated: false, completion: nil)
//                            })
//                        })
//                    })
//                    DispatchQueue.global(qos: .background).async {
//                        DispatchQueue.main.async {
//                            self.present(mapVC, animated: false, completion: {
//                                self.presentingViewController?.dismiss(animated: false, completion: {
//                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                                    appDelegate.window!.rootViewController!.present(mapVC, animated: false, completion: nil)
//                                })
//                            })
//                        }
//                    }
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
    
    func closeSideBarToMoveToFriendlist() {
        UIView.animate(withDuration: 0.2, animations: {
            self.moveMagicView.frame.origin.y = self.peopleIcon.frame.origin.y - 10
            self.messengerIcon.tintColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
            self.chatsText.textColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
            self.peopleIcon.tintColor = UIColor(red: CGFloat(255)/255.0, green: CGFloat(255)/255.0, blue: CGFloat(255)/255.0, alpha: 1)
            self.friendlistText.textColor = UIColor(red: CGFloat(255)/255.0, green: CGFloat(255)/255.0, blue: CGFloat(255)/255.0, alpha: 1)
        }) { completed in
            UIView.animate(withDuration: 0.2, animations: {
                self.testSideBar.frame.origin.x -= self.testSideBar.frame.size.width
            }) { completed in
                UIView.animate(withDuration: 0.2, animations: {
                    self.testSideBar.isHidden = true
                    self.mainViewSideBar.isHidden = true
                }, completion: { completed in
                    
                    let friendlistVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbFriendlistID") as! FriendlistViewController
                    
                    self.present(friendlistVC, animated: false, completion: {
                        self.presentingViewController?.dismiss(animated: false, completion: {
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window!.rootViewController!.present(friendlistVC, animated: false, completion: nil)
                        })
                    })
                })
            }
        }
        
    }
    
    func closeSideBarToMoveToSettings() {
        UIView.animate(withDuration: 0.2, animations: {
            self.moveMagicView.frame.origin.y = self.settingsIcon.frame.origin.y - 10
            self.messengerIcon.tintColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
            self.chatsText.textColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
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
    
    func showMessagesView() {
        UIView.animate(withDuration: 0.5) {
            //            self.view.alpha = 1
            //            self.mainScrollView.frame.origin.x -= self.mainScrollView.frame.size.width
            self.view.frame.origin.x -= self.view.frame.size.width
        }
    }
    
    
    
    
    @IBAction func didPressCompose(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newMessageController = storyboard.instantiateViewController(withIdentifier: "NewMessageVC") as! NewMessageController
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        
        self.present(newMessageController, animated: false, completion: nil)
    }
    
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Firestore.firestore().collection("user-messages").whereField("uid", isEqualTo: uid).addSnapshotListener{ querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
//            let messages = documents.map { $0["name"]! }
            for info in documents{
                print(info.data())
                print(info.documentID)
            }
        }


            
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in

            let userId = snapshot.key
            Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in

                let messageId = snapshot.key
                self.fetchMessageWithMessageId(messageId)

                }, withCancel: nil)

            }, withCancel: nil)
    }
    
    fileprivate func fetchMessageWithMessageId(_ messageId: String) {
//        Firestore.firestore().collection("messages").whereField("messageId", isEqualTo: messageId).getDocuments(){(querySnapshot,err) in if let err = err {
//            print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    if let dictionary = document.data() as? [String: AnyObject] {
//                        let message = Message(dictionary: dictionary)
//                        if let chatPartnerId = message.chatPartnerId() {
//                        self.messagesDictionary[chatPartnerId] = message}
//                        self.attemptReloadOfTable()
//                }
//                }
//            }
//        }
        
        let messagesReference = Database.database().reference().child("messages").child(messageId)

        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in

            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)

                if let chatPartnerId = message.chatPartnerId() {
                    self.messagesDictionary[chatPartnerId] = message
                }

                self.attemptReloadOfTable()
            }

            }, withCancel: nil)
    }
    
    fileprivate func attemptReloadOfTable() {
        self.timer?.invalidate()
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    var timer: Timer?
    
    @objc func handleReloadTable() {
        self.messages = Array(self.messagesDictionary.values)
        self.messages.sort(by: { (message1, message2) -> Bool in
            
            return message1.timestamp?.int32Value > message2.timestamp?.int32Value
        })
        
        //this will crash because of background thread, so lets call this on dispatch_async main thread
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let message = messages[indexPath.row]
        cell.message = message
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        Firestore.firestore().collection("users").whereField("uid", isEqualTo: chatPartnerId).getDocuments(){(querySnapshot,err )
            in if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    guard let dictionary = document.data() as? [String: AnyObject] else {
                                        return
                                    }
                    let user = User(dictionary: dictionary)
                    user.uid = chatPartnerId
                    self.showChatControllerForUser(user)
                }
            }
        }
//        let ref = Database.database().reference().child("users").child(chatPartnerId)
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            guard let dictionary = snapshot.value as? [String: AnyObject] else {
//                return
//            }
//
//            let user = User(dictionary: dictionary)
//            user.id = chatPartnerId
//            self.showChatControllerForUser(user)
//
//            }, withCancel: nil)
    }
    
//    @objc func handleNewMessage() {
//        let newMessageController = NewMessageController()
//        newMessageController.messagesController = self
//        let navController = UINavigationController(rootViewController: newMessageController)
//        present(navController, animated: true, completion: nil)
//    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
          } else {
            fetchUserAndSetupNavBarTitle()
        }
    }
    
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        Firestore.firestore().collection("users").whereField("uid", isEqualTo: uid).getDocuments(){
            (querySnapshot,err) in  if let err = err {
                print("Error getting documents: \(err)")
            }
            for document in querySnapshot!.documents{
              let dictionary = document.data()
                self.navigationItem.title = dictionary["name"] as? String
                let user = User(dictionary: dictionary)
                    self.setupNavBarWithUser(user)
            }
            
        }
//        
//       child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            if let dictionary = snapshot.value as? [String: AnyObject] {
////                self.navigationItem.title = dictionary["name"] as? String
//                
//                let user = User(dictionary: dictionary)
//                self.setupNavBarWithUser(user)
//            }
//            
//            }, withCancel: nil)
    }
    
    func setupNavBarWithUser(_ user: User) {
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        observeUserMessages()
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
//        titleView.backgroundColor = UIColor.redColor()
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        containerView.addSubview(profileImageView)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        
        containerView.addSubview(nameLabel)
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        //need x,y,width,height anchors
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
        
//        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
    }
    
    func showChatControllerForUser(_ user: User) {
//        let chatLogController = ChatLogController()

        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let chatLogController = storyboard.instantiateViewController(withIdentifier: "ChatLogVC") as! ChatLogController
//            chatLogController.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        chatLogController.user = user
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        
        self.present(chatLogController, animated: true)
    }
}

