//
//  SettingViewController.swift
//  Setting
//
//  Created by tang quang an on 5/7/19.
//  Copyright © 2019 Setting. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import JGProgressHUD
import SwiftyJSON
import FirebaseStorage
import Dwifft

class SettingViewController: UIViewController, UIScrollViewDelegate {
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()

    @IBOutlet weak var profilebarname: UILabel!
    @IBOutlet weak var defaultProfile: UIImageView!
    
    
    @IBOutlet weak var settingScrollView: UIScrollView!
    
    
    @IBOutlet weak var mainViewSideBar: UIView!
    @IBOutlet weak var testSideBar: UIView!
    @IBOutlet weak var moveMagicView: UIView!
    @IBOutlet weak var navigationIcon: UIImageView!
    @IBOutlet weak var navigationText: UILabel!
    @IBOutlet weak var messengerIcon: UIImageView!
    @IBOutlet weak var chatsText: UILabel!
    @IBOutlet weak var peopleIcon: UIImageView!
    @IBOutlet weak var friendListText: UILabel!
    @IBOutlet weak var statisticsIcon: UIImageView!
    @IBOutlet weak var statisticsText: UILabel!
    @IBOutlet weak var settingsIcon: UIImageView!
    @IBOutlet weak var settingsText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrentUser()
        
        
        testSideBar.frame.origin.x -= testSideBar.frame.size.width
        self.peopleIcon.tintColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
        self.settingsIcon.tintColor = .white
        self.statisticsIcon.tintColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.frame.origin.x += self.view.frame.size.width
        showSettingsView()
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
                //print(self.settingView.frame.origin.x)
                //print(self.settingView.frame.origin.y)
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
                //print(self.settingView.frame.origin.x)
                //print(self.settingView.frame.origin.y)
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
    
    //Navigation
    @IBAction func onClickMenuSideBar(_ sender: UIButton) {
        showTestSideBar()
    }
    
    @IBAction func onClickCloseSideBar(_ sender: UIButton) {
        closeTestSideBar()
    }
    
    
    @IBAction func onClickMoveToNavigation(_ sender: UIButton) {
        closeSideBarToMoveToNavigation()
    }
    
    @IBAction func onClickMoveToChats(_ sender: UIButton) {
        closeSideBarToMoveToChats()
    }
    
    @IBAction func onClickMoveToFriendlist(_ sender: UIButton) {
        closeSideBarToMoveToFriendlist()
    }
    
    @IBAction func onClickMoveToStatistics(_ sender: UIButton) {
        closeSideBarToMoveToStatistic()
    }
    
    @IBAction func onClickMoveToSettings(_ sender: UIButton) {
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
            self.moveMagicView.frame.origin.y = self.statisticsIcon.frame.origin.y - 13
            self.settingsIcon.tintColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
            self.settingsText.textColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
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
    
    func closeSideBarToMoveToFriendlist() {
        UIView.animate(withDuration: 0.2, animations: {
            self.moveMagicView.frame.origin.y = self.peopleIcon.frame.origin.y - 13
            self.settingsIcon.tintColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
            self.settingsText.textColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
            self.peopleIcon.tintColor = UIColor(red: CGFloat(255)/255.0, green: CGFloat(255)/255.0, blue: CGFloat(255)/255.0, alpha: 1)
            self.friendListText.textColor = UIColor(red: CGFloat(255)/255.0, green: CGFloat(255)/255.0, blue: CGFloat(255)/255.0, alpha: 1)
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
    
    func closeSideBarToMoveToChats() {
        UIView.animate(withDuration: 0.2, animations: {
            self.moveMagicView.frame.origin.y = self.messengerIcon.frame.origin.y - 10
            self.settingsIcon.tintColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
            self.settingsText.textColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
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
    
    func closeSideBarToMoveToNavigation() {
        UIView.animate(withDuration: 0.2, animations: {
            self.moveMagicView.frame.origin.y = self.navigationIcon.frame.origin.y - 13
            self.settingsIcon.tintColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
            self.settingsText.textColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
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
    
    
    func showSettingsView() {
        UIView.animate(withDuration: 0.5) {
            //            self.view.alpha = 1
            //            self.mainScrollView.frame.origin.x -= self.mainScrollView.frame.size.width
            self.view.frame.origin.x -= self.view.frame.size.width
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
    }

}

