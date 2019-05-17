//
//  PersonalInfoViewController.swift
//  Setting
//
//  Created by tang quang an on 5/9/19.
//  Copyright © 2019 Setting. All rights reserved.
//

import UIKit

class PersonalInfoViewController: UIViewController {

    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var firstNameTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Check account type and disable the email textfield if ...
        emailTxtField.isEnabled = false
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didPressBack(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false) {
        }
    }
    
//    let hud: JGProgressHUD = {
//        let hud = JGProgressHUD(style: .light)
//        hud.interactionType = .blockAllTouches
//        return hud
//    }()
//    
//    func fetchCurrentUser() {
//        
//        Spark.fetchCurrentSparkUser { (message, err, sparkUser) in
//            if let err = err {
//                SparkService.dismissHud(self.hud, text: "Error", detailText: "\(message) \(err.localizedDescription)", delay: 0)
//                return
//            }
//            guard let sparkUser = sparkUser else {
//                SparkService.dismissHud(self.hud, text: "Error", detailText: "Failed to fetch user", delay: 0 )
//                return
//            }
//            
//            DispatchQueue.main.async {
//                
//            }
//            
//            SparkService.dismissHud(self.hud, text: "Success", detailText: "Successfully fetched user", delay: 0)
//            
//        }
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
