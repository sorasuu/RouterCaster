//
//  ThirdViewController.swift
//  MainCode
//
//  Created by Apple on 5/11/19.
//  Copyright © 2019 Kien. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    @IBOutlet weak var arrowHorizontal: UIView!
    @IBOutlet weak var arrowVertical: UIView!
    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var tapText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.view.frame.size.width == 375 {
            self.mainImage.image = UIImage(named: "onBoardingIntroIp8")
        }
        
        //        self.view.alpha = 0
        //        self.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        //
        //
        //        showThirdVC()
        //        showArrowHorizontalIn()
        //        showArrowVerticalIn()
        //        showTapIn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.alpha = 0
        self.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        
        showThirdVC()
        showArrowHorizontalIn()
        showArrowVerticalIn()
        showTapIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppDelegate.AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AppDelegate.AppUtility.lockOrientation(.all)
        
    }
    
    func showThirdVC() {
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    @IBAction func didTapMove(_ sender: UIButton) {
        
        let fourVC = UIStoryboard(name: "OnBoarding", bundle: nil).instantiateViewController(withIdentifier: "sbFourViewID") as! FourViewController
        
        self.present(fourVC, animated: false, completion: {
            self.presentingViewController?.dismiss(animated: false, completion: {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window!.rootViewController!.present(fourVC, animated: false, completion: nil)
            })
        })
    }
    
    func showArrowHorizontalIn() {
        UIView.animate(withDuration: 1.0, delay: 0.2, options: [.repeat, .autoreverse], animations: {
            self.arrowHorizontal.frame.origin.x += self.view.frame.size.width / 10
        }, completion: nil)
        
    }
    
    func showArrowVerticalIn() {
        UIView.animate(withDuration: 1.0, delay: 0.2, options: [.repeat, .autoreverse], animations: {
            self.arrowVertical.frame.origin.y += self.view.frame.size.height / 10
        }, completion: nil)
    }
    
    func showTapIn() {
        UIView.animate(withDuration: 1.0, delay: 0.2, options: [.repeat], animations: {
            self.tapText.alpha = 0
            self.tapText.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: nil)
    }
    
}
