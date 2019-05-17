//
//  FourViewController.swift
//  MainCode
//
//  Created by Apple on 5/11/19.
//  Copyright © 2019 Kien. All rights reserved.
//

import UIKit

class FourViewController: UIViewController {
    @IBOutlet weak var arrowShareRoute: UIView!
    @IBOutlet weak var tableView: DesignableView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var hiddenView: UIView!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var arrowDown: UIView!
    @IBOutlet weak var hiddenButtonShare: UIView!
    @IBOutlet weak var thirdLabel: UIView!
    @IBOutlet weak var arrowDownTwo: UIView!
    @IBOutlet weak var hiddenButtonDone: UIView!
    
    @IBOutlet weak var mainView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.view.frame.size.width == 375 {
            self.mainView.image = UIImage(named: "onBoardingFourViewIp8")
        }
        
        self.view.alpha = 0
        self.tableView.isHidden = true
        self.arrowShareRoute.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        self.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        //
        //        showFourVC()
        //        showArrowIn()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        showFourVC()
        showArrowIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppDelegate.AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AppDelegate.AppUtility.lockOrientation(.all)
        
    }
    
    @IBAction func onClickDone(_ sender: UIButton) {
        
        let fiveVC = UIStoryboard(name: "OnBoarding", bundle: nil).instantiateViewController(withIdentifier: "sbFiveViewID") as! FiveViewController
        
        self.present(fiveVC, animated: false, completion: {
            self.presentingViewController?.dismiss(animated: false, completion: {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window!.rootViewController!.present(fiveVC, animated: false, completion: nil)
            })
        })
    }
    
    @IBAction func onClickButton(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
        showLabelDone()
    }
    
    @IBAction func onClickToShow(_ sender: UIButton) {
        showTableIn()
        showLabelTwoAndArrowD()
    }
    
    func showFourVC() {
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func showArrowIn() {
        UIView.animate(withDuration: 0.5, delay: 0.2, options: [.repeat, .autoreverse], animations: {
            self.arrowShareRoute.frame.origin.x += self.view.frame.size.width / 12
        }, completion: nil)
    }
    
    func showTableIn() {
        self.arrowShareRoute.isHidden = true
        self.firstLabel.isHidden = true
        self.hiddenButtonShare.isHidden = false
        self.tableView.isHidden = false
        self.tableView.alpha = 0
        self.tableView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 1.0) {
            self.tableView.alpha = 1
            self.tableView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func showLabelTwoAndArrowD() {
        self.secondLabel.isHidden = false
        self.arrowDown.isHidden = false
        self.secondLabel.alpha = 0
        self.arrowDown.alpha = 0
        self.secondLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        self.arrowDown.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 1.0, delay: 0.2, options: [], animations: {
            self.secondLabel.alpha = 1
            self.arrowDown.alpha = 1
            self.secondLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.arrowDown.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
    }
    
    func showLabelDone() {
        self.secondLabel.isHidden = true
        self.arrowDown.isHidden = true
        self.hiddenView.isHidden = false
        self.hiddenButtonDone.isHidden = true
        self.thirdLabel.isHidden = false
        self.arrowDownTwo.isHidden = false
        self.thirdLabel.alpha = 0
        self.arrowDownTwo.alpha = 0
        self.secondLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        self.arrowDown.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 1.0, delay: 0, options: [], animations: {
            self.thirdLabel.alpha = 1
            self.arrowDownTwo.alpha = 1
            self.thirdLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.arrowDownTwo.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
    }
    
}
