//
//  PageCell.swift
//  getStarted3
//
//  Created by Nghia on 4/26/19.
//  Copyright © 2019 Nghia. All rights reserved.
//

import UIKit

class PageCell: UICollectionViewCell {
    
    var page: Page? {
        didSet {
            guard let unwrappedPage = page else {return}
            //IMAGE OF EACH PAGE
            firstGSPage.image = UIImage(named: unwrappedPage.imageName)
            
            //HEADER OF EACH PAGE
            let attributedHeaderText = NSMutableAttributedString(string: unwrappedPage.headerString, attributes: [NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 27),   NSMutableAttributedString.Key.foregroundColor: UIColor(hexString: "3F6E91")])
            
            
            
            headerFirstPage.attributedText = attributedHeaderText
            headerFirstPage.textAlignment = .center
            
            //DESCRIPTION OF EACH PAGE
            let attributedDescriptionText = NSMutableAttributedString(string: "\n\(unwrappedPage.descriptionString)", attributes: [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 20), NSAttributedString.Key.foregroundColor: UIColor(hexString: "3F6E91")])
            descriptionFirstPage.attributedText = attributedDescriptionText
            descriptionFirstPage.textAlignment = .center
            
            
            
        }
    }
    
    private let firstGSPage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "gsPage1"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let headerFirstPage: UITextView = {
        let textView = UITextView()
        
        let attributedText = NSMutableAttributedString(string: "Choose the RouteCaster", attributes: [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 27),   NSMutableAttributedString.Key.foregroundColor: UIColor(hexString: "3F6E91")])
        
        
        textView.attributedText = attributedText
        
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let descriptionFirstPage: UITextView = {
        let textView = UITextView()
        
        let attributedText = NSMutableAttributedString(string: "A community for sharing your travelling experience to everyone", attributes: [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 20), NSAttributedString.Key.foregroundColor: UIColor(hexString: "3F6E91")])
        
        textView.attributedText = attributedText
        
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isSelectable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //backgroundColor = .yellow
        setupLayout()
        
        
    }
    
    private func setupLayout() {
        let topImageContainerView = UIView()
        addSubview(topImageContainerView)
        
        //enable autolayout
        topImageContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        topImageContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        topImageContainerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topImageContainerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topImageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        //topImageContainerView.backgroundColor = .blue
        
        topImageContainerView.addSubview(firstGSPage)
        
        
        addSubview(headerFirstPage)
        addSubview(descriptionFirstPage)
        
        
        
        firstGSPage.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor).isActive = true
        firstGSPage.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor).isActive = true
        
        firstGSPage.topAnchor.constraint(equalTo: topImageContainerView.topAnchor, constant: 100).isActive = true
        firstGSPage.leftAnchor.constraint(equalTo: topImageContainerView.leftAnchor, constant: 50).isActive = true
        firstGSPage.rightAnchor.constraint(equalTo: topImageContainerView.rightAnchor, constant: -50).isActive = true
        firstGSPage.bottomAnchor.constraint(equalTo: topImageContainerView.bottomAnchor, constant: 0).isActive = true
        
        headerFirstPage.topAnchor.constraint(equalTo: self.topAnchor, constant: 50).isActive = true
        headerFirstPage.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        headerFirstPage.rightAnchor.constraint(equalTo: rightAnchor,constant: -24).isActive = true
        //headerFirstPage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        descriptionFirstPage.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor).isActive = true
        descriptionFirstPage.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        descriptionFirstPage.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
        descriptionFirstPage.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
