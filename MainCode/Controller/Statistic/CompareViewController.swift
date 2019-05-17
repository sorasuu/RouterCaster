//
//  CompareViewController.swift
//  MainCode
//
//  Created by Apple on 5/10/19.
//  Copyright © 2019 Kien. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import JGProgressHUD
import SwiftyJSON
import FirebaseStorage
import Dwifft

class CompareViewController: UIViewController {
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    @IBOutlet weak var friendProfile: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    var friendlist: FriendList?
    var user: FriendList?
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrentUser()
        self.view.frame.origin.x += self.view.frame.size.width
        
        let uid = friendlist?.uid
        Firestore.firestore().collection("users").whereField("uid", isEqualTo: uid!).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                DispatchQueue.main.async {
                    for document in querySnapshot!.documents {
                        let user = User()
                        self.users.append(user)
                        //                    print("\(document.documentID) => \(document.data())")
                        let userdata = document.data()
                        user.email = userdata["email"] as? String
                        user.name = userdata["name"] as? String
                        user.uid = userdata["uid"] as? String
                        user.profileImageUrl = userdata["profileImageUrl"] as? String
                        print(user.profileImageUrl as Any)
                        print(user.name as Any)
                        
                        if self.friendlist!.uid == user.uid! {
                            self.friendName.text = user.name
                            let profileUrl = user.profileImageUrl!
                            self.friendProfile.loadImageUsingCacheWithUrlString(profileUrl)
                        }
                        
                    }
                    
                }
                
            }
        }
        
        
        // Do any additional setup after loading the view.
        showCompareView()
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
                self.userProfile.loadImageUsingCacheWithUrlString(sparkUser.profileImageUrl)
                
                self.userName.text = sparkUser.name
                
                
            }
            
            SparkService.dismissHud(self.hud, text: "Success", detailText: "Successfully fetched user", delay: 0)
            
        }
    }
    
    func showCompareView() {
        UIView.animate(withDuration: 0.5) {
            self.view.frame.origin.x -= self.view.frame.size.width
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        
        let comparelistVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbCompareListID") as! CompareListViewController
        comparelistVC.backInfoComparelist = "back"
        
        self.present(comparelistVC, animated: false, completion: {
            self.presentingViewController?.dismiss(animated: false, completion: {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window!.rootViewController!.present(comparelistVC, animated: false, completion: nil)
            })
        })
    }
    
}
