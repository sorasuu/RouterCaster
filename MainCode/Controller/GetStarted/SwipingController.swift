//
//  SwipingController.swift
//  getStarted3
//
//  Created by Nghia on 4/26/19.
//  Copyright © 2019 Nghia. All rights reserved.
//

import UIKit

class SwipingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    
    let pagesInfo = [
        Page(imageName: "gsPage1", headerString: "Choose the RouteCaster", descriptionString: "A community for sharing your travelling experience to everyone"),
        Page(imageName: "gsPage2", headerString: "Navigate to Your Friend", descriptionString: "Get direction, and share your route with friends in real-time"),
        Page(imageName: "gsPage3", headerString: "Chat with Friends", descriptionString: "Get connected with your friends anywhere with the chatbox"),
        Page(imageName: "gsPage4", headerString: "Statistics for comparison", descriptionString: "Keep track of your weekly, monthly travelling information, and comparing it with friends"),
        Page(imageName: "gsPage5", headerString: "Make friend everywhere", descriptionString: "Easily add more friends to your contact over distance"),
        Page(imageName: "RTG", headerString: "", descriptionString: "Ready To Go")
    ]
    
    // SKIP Button
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SKIP", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 16)
        button.setTitleColor(.init(hexString: "3F6E91"), for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleSkip() {
        print("Move to the last page")
        
        let indexPath = IndexPath(item: 5, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        skipButton.setTitle("NEXT", for: .normal)
        pageControl.currentPage = 5
        
    
        let loginVC = UIStoryboard(name: "SignInSignUp", bundle: nil).instantiateViewController(withIdentifier: "sbLoginID") as! LoginViewController
        
        self.present(loginVC, animated: false, completion: {
            self.presentingViewController?.dismiss(animated: false, completion: {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window!.rootViewController!.present(loginVC, animated: false, completion: nil)
            })
        })
    }
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = pagesInfo.count
        pageControl.currentPageIndicatorTintColor = UIColor(hexString: "3F6E91")
        pageControl.pageIndicatorTintColor = .gray
        return pageControl
    }()
    
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let x = targetContentOffset.pointee.x
        
        pageControl.currentPage = Int(x / view.frame.width)
        
        if (pageControl.currentPage == 5) {
            skipButton.setTitle("NEXT", for: .normal)
        } else if (pageControl.currentPage < 5) {
            skipButton.setTitle("SKIP", for: .normal)
        }
    }
    
    fileprivate func setupButtonControls() {
        let bottomControlsStackView = UIStackView(arrangedSubviews: [pageControl, skipButton])
        view.addSubview(bottomControlsStackView)
        
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsStackView.distribution = .fillEqually
        bottomControlsStackView.axis = .vertical
        
        NSLayoutConstraint.activate([
            bottomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.alpha = 0
        self.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        
        showGetStartedVC()
        
        setupButtonControls()
        
        collectionView.backgroundColor = .white
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: "cellId")
        
        collectionView.isPagingEnabled = true
        

        
    }
    
    func showGetStartedVC() {
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = 1
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
}
