//
//  BeforeStartedViewController.swift
//  MainCode
//
//  Created by Apple on 5/10/19.
//  Copyright © 2019 Kien. All rights reserved.
//

import UIKit

class BeforeStartedViewController: UIViewController {
    @IBOutlet weak var beforeStartedLogo: UIView!
    @IBOutlet weak var logoName: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beforeStartedLogo.alpha = 0
        logoName.alpha = 0
        beforeStartedLogo.frame.origin.x -= beforeStartedLogo.frame.size.width
        logoName.frame.origin.x += logoName.frame.size.width
        
        showBeforeLogoIn()
        showLogoNameIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppDelegate.AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AppDelegate.AppUtility.lockOrientation(.all)
        
    }
    
    func showBeforeLogoIn() {
        UIView.animate(withDuration: 1.0, animations: {
            self.beforeStartedLogo.alpha = 1
            self.beforeStartedLogo.frame.origin.x += self.beforeStartedLogo.frame.size.width
        }) { completed in
            UIView.animate(withDuration: 1.0, delay: 0.5, options: [], animations: {
                self.beforeStartedLogo.alpha = 0
                self.beforeStartedLogo.frame.origin.x += self.beforeStartedLogo.frame.size.width
            }, completion: { completed in
                
                let firstViewVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbFirstViewID") as! FirstViewController
                
                self.present(firstViewVC, animated: false, completion: {
                    self.presentingViewController?.dismiss(animated: false, completion: {
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window!.rootViewController!.present(firstViewVC, animated: false, completion: nil)
                    })
                })
            })
        }
    }
    
    func showLogoNameIn() {
        UIView.animate(withDuration: 1.0, animations: {
            self.logoName.alpha = 1
            self.logoName.frame.origin.x -= self.logoName.frame.size.width
        }) { completed in
            UIView.animate(withDuration: 1.0, delay: 0.5, options: [], animations: {
                self.logoName.alpha = 0
                self.logoName.frame.origin.x -= self.logoName.frame.size.width
            }, completion: { completed in
                
            })
        }
    }
    
    
    
}
