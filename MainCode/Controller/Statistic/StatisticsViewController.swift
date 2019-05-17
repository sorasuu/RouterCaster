//
//  StatisticsViewController.swift
//  MainCode
//
//  Created by Apple on 4/26/19.
//  Copyright © 2019 Kien. All rights reserved.
//

import UIKit
import Charts
import JGProgressHUD

class StatisticsViewController: UIViewController, UIScrollViewDelegate {
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    
    @IBOutlet weak var segmentsView: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var compareView: UIView!
    @IBOutlet weak var totalDistanceView: UIView!
    @IBOutlet weak var totalTimeView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalDistanceSquareView: UIView!
    @IBOutlet weak var averageSpeedSquareView: UIView!
    @IBOutlet weak var totalTimeSquareView: UIView!
    @IBOutlet weak var averageTimeSquareView: UIView!
    @IBOutlet weak var outOfRouteView: UIView!
    @IBOutlet weak var chartView: UIView!
    
    @IBOutlet weak var realChart: LineChartView!
    @IBOutlet weak var realChartMonthly: LineChartView!
    
    @IBOutlet weak var defaultProfile: UIImageView!
    @IBOutlet weak var profilebarname: UILabel!
    @IBOutlet weak var mainDefaultProfile: UIImageView!
    @IBOutlet weak var mainprofilebarname: UILabel!
    
    //navigation
    @IBOutlet weak var mainViewSideBar: UIView!
    @IBOutlet weak var testSideBar: UIView!
    @IBOutlet weak var viewMoveMagic: UIView!
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
    
    @IBOutlet weak var totalDistanceValue: UILabel!
    @IBOutlet weak var totalDistanceValueMonth: UILabel!
    @IBOutlet weak var averageSpeedDate: UILabel!
    @IBOutlet weak var averageSpeedMonth: UILabel!
    @IBOutlet weak var totalTimeDate: UILabel!
    @IBOutlet weak var totalTimeMonth: UILabel!
    @IBOutlet weak var averageTimeDate: UILabel!
    @IBOutlet weak var averageTimeMonth: UILabel!
    @IBOutlet weak var outOfRouteValueDate: UILabel!
    @IBOutlet weak var outOfRouteValueMonth: UILabel!
    
        @IBOutlet weak var arrowImage: UIImageView!
    
    
    
    var yNumbersOfAverageDistance: [Double] = [300,300,700,0,500,500,100,100,300,100,300]
    var yNumbersOfAverageTime: [Double] = [100,50,300,100,300,300,300,700,100,100,1000]
    
    var yNumbersOfAverageDistanceMonthly: [Double] = [300,300,700,0,500,500,100,100,300,100,300]
    var yNumbersOfAverageTimeMonthly: [Double] = [100,50,300,100,300,300,300,700,100,100,1000]
    
    var line1ChartEntry = [ChartDataEntry]()
    var line2ChartEntry = [ChartDataEntry]()
    
    var line1ChartEntryMonthly = [ChartDataEntry]()
    var line2ChartEntryMonthly = [ChartDataEntry]()
    
    var backInfo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrentUser()
        arrowImage.tintColor = UIColor(red: CGFloat(255)/255.0, green: CGFloat(255)/255.0, blue: CGFloat(255)/255.0, alpha: 1)
//        self.mainScrollView.frame.origin.x += self.mainScrollView.frame.size.width
        //self.view.removeFromSuperview()
        
        
        
        statisticsIcon.tintColor = UIColor(red: CGFloat(255)/255.0, green: CGFloat(255)/255.0, blue: CGFloat(255)/255.0, alpha: 1)
        peopleIcon.tintColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
        
        testSideBar.frame.origin.x -= testSideBar.frame.size.width
        
        realChart.chartDescription?.text = ""
        
        //Weekly Chart
        for i in 0..<yNumbersOfAverageDistance.count {
            let value = ChartDataEntry(x: Double(i) * 100, y: yNumbersOfAverageDistance[i])
            line1ChartEntry.append(value)
        }
        
        for i in 0..<yNumbersOfAverageTime.count {
            let value = ChartDataEntry(x: Double(i) * 100, y: yNumbersOfAverageTime[i])
            line2ChartEntry.append(value)
        }
        
        //Monthly Chart
        
        for i in 0..<yNumbersOfAverageDistanceMonthly.count {
            let value = ChartDataEntry(x: Double(i) * 100, y: yNumbersOfAverageDistanceMonthly[i])
            line1ChartEntryMonthly.append(value)
        }
        
        for i in 0..<yNumbersOfAverageTimeMonthly.count {
            let value = ChartDataEntry(x: Double(i) * 100, y: yNumbersOfAverageTimeMonthly[i])
            line2ChartEntryMonthly.append(value)
        }
        
