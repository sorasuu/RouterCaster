//
//  LoginViewController.swift
//  MainCode
//
//  Created by Apple on 4/24/19.
//  Copyright © 2019 Kien. All rights reserved.
//

import UIKit
import TinyConstraints
import JGProgressHUD
class LoginViewController: UIViewController {

    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    @IBAction func doLogin(_ sender: UIButton)  {
      handleSignInWithFacebookButtonTapped()
    }
    
    func handleSignInWithFacebookButtonTapped() {
        hud.textLabel.text = "Signing in with Facebook..."
        hud.show(in: view)
        Spark.signInWithFacebook(in: self) { (message, err, sparkUser) in
            if let err = err {
                SparkService.dismissHud(self.hud, text: "Error", detailText: "\(message) \(err.localizedDescription)", delay: 3)
                return
            }
            guard let sparkUser = sparkUser else {
                SparkService.dismissHud(self.hud, text: "Error", detailText: "Failed to fetch user", delay: 3)
                return
            }
            
            print("Successfully signed in with Facebook with Spark User: \(sparkUser)")
            SparkService.dismissHud(self.hud, text: "Success", detailText: "Successfully signed in with Facebook", delay: 3)
            let when = DispatchTime.now() + 3
            
            let mainViewVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "viewControllerID") as! ViewController
            self.addChild(mainViewVC)
            mainViewVC.view.frame = self.view.frame
            self.view.addSubview(mainViewVC.view)
            mainViewVC.didMove(toParent: self)
            
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                self.dismiss(animated: true, completion: nil)
            })
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        // Do any additional setup after loading the view.
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
