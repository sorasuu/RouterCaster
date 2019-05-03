//
//  PopUpViewController.swift
//  MainCode
//
//  Created by Apple on 4/23/19.
//  Copyright © 2019 Kien. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var requestTableView: UITableView!
    var position: Int = 0
    
    var data: [String] = ["Sara Nguyen", "Vie Tran", "LaLa Crops", "Phong Tran", "Laden Philip"]
    var images: [UIImage] = [UIImage(named: "SaraImage")!,
                             UIImage(named: "VieImage")!,
                             UIImage(named: "LalaImage")!,
                             UIImage(named: "PhongImage")!,
                             UIImage(named: "LadenImage")!]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellRequest", for: indexPath) as! CustomCellRequest
        cell.label.text = data[indexPath.row]
        cell.imageProfile.image = images[indexPath.row]
        cell.cellDelegate = self
        cell.index = indexPath
        return cell
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        self.view.backgroundColor = UIColor.init(displayP3Red: 0, green: 0, blue: 0, alpha: 0.1)
        
        self.showAnimate()
        // Do any additional setup after loading the view.
    }
    @IBAction func didClosePopUp(_ sender: Any) {
        self.removeAnimate()
    }
    @IBAction func didClosePopUpBottom(_ sender: Any) {
        self.removeAnimate()
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }) { completed in
            self.view.removeFromSuperview()
        }
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


extension PopUpViewController: TableViewRequest {
    func onClickDeny(index: Int) {
        data.remove(at: index)
        images.remove(at: index)
        requestTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        requestTableView.reloadData()
    }
    
    func onClickAccept(index: Int) {
        
        data.remove(at: index)
        images.remove(at: index)
        requestTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        requestTableView.reloadData()
    }
    
}