        updateGraph()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        testSideBar.frame.origin.x -= testSideBar.frame.size.width
    }
    
    //update sidebar when rotation
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
    
    func fetchStatistic()  {
        
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
                self.mainDefaultProfile.loadImageUsingCacheWithUrlString(sparkUser.profileImageUrl)
                self.profilebarname.text = sparkUser.name
                self.mainprofilebarname.text = sparkUser.name
                
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
    @IBAction func menuSideBar(_ sender: UIButton) {
        showTestSideBar()
    }
    
    func showTestSideBar() {
        mainViewSideBar.isHidden = false
        testSideBar.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.testSideBar.frame.origin.x += self.testSideBar.frame.size.width
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        closeTestSideBar()
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
        closeTestSideBar()
    }
    
    @IBAction func onClickMoveToSettings(_ sender: UIButton) {
        closeSideBarToMoveToSettings()
    }
    
    @IBAction func onClickMoveToCompareList(_ sender: UIButton) {

        let comparelistVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbCompareListID") as! CompareListViewController
        
        self.present(comparelistVC, animated: false, completion: {
            self.presentingViewController?.dismiss(animated: false, completion: {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window!.rootViewController!.present(comparelistVC, animated: false, completion: nil)
            })
        })
    }
    
    func closeSideBarToMoveToFriendlist() {
        UIView.animate(withDuration: 0.2, animations: {
            self.viewMoveMagic.frame.origin.y = self.peopleIcon.frame.origin.y - 13
            self.statisticsIcon.tintColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
            self.statisticsText.textColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
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
    
    func closeSideBarToMoveToNavigation() {
        UIView.animate(withDuration: 0.2, animations: {
            self.viewMoveMagic.frame.origin.y = self.navigationIcon.frame.origin.y - 10
            self.statisticsIcon.tintColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
            self.statisticsText.textColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
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
            self.viewMoveMagic.frame.origin.y = self.messengerIcon.frame.origin.y - 10
            self.statisticsIcon.tintColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
            self.statisticsText.textColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
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
            self.viewMoveMagic.frame.origin.y = self.settingsIcon.frame.origin.y - 10
            self.statisticsIcon.tintColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
            self.statisticsText.textColor = UIColor(red: CGFloat(79)/255.0, green: CGFloat(138)/255.0, blue: CGFloat(182)/255.0, alpha: 1)
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
    
    
    func updateGraph() {
        //Weekly Chart
        let line1 = LineChartDataSet(entries: line1ChartEntry, label: "Average Distance")
        line1.colors = [NSUIColor(red: CGFloat(124)/255.0, green: CGFloat(205)/255.0, blue: CGFloat(209)/255.0, alpha: 1)]
        let line2 = LineChartDataSet(entries: line2ChartEntry, label: "Average Time")
        line2.colors = [NSUIColor.blue]
        let data = LineChartData()
        data.addDataSet(line1)
        data.addDataSet(line2)
        realChart.data = data
        
        
        realChart.animate(xAxisDuration: 6.0, yAxisDuration: 8.0, easingOption: .easeInOutBounce)
        
        //xAxis
        realChart.xAxis.drawGridLinesEnabled = false
        realChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        //leftAxis
        realChart.leftAxis.drawGridLinesEnabled = false
        realChart.leftAxis.drawBottomYLabelEntryEnabled = false
        realChart.leftAxis.axisMinimum = 0
        
        //rightAxis
        realChart.rightAxis.drawAxisLineEnabled = false
        realChart.rightAxis.drawGridLinesEnabled = false
        realChart.rightAxis.labelTextColor = UIColor.clear
        
        //setup line
        line1.drawValuesEnabled = false
        line2.drawValuesEnabled = false
        
        
        //Monthly Chart
        let line1Monthly = LineChartDataSet(entries: line1ChartEntryMonthly, label: "Average Distance")
        line1Monthly.colors = [NSUIColor(red: CGFloat(124)/255.0, green: CGFloat(205)/255.0, blue: CGFloat(209)/255.0, alpha: 1)]
        let line2Monthly = LineChartDataSet(entries: line2ChartEntryMonthly, label: "Average Time")
        line2Monthly.colors = [NSUIColor.blue]
        let dataMonthly = LineChartData()
        dataMonthly.addDataSet(line1Monthly)
        dataMonthly.addDataSet(line2Monthly)
        realChartMonthly.data = dataMonthly
        
        //xAxis
        realChartMonthly.xAxis.drawGridLinesEnabled = false
        realChartMonthly.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        //leftAxis
        realChartMonthly.leftAxis.drawGridLinesEnabled = false
        realChartMonthly.leftAxis.drawBottomYLabelEntryEnabled = false
        realChartMonthly.leftAxis.axisMinimum = 0
        
        //rightAxis
        realChartMonthly.rightAxis.drawAxisLineEnabled = false
        realChartMonthly.rightAxis.drawGridLinesEnabled = false
        realChartMonthly.rightAxis.labelTextColor = UIColor.clear
        
        //setup line
        line1Monthly.drawValuesEnabled = false
        line2Monthly.drawValuesEnabled = false
    }
    
    //test
    
    @IBAction func segmentsAction(_ sender: UISegmentedControl) {
        if segmentsView.selectedSegmentIndex == 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        else if segmentsView.selectedSegmentIndex == 1 {
            scrollView.setContentOffset(CGPoint(x: 414, y: 0), animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let w = scrollView.frame.size.width
        let page = scrollView.contentOffset.x / w
        //        print("\(page)")
        segmentsView.selectedSegmentIndex = Int(page)
        
//        let mainH = mainScrollView.frame.size.height
//        let mainPage = mainScrollView.contentOffset.y / mainH
//        print("\(mainPage)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.view.frame.origin.x += self.view.frame.size.width
        
//        self.mainScrollView.frame.origin.x += self.mainScrollView.frame.size.width
        
//        compareView.frame.origin.x -= compareView.frame.origin.x
//        self.totalDistanceView.frame.origin.x -= self.view.frame.size.width
//        self.totalTimeView.frame.origin.x += self.view.frame.size.width
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if backInfo == "back" {
            self.view.frame.origin.x -= self.view.frame.size.width
            showStatisticsViewFromLeftToRight()
        } else {
            self.view.frame.origin.x += self.view.frame.size.width
            showStatisticsView()
        }

        
        //Fire Animation
        //showStatisticsView()
        showCompareView()
        showTotalDistanceView()
        showTotalTimeView()
        showDateLabel()
        showTotalDistanceAndTotalTime()
        showAverageSpeedAndAverageTime()
        showOutOfRouteView()
        showChartView()
    }
    
    func showStatisticsView() {
        UIView.animate(withDuration: 0.5) {
            self.view.frame.origin.x -= self.view.frame.size.width
        }
    }
    
    func showStatisticsViewFromLeftToRight() {
        UIView.animate(withDuration: 0.5) {
            self.view.frame.origin.x += self.view.frame.size.width
        }
    }
    
    
    func showCompareView() {
        if self.compareView != nil {
            self.compareView.frame.origin.x += self.view.frame.size.width
            UIView.animate(withDuration: 2.0, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
                self.compareView.frame.origin.x -= self.view.frame.size.width
            }) { completed in
                
            }
        } else {return}
    }
    
    func showTotalDistanceView() {
        self.totalDistanceView.frame.origin.x -= self.view.frame.size.width
        UIView.animate(withDuration: 2.0, delay: 0.3, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.totalDistanceView.frame.origin.x += self.view.frame.size.width
        }) { completed in
            
        }
    }
    
    func showTotalTimeView() {
        self.totalTimeView.frame.origin.x += self.view.frame.size.width
        UIView.animate(withDuration: 2.0, delay: 0.4, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.totalTimeView.frame.origin.x -= self.view.frame.size.width
        }) { completed in
            
        }
    }
    
    func showDateLabel() {
        self.dateLabel.frame.origin.x -= self.view.frame.size.width
        UIView.animate(withDuration: 2.0, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.dateLabel.frame.origin.x += self.view.frame.size.width
        }) { completed in
            
        }
    }
    
    func showTotalDistanceAndTotalTime() {
        self.totalDistanceSquareView.frame.origin.x -= self.view.frame.size.width
        self.totalTimeSquareView.frame.origin.x += self.view.frame.size.width
        UIView.animate(withDuration: 2.0, delay: 0.6, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.totalDistanceSquareView.frame.origin.x += self.view.frame.size.width
            self.totalTimeSquareView.frame.origin.x -= self.view.frame.size.width
        }) { completed in
            
        }
    }
    
    func showAverageSpeedAndAverageTime() {
        self.averageSpeedSquareView.frame.origin.x -= self.view.frame.size.width
        self.averageTimeSquareView.frame.origin.x += self.view.frame.size.width
        UIView.animate(withDuration: 2.0, delay: 0.7, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.averageSpeedSquareView.frame.origin.x += self.view.frame.size.width
            self.averageTimeSquareView.frame.origin.x -= self.view.frame.size.width
        }) { completed in
            
        }
    }
    
    func showOutOfRouteView() {
        self.outOfRouteView.frame.origin.x += self.view.frame.size.width
        UIView.animate(withDuration: 2.0, delay: 0.8, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.outOfRouteView.frame.origin.x -= self.view.frame.size.width
        }) { completed in
            
        }
    }
    
    func showChartView() {
        self.chartView.frame.origin.x -= self.view.frame.size.width
        UIView.animate(withDuration: 2.0, delay: 0.9, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.chartView.frame.origin.x += self.view.frame.size.width
        }) { completed in
            
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
