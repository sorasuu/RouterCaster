//
//  EightViewController.swift
//  MainCode
//
//  Created by Apple on 5/13/19.
//  Copyright © 2019 Kien. All rights reserved.
//

import UIKit

class EightViewController: UIViewController {
    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var arrowUView: UIView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var boxTwoView: UIView!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var hiddenFirstButton: UIView!
    @IBOutlet weak var firstHand: UIView!
    @IBOutlet weak var hiddenShareButton: UIView!
    @IBOutlet weak var hiddenDoneButton: UIView!
    @IBOutlet weak var secondHand: UIView!
    @IBOutlet weak var thirdLabel: UILabel!
    
    @IBOutlet weak var hiddenStartView: UIView!
    @IBOutlet weak var arrowDVIew: UIView!
    @IBOutlet weak var fourLabel: UILabel!
    
    
    @IBOutlet weak var mainImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.view.frame.size.width == 375 {
            self.mainImage.image = UIImage(named: "onBoardingEightIp8")
        }
        
        self.view.alpha = 0
        self.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showEightVC()
        showBoxViewArrowUAndFirstLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppDelegate.AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AppDelegate.AppUtility.lockOrientation(.all)
        
    }
    
    @IBAction func onClickStartButton(_ sender: UIButton) {
        
        let nineVC = UIStoryboard(name: "OnBoarding", bundle: nil).instantiateViewController(withIdentifier: "sbNineViewID") as! NineViewController
        
        self.present(nineVC, animated: false, completion: {
            self.presentingViewController?.dismiss(animated: false, completion: {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window!.rootViewController!.present(nineVC, animated: false, completion: nil)
            })
        })
    }
    
    @IBAction func onClickShareButton(_ sender: UIButton) {
        hiddenFirstLabelArrowUpToContinue()
    }
    
    @IBAction func onClickFriendToShare(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
        hiddenSecondActivitiesToContinue()
    }
    
    @IBAction func onClickDoneButton(_ sender: UIButton) {
        hiddenThirdActivitiesToContinue()
    }
    
    func showEightVC() {
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func showBoxViewArrowUAndFirstLabel() {
        self.boxView.alpha = 0
        self.arrowUView.alpha = 0
        self.firstLabel.alpha = 0
        self.boxView.frame.origin.y += self.view.frame.size.height / 20
        UIView.animate(withDuration: 1.0, delay: 0.2, options: [], animations: {
            self.boxView.alpha = 1
            self.boxView.frame.origin.y -= self.view.frame.size.height / 20
        }) { completed in
            self.arrowUView.frame.origin.y += self.view.frame.size.height / 20
            self.firstLabel.frame.origin.y += self.view.frame.size.height / 20
            UIView.animate(withDuration: 1.0, delay: 0, options: [], animations: {
                self.arrowUView.alpha = 1
                self.arrowUView.frame.origin.y -= self.view.frame.size.height / 20
                self.firstLabel.alpha = 1
                self.firstLabel.frame.origin.y -= self.view.frame.size.height / 20
            }, completion: nil)
        }
    }
    
    func hiddenFirstLabelArrowUpToContinue() {
        self.arrowUView.isHidden = true
        self.firstLabel.isHidden = true
        self.hiddenFirstButton.isHidden = false
        self.boxTwoView.isHidden = false
        self.boxTwoView.alpha = 0
        self.boxTwoView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        self.secondLabel.isHidden = false
        self.secondLabel.alpha = 0
        self.firstHand.isHidden = false
        self.firstHand.alpha = 0
        UIView.animate(withDuration: 1.0, delay: 0, options: [], animations: {
            self.boxTwoView.alpha = 1
            self.boxTwoView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { completed in
            self.secondLabel.frame.origin.y += self.view.frame.size.height / 20
            self.firstHand.frame.origin.x -= self.view.frame.size.width / 20
            UIView.animate(withDuration: 1.0, delay: 0, options: [], animations: {
                self.secondLabel.alpha = 1
                self.firstHand.alpha = 1
                self.secondLabel.frame.origin.y -= self.view.frame.size.height / 20
                self.firstHand.frame.origin.x += self.view.frame.size.width / 20
            }, completion: { completed in
                self.repeatFirstHand()
            })
        }
    }
    
    func repeatFirstHand() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.firstHand.frame.origin.x -= self.view.frame.size.width / 20
        }, completion: nil)
    }
    
    func hiddenSecondActivitiesToContinue() {
        self.hiddenShareButton.isHidden = false
        self.hiddenDoneButton.isHidden = true
        self.secondLabel.isHidden = true
        self.firstHand.isHidden = true
        self.secondHand.isHidden = false
        self.thirdLabel.isHidden = false
        self.secondHand.alpha = 0
        self.thirdLabel.alpha = 0
        self.thirdLabel.frame.origin.y += self.view.frame.size.height / 20
        self.secondHand.frame.origin.x -= self.view.frame.size.width / 20
        UIView.animate(withDuration: 1.0, delay: 0, options: [], animations: {
            self.secondHand.alpha = 1
            self.thirdLabel.alpha = 1
            self.thirdLabel.frame.origin.y -= self.view.frame.size.height / 20
            self.secondHand.frame.origin.x += self.view.frame.size.width / 20
        }) { completed in
            self.repeatSecondHand()
        }
    }
    
    func repeatSecondHand() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.secondHand.frame.origin.x -= self.view.frame.size.width / 20
        }, completion: nil)
    }
    
    func hiddenThirdActivitiesToContinue() {
        self.hiddenDoneButton.isHidden = false
        self.hiddenStartView.isHidden = true
        self.boxTwoView.isHidden = true
        self.secondHand.isHidden = true
        self.thirdLabel.isHidden = true
        self.arrowDVIew.isHidden = false
        self.fourLabel.isHidden = false
        self.arrowDVIew.alpha = 0
        self.fourLabel.alpha = 0
        self.arrowDVIew.frame.origin.x -= self.view.frame.size.width / 20
        self.thirdLabel.frame.origin.x -= self.view.frame.size.width / 20
        UIView.animate(withDuration: 1.0, delay: 0, options: [], animations: {
            self.arrowDVIew.alpha = 1
            self.fourLabel.alpha = 1
            self.arrowDVIew.frame.origin.x += self.view.frame.size.width / 20
            self.thirdLabel.frame.origin.x += self.view.frame.size.width / 20
        }, completion: nil)
    }
    
}
