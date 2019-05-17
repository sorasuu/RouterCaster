//
//  PlaceSelectViewController.swift
//  UITest
//
//  Created by tang quang an on 4/20/19.
//  Copyright © 2019 tang quang an. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol PlaceSelectViewControllerDelegate {
    func changedPlace(newPlaceMarker: GMSMarker, isEditingStartPoint: Bool);
}

class PlaceSelectViewController: UIViewController, GMSMapViewDelegate, GMSAutocompleteTableDataSourceDelegate, CLLocationManagerDelegate, UITextFieldDelegate {

    var camera: GMSCameraPosition = GMSCameraPosition()
    var delegate: PlaceSelectViewControllerDelegate?
    @IBOutlet weak var myMapView: GMSMapView!
    @IBOutlet weak var searchBar: DesignableView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var yourLocationBtn: UIButton!
    
    
    let tableDataSource = GMSAutocompleteTableDataSource()
    var currentMarker: GMSMarker = GMSMarker()
    var isEditingStartPoint = true
    
    @IBAction func didPressBack(_ sender: UIButton) {
        txtField.resignFirstResponder()
        self.dismiss(animated: true) {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // View setup
        // Remove unneccasry gestures (for textfield to work)
        self.myMapView.addSubview(searchBar)
        self.myMapView.addSubview(tableView)
        for (index,gesture) in myMapView.gestureRecognizers!.enumerated() {
            if index == 0 {
                myMapView.removeGestureRecognizer(gesture)
            }
        }
        myMapView.camera = self.camera
        
        // TxtField set up
        txtField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        txtField.delegate = self
        
        if (!isEditingStartPoint) {
            yourLocationBtn.heightAnchor.constraint(equalToConstant: 0).isActive = true
        } else {
            self.myMapView.addSubview(yourLocationBtn)
        }
        
        if currentMarker.title == "Your location" {
            txtField.text = ""
        } else {
            txtField.text = currentMarker.title
        }
    
        tableDataSource.delegate = self
        
//        tableView.addSubview(subView)
//
//        insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        
        tableView.delegate = tableDataSource
        tableView.dataSource = tableDataSource
        tableDataSource.tableCellBackgroundColor = UIColor.white
        tableDataSource.tableCellSeparatorColor = UIColor(red:0.32, green:0.67, blue:0.69, alpha:1.0)
        tableDataSource.primaryTextColor = UIColor(red:0.25, green:0.43, blue:0.57, alpha:1.0)
        tableDataSource.secondaryTextColor = UIColor(red:0.25, green:0.43, blue:0.57, alpha:1.0)
        
        
        tableView.reloadData()
        
        txtField.becomeFirstResponder()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        txtField.becomeFirstResponder()
//    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        tableDataSource.sourceTextHasChanged(textField.text!)
        
//            tableView.beginUpdates()
//
//            tableView.endUpdates()

//
        
        if (textField.text?.count == 0) {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldDidChange(textField)
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
        
        let lat = place.coordinate.latitude
        let long = place.coordinate.longitude
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.title = place.name ?? ""
        marker.snippet = "\(place.formattedAddress!)"
        
        
        delegate?.changedPlace(newPlaceMarker: marker, isEditingStartPoint: isEditingStartPoint)
        
        self.dismiss(animated: true) {
        }
        
    }
    
    @IBAction func didSelectCurLocation(_ sender: UIButton) {
        let marker = GMSMarker()
        marker.title = "Your location"
        marker.map = nil
        
        txtField.resignFirstResponder()
        delegate?.changedPlace(newPlaceMarker: marker, isEditingStartPoint: isEditingStartPoint)
        self.dismiss(animated: true) {
        }
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
        
    }
    
    func didRequestAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        tableView.reloadData()
    }
    
    func didUpdateAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        tableView.reloadData()
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
