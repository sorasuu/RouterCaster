//
//  PopUpViewController.swift
//  MainCode
//
//  Created by Apple on 4/23/19.
//  Copyright © 2019 Kien. All rights reserved.
//

import UIKit
import Firebase

class PopUpViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var requestTableView: UITableView!
    var position: Int = 0
    var listRequestUser = [User]()
    let currentUser = Auth.auth().currentUser?.uid
    fileprivate  func fetchRequestUser(){
        Firestore.firestore().collection("friendrequest").whereField("receiverId", isEqualTo: currentUser as Any).getDocuments(){
            (querySnapshot,err) in if (err != nil){
                print("fetch request fail with error : ", err as Any)
            } else{
                for document in querySnapshot!.documents{
                    
                    let senderId = document.data()["senderId"] as? String
                    print("Requsest from this user",senderId as Any)
                    Firestore.firestore().collection("users").whereField("uid", isEqualTo: senderId as Any).getDocuments(){
                        (querySnapshot, err) in if (err != nil){
                            print("fetch request user fail with error : ", err as Any)
                            
                        }else{
                            for document in querySnapshot!.documents{
                                let user = User()
                                print("request user", user.name as Any)
                                user.uid = document.data()["uid"] as? String
                                user.name = document.data()["name"] as? String
                                user.email = document.data()["email"] as? String
                                user.profileImageUrl = document.data()["profileImageUrl"] as? String
                                self.listRequestUser.append(user)
                                DispatchQueue.main.async {
                                    self.requestTableView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listRequestUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellRequest", for: indexPath) as! CustomCellRequest
        cell.uid = listRequestUser[indexPath.row].uid
        cell.label.text = listRequestUser[indexPath.row].name
        cell.imageProfile.loadImageUsingCacheWithUrlString(listRequestUser[indexPath.row].profileImageUrl!)
        cell.cellDelegate = self
        cell.index = indexPath
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRequestUser()
        //        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        self.view.backgroundColor = UIColor.init(displayP3Red: 0, green: 0, blue: 0, alpha: 0.1)
        
        self.showAnimate()
        // Do any additional setup after loading the view.
    }
    @IBAction func didClosePopUp(_ sender: Any) {
        self.removeAnimate()
    }
    @IBAction func didClosePopUpBottom(_ sender: Any) {
        self.removeAnimate()
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


extension PopUpViewController: TableViewRequest {
    func onClickDeny(index: Int) {
        listRequestUser.remove(at: index)
        requestTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        DispatchQueue.main.async {
            self.requestTableView.reloadData()
        }
    }
    
    func onClickAccept(index: Int) {
        listRequestUser.remove(at: index)
        requestTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        DispatchQueue.main.async {
            self.requestTableView.reloadData()
        }
    }
    
}
