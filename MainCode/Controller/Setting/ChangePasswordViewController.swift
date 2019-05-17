//
//  ChangePasswordViewController.swift
//  Setting
//
//  Created by tang quang an on 5/8/19.
//  Copyright © 2019 Setting. All rights reserved.
//

import UIKit
import Firebase

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var btnSavePassword: UIButton!
    @IBOutlet weak var currentPasswordLb: UITextField!
    
    @IBAction func didPressSavePassword(_ sender: UIButton) {
        
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
    
    
    @IBAction func didPressSave(_ sender: Any) {
//        if currentPasswordLb.text == "123456" && newPasswordLb.text != currentPasswordLb.text && newPasswordLb.text == confirmPasswordLb.text && newPasswordLb.text!.count > 0 {
//
//            // Do something to change the password
//
//            let alert = UIAlertController(title: "Password changed", message: "", preferredStyle: .alert)
//
//            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
//                self.dismiss(animated: false, completion: nil)
//            }))
//            self.present(alert, animated: true)
//
//        } else {
//            let alert = UIAlertController(title: "Can't set new password", message: "Please re-enter your new password", preferredStyle: .alert)
//
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
//                alert.dismiss(animated: true, completion: nil)
//            }))
//            self.present(alert, animated: true)
//        }
        
        let currentUserEmail = Auth.auth().currentUser?.email
        Auth.auth().sendPasswordReset(withEmail: currentUserEmail!){ err in if(err != nil){
            let alert = UIAlertController(title: "Error", message: err as! String, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
            }
        }
        let alert = UIAlertController(title: "Email sent", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    
    
//    var longGesture: UILongPressGestureRecognizer?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    
    }
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        
        print("AAAAAAAAA")
    }
    
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        
       
        if (sender.state == .ended) {
            print("BBBBBBB")
        }
        // do something
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
