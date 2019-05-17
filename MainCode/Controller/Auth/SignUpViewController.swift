//
//  SignUpController.swift
//  CreateFirebaseUser
//
//  Created by SoraSuu on 4/24/19.
//  Copyright © 2019 SoraSuu. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import TinyConstraints
import JGProgressHUD
class SignUpViewController: UIViewController, GIDSignInUIDelegate {
    
    // MARK: - Properties
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "Logo")
        return iv
    }()
    let imgbackground: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "Rectangle Copy")
        return img
    }()
    lazy var emailContainerView: UIView = {
        let view = UIView()
        return view.textContainerView(view: view, #imageLiteral(resourceName: "Email"), emailTextField)
    }()
    
    lazy var usernameContainerView: UIView = {
        let view = UIView()
        return view.textContainerView(view: view, #imageLiteral(resourceName: "Name"), usernameTextField)
    }()
    
    lazy var passwordContainerView: UIView = {
        let view = UIView()
        return view.textContainerView(view: view, #imageLiteral(resourceName: "Rectangle Copy 2"), passwordTextField)
    }()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        return tf.textField(withPlaceolder: "Email", isSecureTextEntry: false)
    }()
    
    lazy var usernameTextField: UITextField = {
        let tf = UITextField()
        return tf.textField(withPlaceolder: "Username", isSecureTextEntry: false)
    }()
    
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        return tf.textField(withPlaceolder: "Password", isSecureTextEntry: true)
    }()
    
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "SignUp"), for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    lazy var dividerView: UIView = {
        let dividerView = UIView()
        
        let label = UILabel()
        label.text = "OR"
        label.textColor = UIColor(white: 1, alpha: 0.88)
        label.font = UIFont.systemFont(ofSize: 14)
        dividerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: dividerView.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: dividerView.centerXAnchor).isActive = true
        
        let separator1 = UIView()
        separator1.backgroundColor = UIColor(white: 1, alpha: 0.88)
        dividerView.addSubview(separator1)
        separator1.anchor(top: nil, left: dividerView.leftAnchor, bottom: nil, right: label.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 1.0)
        separator1.centerYAnchor.constraint(equalTo: dividerView.centerYAnchor).isActive = true
        
        let separator2 = UIView()
        separator2.backgroundColor = UIColor(white: 1, alpha: 0.88)
        dividerView.addSubview(separator2)
        separator2.anchor(top: nil, left: label.rightAnchor, bottom: nil, right: dividerView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 1.0)
        separator2.centerYAnchor.constraint(equalTo: dividerView.centerYAnchor).isActive = true
        
        return dividerView
    }()
    
    let googleLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints=false
        button.setImage(#imageLiteral(resourceName: "Google+"), for: .normal)
        button.tintColor = .white
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleGoogleSignIn), for: .touchUpInside)
        return button
    }()
    lazy var signInWithFacebookButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints=false
        button.setImage(#imageLiteral(resourceName: "Facebook"), for: .normal)
        button.tintColor = .white
        
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleSignInWithFacebookButtonTapped), for: .touchUpInside)
        return button
    }()
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        self.usernameTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSignUp()
        return true
    }
    
    // MARK: - Selectors
    
    @objc func handleGoogleSignIn() {
        GIDSignIn.sharedInstance()?.signIn()
    }
    @objc func handleSignInWithFacebookButtonTapped() {
        hud.textLabel.text = "Signing in with Facebook..."
        hud.show(in: view)
        Spark.signInWithFacebook(in: self) { (message, err, sparkUser) in
            if let err = err {
                SparkService.dismissHud(self.hud, text: "Error", detailText: "\(message) \(err.localizedDescription)", delay: 1)
                return
            }
            guard let sparkUser = sparkUser else {
                SparkService.dismissHud(self.hud, text: "Error", detailText: "Failed to fetch user", delay: 1)
                return
            }
            
            print("Successfully signed in with Facebook with Spark User: \(sparkUser)")
            SparkService.dismissHud(self.hud, text: "Success", detailText: "Successfully signed in with Facebook", delay: 1)
            let when = DispatchTime.now()+0.5
            
            let mainViewVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbFriendlistID") as! FriendlistViewController
            self.addChild(mainViewVC)
            mainViewVC.view.frame = self.view.frame
            self.view.addSubview(mainViewVC.view)
            mainViewVC.didMove(toParent: self)
            
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                self.dismiss(animated: true, completion: nil)
            })
        }
        
    }
    @objc func handleSignUp() {
        print({"Hello"})
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let username = usernameTextField.text else { return }
        
        createUser(withEmail: email, password: password, username: username)
    }
    
    @objc func handleShowLogin() {
        self.view.removeFromSuperview()
    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        // Local variable inserted by Swift 4.2 migrator.
//        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
//        
//        
//        var selectedImageFromPicker: UIImage?
//        
//        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
//            selectedImageFromPicker = editedImage
//        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
//            
//            selectedImageFromPicker = originalImage
//        }
//        
//        if let selectedImage = selectedImageFromPicker {
////            .image = selectedImage
//        }
//        
//        dismiss(animated: true, completion: nil)
//        
//    }
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        print("canceled picker")
//        dismiss(animated: true, completion: nil)
//    }
//    
//
//
//// Helper function inserted by Swift 4.2 migrator.
//fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
//    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
//}

    // MARK: - API
    
    func createUser(withEmail email: String, password: String, username: String) {
        weak var signin = (self.parent as! LoginViewController)
        hud.textLabel.text = "Creatting User..."
        hud.show(in: view)
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                print("Failed to sign user up with error: ", error.localizedDescription)
                   SparkService.dismissHud(self.hud, text: "Error", detailText: error.localizedDescription, delay: 1)
                return
            }else{
                let defaultProfileImageUrl = "https://firebasestorage.googleapis.com/v0/b/route-caster.appspot.com/o/profileImages%2Fuser.png?alt=media&token=7308908a-b378-48a0-ba38-bfca51a0f268"
                guard let uid = result?.user.uid else { return }
                let userDatas = ["uid":uid,"email": email, "name": username, "profileImageUrl": defaultProfileImageUrl]
                Firestore.firestore().collection("users").document(uid).setData(userDatas)
                signin?.logUserIn(withEmail: email, password: password)
                
            }}}
    
    // MARK: - Helper Functions
    
    func configureViewComponents() {
//        view.backgroundColor = UIColor.mainBlue()
        navigationController?.navigationBar.isHidden = true
        view.addSubview(imgbackground)
        imgbackground.width(view.frame.width)
        imgbackground.height(view.frame.height)
        view.addSubview(logoImageView)
        logoImageView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 60, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(emailContainerView)
        emailContainerView.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(usernameContainerView)
        usernameContainerView.anchor(top: emailContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(passwordContainerView)
        passwordContainerView.anchor(top: usernameContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(loginButton)
        loginButton.anchor(top: passwordContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(dividerView)
        dividerView.anchor(top: loginButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(googleLoginButton)
//        googleLoginButton.anchor(top: dividerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        googleLoginButton.centerInSuperview(offset: CGPoint(x: -view.frame.width*0.15 , y: view.frame.height*0.3),     usingSafeArea: true)
        googleLoginButton.width(view.frame.width*0.2)
        googleLoginButton.height(view.frame.width*0.2)
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 32, paddingBottom: 12, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(signInWithFacebookButton)
        signInWithFacebookButton.centerInSuperview(offset: CGPoint(x: view.frame.width*0.15 , y: view.frame.height*0.3),     usingSafeArea: true)
        signInWithFacebookButton.width(view.frame.width*0.2)
        signInWithFacebookButton.height(view.frame.width*0.2)

    }
}

extension SignUpViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        hud.textLabel.text = "Signing in with Google..."
        hud.show(in: view)
        if let error = error {
            print("Failed to sign in with error:", error)
               SparkService.dismissHud(self.hud, text: "Error", detailText: error.localizedDescription, delay: 1)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (result, error) in
            
            if let error = error {
                print("Failed to sign in and retrieve data with error:", error)
                return
            }
            let accountType = "gg"
            guard let uid = result?.user.uid else { return }
            guard let email = result?.user.email else { return }
            guard let username = result?.user.displayName else { return }
            let defaultProfileImageUrl = "https://firebasestorage.googleapis.com/v0/b/route-caster.appspot.com/o/profileImages%2Fuser.png?alt=media&token=7308908a-b378-48a0-ba38-bfca51a0f268"
            let values = ["email": email, "username": username,"uid": uid, accountType:"gg", "profileImageUrl": defaultProfileImageUrl]
            Firestore.firestore().collection("users").document(uid).setData(values)
            //
            
            for view in self.view.subviews {
                view.removeFromSuperview()
            }
            
            let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbMessageID") as! MessagesController
            self.present(secondVC, animated: false, completion: nil)
            
            //            let secondVC = UIStoryboard(name: "OnBoarding", bundle: nil).instantiateViewController(withIdentifier: "sbSecondViewID") as! SecondViewController
            //            self.addChild(secondVC)
            //            secondVC.view.frame = self.view.frame
            //            self.view.addSubview(secondVC.view)
            //            secondVC.didMove(toParent: self)
            
        }
    }
}

