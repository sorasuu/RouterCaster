//
//  SevenViewController.swift
//  MainCode
//
//  Created by Apple on 5/12/19.
//  Copyright © 2019 Kien. All rights reserved.
//

import UIKit

class SevenViewController: UIViewController {
    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var arrowLeft: UIView!
    
    @IBOutlet weak var mainImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.view.frame.size.width == 375 {
            self.mainImage.image = UIImage(named: "onBoardingSevenIp8")
        }
        
        self.view.alpha = 0
        self.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showSevenVC()
        showBoxViewIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppDelegate.AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AppDelegate.AppUtility.lockOrientation(.all)
        
    }
    
    @IBAction func onClickDirection(_ sender: UIButton) {
        
        let eightVC = UIStoryboard(name: "OnBoarding", bundle: nil).instantiateViewController(withIdentifier: "sbEightViewID") as! EightViewController
        
        self.present(eightVC, animated: false, completion: {
            self.presentingViewController?.dismiss(animated: false, completion: {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window!.rootViewController!.present(eightVC, animated: false, completion: nil)
            })
        })
    }
    
    func showSevenVC() {
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func showBoxViewIn() {
        self.arrowLeft.alpha = 0
        self.firstLabel.alpha = 0
        self.arrowLeft.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        self.firstLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        self.boxView.alpha = 0
        self.boxView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 1.0, delay: 0.2, options: [], animations: {
            self.boxView.alpha = 1
            self.boxView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { completed in
            UIView.animate(withDuration: 1.0, delay: 0, options: [], animations: {
                self.arrowLeft.alpha = 1
                self.firstLabel.alpha = 1
                self.arrowLeft.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.firstLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: { completed in
                self.showFirstLabelIn()
                self.showArrowLeftIn()
            })
        }
    }
    
    func showFirstLabelIn() {
        UIView.animate(withDuration: 0.5, delay: 0.2, options: [.repeat], animations: {
            self.firstLabel.alpha = 0
            self.firstLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: nil)
    }
    
    func showArrowLeftIn() {
        self.arrowLeft.frame.origin.x += self.view.frame.size.width / 20
        UIView.animate(withDuration: 0.5, delay: 0.2, options: [.repeat, .autoreverse], animations: {
            self.arrowLeft.frame.origin.x -= self.view.frame.size.width / 20
        }, completion: nil)
    }
}
