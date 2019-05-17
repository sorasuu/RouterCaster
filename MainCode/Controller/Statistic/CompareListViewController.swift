//
//  CompareListViewController.swift
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

class CompareListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    @IBOutlet weak var listTableView: UITableView!
    

    var compareListArray = [FriendList]()
    var searchString: [FriendList] = []
    var users = [User]()
    var searching = false
    
    var backInfoComparelist = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setUpCompareList()
        fetchAllUsers()
        
        if backInfoComparelist == "back" {
            self.view.frame.origin.x -= self.view.frame.size.width
            showCompareListViewFromLeftToRight()
        } else {
            self.view.frame.origin.x += self.view.frame.size.width
            showCompareListView()
        }
        
    }
    
    private func fetchAllUsers() {
        Firestore.firestore().collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
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
                    
                    self.compareListArray.append(FriendList(name: user.name! , image: user.profileImageUrl!, uid: user.uid!))
                    
                    //this will crash because of background thread, so lets use dispatch_async to fix
                    DispatchQueue.main.async(execute: {
                        self.listTableView.reloadData()
                    })
                    
                    
                }
                
                
                var indexPathsToReload = [IndexPath]()
                for index in self.compareListArray.indices {
                    let indexPath = IndexPath(row: index, section: 0)
                    indexPathsToReload.append(indexPath)
                }
                print("bug here")
                for u in self.compareListArray {
                    print("email")
                    print(u.name)
                }
                self.listTableView.reloadData()
                //                 DispatchQueue.main.async {
                //                    self.listTableView.reloadRows(at: indexPathsToReload, with: .fade)}
            }
        }
        
    }
    
    
    
    func showCompareListView() {
        UIView.animate(withDuration: 0.5) {
            self.view.frame.origin.x -= self.view.frame.size.width
        }
    }
    
    func showCompareListViewFromLeftToRight() {
        UIView.animate(withDuration: 0.5) {
            self.view.frame.origin.x += self.view.frame.size.width
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        
        let statisticsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbStatisticsID") as! StatisticsViewController
        statisticsVC.backInfo = "back"
        
        self.present(statisticsVC, animated: false, completion: {
            self.presentingViewController?.dismiss(animated: false, completion: {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window!.rootViewController!.present(statisticsVC, animated: false, completion: nil)
            })
        })
    }
    
    private func setUpCompareList() {
        compareListArray.append(FriendList(name: "Allen Iverson", image: "AllenIverson", uid: ""))
        compareListArray.append(FriendList(name: "Linh Nguyen", image: "LinhImage", uid: ""))
        compareListArray.append(FriendList(name: "Bella Nguyen", image: "BellaImage", uid: ""))
        compareListArray.append(FriendList(name: "Vladimir", image: "VladimirImage", uid: ""))
        compareListArray.append(FriendList(name: "Bear", image: "BearImage", uid: ""))
        compareListArray.append(FriendList(name: "Bella Tran", image: "BellaTranImage", uid: ""))
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching == true {
            return searchString.count
        } else {
            return compareListArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "compareListCell", for: indexPath) as! CompareListCell
        if searching == true {
            DispatchQueue.main.async(execute: {
                
                cell.label.text = self.searchString[indexPath.row].name
                let profileUrl = self.searchString[indexPath.row].image
                cell.imageProfile.loadImageUsingCacheWithUrlString(profileUrl)}
            )
            print("reload1")
        } else {
            DispatchQueue.main.async(execute: {
                cell.label.text = self.compareListArray[indexPath.row].name
                let profileUrl = self.compareListArray[indexPath.row].image
                cell.imageProfile.loadImageUsingCacheWithUrlString(profileUrl)}
            )
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        if searching == true {
            
            let compareVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbCompareID") as! CompareViewController
            compareVC.friendlist = searchString[(listTableView.indexPathForSelectedRow?.row)!]
            
            self.present(compareVC, animated: false, completion: {
                self.presentingViewController?.dismiss(animated: false, completion: {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window!.rootViewController!.present(compareVC, animated: false, completion: nil)
                })
            })
        } else {
            
            let compareVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbCompareID") as! CompareViewController
            compareVC.friendlist = compareListArray[(listTableView.indexPathForSelectedRow?.row)!]
            
            self.present(compareVC, animated: false, completion: {
                self.presentingViewController?.dismiss(animated: false, completion: {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window!.rootViewController!.present(compareVC, animated: false, completion: nil)
                })
            })
        }
    }
}

extension CompareListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            searching = false
            view.endEditing(true)
            listTableView.reloadData()
        } else {
            searching = true
            searchString = compareListArray.filter({$0.name.lowercased().prefix(searchText.count) == searchText.lowercased()})
            listTableView.reloadData()
        }
    }
}
