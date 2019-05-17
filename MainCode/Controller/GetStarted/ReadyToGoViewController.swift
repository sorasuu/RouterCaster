//
//  ReadyToGoViewController.swift
//  getStarted3
//
//  Created by Nghia on 5/11/19.
//  Copyright © 2019 Nghia. All rights reserved.
//

import UIKit

class ReadyToGoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
    }
    
    let logo: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "RTG"))
        //this enables autolayout for the imageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private func setupBackground() {
        view.addSubview(logo)
        
        logo.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        logo.widthAnchor.constraint(equalToConstant: 200)
        logo.heightAnchor.constraint(equalToConstant: 175)
        
        
        
        if (self.view.frame.width == 375 && self.view.frame.height == 667) {
            NSLayoutConstraint.activate([
                
                ])
        } else if (self.view.frame.width == 414 && self.view.frame.height == 896) {
            
            NSLayoutConstraint.activate([
                logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 221),
                
                logo.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 107)
                
                ])
        }
    }
    
    
    
}
