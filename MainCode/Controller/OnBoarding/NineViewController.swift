//
//  NineViewController.swift
//  MainCode
//
//  Created by Apple on 5/13/19.
//  Copyright © 2019 Kien. All rights reserved.
//

import UIKit

class NineViewController: UIViewController {
    @IBOutlet weak var arrowUView: UIView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var clickFaceView: UIView!
    @IBOutlet weak var mainView: UIImageView!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var threeLabel: UILabel!
    @IBOutlet weak var twoLabel: UILabel!
    @IBOutlet weak var oneLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.view.frame.size.width == 375 {
            self.mainView.image = UIImage(named: "onBoardingNineIp8")
        }
        
        self.view.alpha = 0
        self.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showNineVC()
        showArrowUFirstLabelIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppDelegate.AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AppDelegate.AppUtility.lockOrientation(.all)
        
    }
    
    @IBAction func onClickFacebook(_ sender: UIButton) {
        hiddenFirstActivitiesToContinue()
    }
    
    func showNineVC() {
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func showArrowUFirstLabelIn() {
        self.arrowUView.alpha = 0
        self.firstLabel.alpha = 0
        self.arrowUView.frame.origin.y += self.view.frame.size.height / 20
        self.firstLabel.frame.origin.y += self.view.frame.size.height / 20
        UIView.animate(withDuration: 1.0, delay: 0.2, options: [], animations: {
            self.arrowUView.alpha = 1
            self.firstLabel.alpha = 1
            self.arrowUView.frame.origin.y -= self.view.frame.size.height / 20
            self.firstLabel.frame.origin.y -= self.view.frame.size.height / 20
        }) { completed in
            self.clickFaceView.isHidden = false
        }
    }
    
    func hiddenFirstActivitiesToContinue() {
        self.clickFaceView.isHidden = true
        self.arrowUView.isHidden = true
        self.firstLabel.isHidden = true
        UIView.animate(withDuration: 1.0, delay: 0, options: [], animations: {
            self.mainView.alpha = 0
        }) { completed in
            UIView.animate(withDuration: 1.0, delay: 0, options: [], animations: {
                self.mainView.alpha = 1
                self.mainView.image = UIImage(named: "onBoardingIntroTheme")
            }, completion: { completed in
                self.secondLabel.isHidden = false
                self.startLabel.isHidden = false
                self.threeLabel.isHidden = false
                self.twoLabel.isHidden = false
                self.oneLabel.isHidden = false
                self.secondLabel.alpha = 0
                self.startLabel.alpha = 0
                self.threeLabel.alpha = 0
                self.twoLabel.alpha = 0
                self.oneLabel.alpha = 0
                self.secondLabel.frame.origin.y += self.view.frame.size.height / 20
                self.startLabel.frame.origin.y += self.view.frame.size.height / 20
                UIView.animate(withDuration: 1.0, delay: 0, options: [], animations: {
                    self.secondLabel.alpha = 1
                    self.secondLabel.frame.origin.y -= self.view.frame.size.height / 20
                }, completion: { completed in
                    UIView.animate(withDuration: 1.0, delay: 0, options: [], animations: {
                        self.startLabel.alpha = 1
                        self.startLabel.frame.origin.y -= self.view.frame.size.height / 20
                    }, completion: { completed in
                        self.threeLabel.alpha = 1
                        UIView.animate(withDuration: 1.0, delay: 0, options: [], animations: {
                            self.threeLabel.alpha = 0
                            self.threeLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                        }, completion: { completed in
                            self.twoLabel.alpha = 1
                            UIView.animate(withDuration: 1.0, delay: 0, options: [], animations: {
                                self.twoLabel.alpha = 0
                                self.twoLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                            }, completion: { completed in
                                self.oneLabel.alpha = 1
                                UIView.animate(withDuration: 1.0, delay: 0, options: [], animations: {
                                    self.oneLabel.alpha = 0
                                    self.oneLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                                }, completion: { completed in
                                    
                                    let mapNavigationVC = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "mapVC") as! MapViewController
                                    
                                    self.present(mapNavigationVC, animated: false, completion: {
                                        self.presentingViewController?.dismiss(animated: false, completion: {
                                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                            appDelegate.window!.rootViewController!.present(mapNavigationVC, animated: false, completion: nil)
                                        })
                                    })
                                })
                            })
                        })
                    })
                })
            })
        }
    }
    
}
