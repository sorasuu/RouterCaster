//
//  LoginViewController.swift
//  MainCode
//
//  Created by Rmit on 4/24/19.
//  Copyright © 2019 SoraSuu. All rights reserved.
//

import UIKit
import TinyConstraints
import JGProgressHUD
//import TextFieldEffects
import Firebase
import GoogleSignIn
class LoginViewController: UIViewController, GIDSignInUIDelegate {
    let inputviewheight:CGFloat = 150
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
    //    let nameTextField: UITextField = {
    //        let tf = UITextField()
    //        tf.placeholder = "Name"
    //        tf.translatesAutoresizingMaskIntoConstraints = false
    //        return tf
    //    }()
    let emailTextField: UITextField = {
        let tf = UITextField()
        //        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
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
    let inputContainerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    lazy var  loginResisterButton: UIButton = {
        let button1 = UIButton(type: .system)
        button1.tintColor = .white
        button1.setImage(#imageLiteral(resourceName: "SignIn"), for: .normal)
        return button1
    }()
    lazy var emailContainerView : UIView = {
        let view = UIView()
        return view.textContainerView(view: view, #imageLiteral(resourceName: "Name"), emaillogTextField)
    }()
    
    lazy var passwordContainerView : UIView = {
        let view = UIView()
        return view.textContainerView(view: view, #imageLiteral(resourceName: "Password"), passwordlogTextField)
    }()
    
    lazy var emaillogTextField : UITextField = {
        let tf = UITextField()
        return tf.textField(withPlaceolder: "Email", isSecureTextEntry: false)
    }()
    
    lazy var passwordlogTextField : UITextField = {
        let tf = UITextField()
        return tf.textField(withPlaceolder: "Password", isSecureTextEntry: true)
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        //        button.setTitle("SignIn", for: .normal)
        //        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        //        button.setTitleColor(UIColor.mainBlue(), for: .normal)
        //        button.backgroundColor = .white
        //        button.tintColor = .white
        button.setImage(#imageLiteral(resourceName: "SignIn"), for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
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
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    
    
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
            let when = DispatchTime.now() + 3
            
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
            
//            DispatchQueue.main.asyncAfter(deadline: when, execute: {
//                self.dismiss(animated: true, completion: nil)
//            })
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        //        setupbackground()
        //        setupInputView()
        //        setuploginButton()
        //        setupFacebookButtonViews()
        //        setupusername()
        configureViewComponents()
        // Do any additional setup after loading the view.
        
        self.view.alpha = 0
        self.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        showLoginVC()
    }
    
    func showLoginVC() {
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    // MARK: - Selectors
    
    @objc func handleGoogleSignIn() {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        logUserIn(withEmail: email, password: password)
    }
    
    @objc func handleShowSignUp() {
        let signUpVC = UIStoryboard(name: "SignInSignUp", bundle: nil).instantiateViewController(withIdentifier: "sbSignUpID") as! SignUpViewController
        self.addChild(signUpVC)
        signUpVC.view.frame = self.view.frame
        self.view.addSubview(signUpVC.view)
        signUpVC.didMove(toParent: self)
    }
    
    // MARK: - API
    
    func logUserIn(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                print("Failed to sign user in with error: ", error.localizedDescription)
                return
            }else{
            
            for view in self.view.subviews {
                view.removeFromSuperview()
            }
            
            let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbMessageID") as! MessagesController
            self.present(secondVC, animated: false, completion: nil)
            
            //            guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
            //            guard let controller = navController.viewControllers[0] as? HomeController else { return }
            //            controller.configureViewComponents()
            
            // forgot to add this in video
            //            controller.loadUserData()
            
            self.dismiss(animated: true, completion: nil)
            
//            let secondVC = UIStoryboard(name: "OnBoarding", bundle: nil).instantiateViewController(withIdentifier: "sbSecondViewID") as! SecondViewController
//            self.addChild(secondVC)
//            secondVC.view.frame = self.view.frame
//            self.view.addSubview(secondVC.view)
//            secondVC.didMove(toParent: self)
//            //            guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
//            //            guard let controller = navController.viewControllers[0] as? HomeController else { return }
//            //            controller.configureViewComponents()
//
//            // forgot to add this in video
//            //            controller.loadUserData()
//
//            self.dismiss(animated: true, completion: nil)
        }
        }}
    
    // MARK: - Helper Functions
    //constraint
    func configureViewComponents() {
        navigationController?.navigationBar.isHidden = true
        view.addSubview(imgbackground)
        imgbackground.width(view.frame.width)
        imgbackground.height(view.frame.height)
        view.addSubview(logoImageView)
        logoImageView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 60, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(emailContainerView)
        emailContainerView.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(passwordContainerView)
        passwordContainerView.anchor(top: emailContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
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
        
        //        view.addSubview(loginResisterButton)
        //        loginResisterButton.centerInSuperview(offset: CGPoint(x:0 , y: view.frame.height*0.2),     usingSafeArea: true)
        //        loginResisterButton.width(view.frame.width * 0.4)
        //        loginResisterButton.height(view.frame.height * 0.1)
        
        
        //        view.addSubview(inputContainerView)
        //        inputContainerView.centerInSuperview(usingSafeArea: true)
        //        inputContainerView.width(view.frame.width*0.8)
        //        inputContainerView.height(150)
        
    }
    //    fileprivate func setupusername(){
    //        view.addSubview(emailTextField)
    //        emailTextField.centerInSuperview()
    //        emailTextField.width(view.frame.width*0.6)
    //        emailTextField.height(view.frame.width*0.1)
    //        let emailtexteffect = HoshiTextField(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
    //        emailTextField.centerInSuperview()
    //        emailTextField.placeholder = "Email"
    //        emailtexteffect.placeholderColor = .darkGray
    //
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



extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print("Failed to sign in with error:", error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (result, error) in
            
            if let error = error {
                print("Failed to sign in and retrieve data with error:", error)
                return
            }
            
            guard let uid = result?.user.uid else { return }
            guard let email = result?.user.email else { return }
            guard let username = result?.user.displayName else { return }
            
            let values = ["email": email, "username": username,"uid": uid]
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

