//
//  ViewController.swift
//  getStarted3
//
//  Created by Nghia on 4/24/19.
//  Copyright © 2019 Nghia. All rights reserved.
//

import UIKit

class GetStartedViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.addSubview(firstGSPage)
        view.addSubview(headerFirstPage)
        
        setupLayout()
        
        setupButtonControls()
        
    }
    
    
    // {} is referred to as closure, or anon. functions
    let firstGSPage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "gsPage1"))
        //this enables autolayout for the imageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let descriptionFirstPage: UITextView = {
        let textView = UITextView()
        
        let attributedText = NSMutableAttributedString(string: "A community for sharing your travelling experience to everyone", attributes: [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 20), NSAttributedString.Key.foregroundColor: UIColor(hexString: "3F6E91")])
        
        textView.attributedText = attributedText
        
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isSelectable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let headerFirstPage: UITextView = {
        let textView = UITextView()
        
        let attributedText = NSMutableAttributedString(string: "Choose the RouteCaster", attributes: [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 27),   NSMutableAttributedString.Key.foregroundColor: UIColor(hexString: "3F6E91")])
        
        
        textView.attributedText = attributedText
        
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // SKIP Button
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SKIP", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 16)
        button.setTitleColor(.init(hexString: "3F6E91"), for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = 6
        pageControl.currentPageIndicatorTintColor = UIColor(hexString: "3F6E91")
        pageControl.pageIndicatorTintColor = .gray
        return pageControl
    }()
    
    fileprivate func setupButtonControls() {
        let bottomControlsStackView = UIStackView(arrangedSubviews: [pageControl, skipButton])
        
        view.addSubview(bottomControlsStackView)
        
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsStackView.distribution = .fillEqually
        bottomControlsStackView.axis = .vertical
        
        NSLayoutConstraint.activate([
            //skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bottomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    
    
    
    private func setupLayout() {
        let topImageContainerView = UIView()
        view.addSubview(topImageContainerView)
        
        //enable autolayout
        topImageContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        topImageContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        topImageContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topImageContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topImageContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // topImageContainerView.backgroundColor = .blue
        
        topImageContainerView.addSubview(firstGSPage)
        //topImageContainerView.addSubview(descriptionTextfirstGSPage)
        topImageContainerView.addSubview(descriptionFirstPage)
        
        firstGSPage.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor).isActive = true
        firstGSPage.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor).isActive = true
        
        firstGSPage.topAnchor.constraint(equalTo: topImageContainerView.topAnchor, constant: 100).isActive = true
        firstGSPage.leftAnchor.constraint(equalTo: topImageContainerView.leftAnchor, constant: 50).isActive = true
        firstGSPage.rightAnchor.constraint(equalTo: topImageContainerView.rightAnchor, constant: -50).isActive = true
        firstGSPage.bottomAnchor.constraint(equalTo: topImageContainerView.bottomAnchor, constant: 0).isActive = true
        
        headerFirstPage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        headerFirstPage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        headerFirstPage.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -24).isActive = true
        headerFirstPage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        descriptionFirstPage.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor).isActive = true
        descriptionFirstPage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        descriptionFirstPage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        descriptionFirstPage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
}

//To use hexcode
extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

