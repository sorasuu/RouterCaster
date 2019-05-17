//
//  SecondViewController.swift
//  MainCode
//
//  Created by Apple on 5/10/19.
//  Copyright © 2019 Kien. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    @IBOutlet weak var roundClickView: UIView!
    @IBOutlet weak var handClickView: UIView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.view.frame.size.width == 375 {
            self.mainImage.image = UIImage(named: "onBoardingIntroIp8")
        }
        
        //        self.view.alpha = 0
        //        self.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        //
        //        showSecondVC()
        //        showHandClickIn()
        //        showRoundClickIn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.alpha = 0
        self.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        self.roundClickView.alpha = 0
        self.handClickView.alpha = 0
        self.firstLabel.alpha = 0
        self.roundClickView.frame.origin.y += self.view.frame.size.height / 20
        self.handClickView.frame.origin.y += self.view.frame.size.height / 20
        self.firstLabel.frame.origin.y += self.view.frame.size.height / 20
        
        showSecondVC()
        showActivities()
        //        showHandClickIn()
        //        showRoundClickIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppDelegate.AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AppDelegate.AppUtility.lockOrientation(.all)
        
    }
    
    
    
    
    @IBAction func didTapMove(_ sender: UIButton) {
        let thirdVC = UIStoryboard(name: "OnBoarding", bundle: nil).instantiateViewController(withIdentifier: "sbThirdViewID") as! ThirdViewController
        
        self.present(thirdVC, animated: false, completion: {
            self.presentingViewController?.dismiss(animated: false, completion: {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window!.rootViewController!.present(thirdVC, animated: false, completion: nil)
            })
        })
    }
    
    func showSecondVC() {
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func showActivities() {
        UIView.animate(withDuration: 1.0, delay: 0.2, options: [], animations: {
            self.roundClickView.alpha = 1
            self.handClickView.alpha = 1
            self.firstLabel.alpha = 1
            self.roundClickView.frame.origin.y -= self.view.frame.size.height / 20
            self.handClickView.frame.origin.y -= self.view.frame.size.height / 20
            self.firstLabel.frame.origin.y -= self.view.frame.size.height / 20
        }) { completed in
            self.showRoundClickIn()
            self.showHandClickIn()
        }
    }
    
    func showRoundClickIn() {
        UIView.animate(withDuration: 1.0, delay: 0.3, options: [.repeat], animations: {
            self.roundClickView.alpha = 0
            self.roundClickView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { completed in
            
        }
    }
    
    func showHandClickIn() {
        UIView.animate(withDuration: 1.0, delay: 0.3, options: [.repeat], animations: {
            self.handClickView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { completed in
            
        }
    }
    
}
