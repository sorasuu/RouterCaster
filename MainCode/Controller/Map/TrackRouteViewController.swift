//
//  TrackRouteViewController.swift
//  UITest
//
//  Created by tang quang an on 4/29/19.
//  Copyright © 2019 tang quang an. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire
import Firebase
class TrackRouteViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    var camera = GMSCameraPosition()
    var startMarker: GMSMarker = GMSMarker()
    var endMarker: GMSMarker = GMSMarker()
    var polyline = GMSPolyline()
    var endPosition: CLLocation?
    var startDate:NSDate?
    var endDate: NSDate?
    var timeTravelled: TimeInterval?
    var shareList:[String] = []
    var routeIdToFirestore = String()
    @IBOutlet weak var myMapView: GMSMapView!
    @IBOutlet weak var destinationLb: UILabel!
    @IBOutlet weak var destionationInfo: UIView!
    @IBOutlet weak var destionationLb: UILabel!
    @IBOutlet weak var cancelRouteBtn: UIButton!
    @IBOutlet weak var myLocation: UIButton!
    
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        for (index,gesture) in myMapView.gestureRecognizers!.enumerated() {
            if index == 0 {
                myMapView.removeGestureRecognizer(gesture)
            }
        }
        
        // Setup view
        self.myMapView.addSubview(destionationInfo)
        destionationLb.text = endMarker.title
        myMapView.delegate = self
        myMapView.camera = self.camera
        
        myMapView.isMyLocationEnabled = true
        myMapView.addSubview(cancelRouteBtn)
        myMapView.addSubview(myLocation)
        endPosition = CLLocation(latitude: endMarker.position.latitude, longitude: endMarker.position.longitude)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        enableBasicLocationServices()
    }
    
    func enableBasicLocationServices() {
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request when-in-use authorization initially
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted, .denied:
            // Disable location features
            print("Disabled Authorization........................")
            let alert = UIAlertController(title: "Need Authorization", message: "This app is unusable if you don't authorize this app to use your location!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                let url = URL(string: UIApplication.openSettingsURLString)!
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            
            break
        case .authorizedWhenInUse, .authorizedAlways:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        enableBasicLocationServices()
    }
    
    @IBAction func didCancelRoute(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Do you want to quit this route", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Quit", style: .destructive, handler: { (action) in
            self.locationManager.delegate = nil
            if(self.routeIdToFirestore != ""){ Firestore.firestore().collection("route").document(self.routeIdToFirestore).setData(["status": false], merge: true) }
            Firestore.firestore().collection("shareroute").whereField("routeId", isEqualTo: self.updateId).getDocuments(){
                (querysnapshot, err) in if (err != nil){
                    print("error :",err)
                }else{
                    for document in querysnapshot!.documents{
                        let shareRoute = document.documentID
                        Firestore.firestore().collection("shareroute").document(shareRoute).setData(["status":false], merge: true)
                    }
                }
            }
            self.dismiss(animated: true, completion: nil)
           
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while getting location \(error)")
    }
    
    
    
    var firstLoad = true
    let myPath = GMSMutablePath()
    let myPolyline = GMSPolyline()
    var isTracking = true
    var outOfRoute = 0
    var isFirstRoute: Bool = true
     var updateId = String()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentUserId = Auth.auth().currentUser?.uid
        
        let route = Route()
        if (firstLoad) {
            drawPath(startLocation: manager.location!, endLocation: CLLocation(latitude: endMarker.position.latitude, longitude: endMarker.position.longitude)) {
                (result) in
                if (!result) {
                    let alert = UIAlertController(title: "No available route", message: "Please re-define your route", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                        self.locationManager.delegate = nil
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true)
                }
            
            }
            startMarker.position = manager.location!.coordinate
            startDate = NSDate()
            firstLoad = false
        
            // Create route to firebase here
            
//            route.userId = currentUserId
//            route.gms = self.polyline.path?.encodedPath()
//            route.status = "true"
//            let routeValues = ["userId": route.userId,"gms":route.gms, "status": route.status]
//            Firestore.firestore().collection("route").addDocument(data: routeValues as [String : Any])
            
        } else if let location = locations.last, let path = self.polyline.path {
           
            if (isFirstRoute) {
                route.userId = currentUserId
                route.gms = self.polyline.path?.encodedPath()
                route.status = true
                let routeValues = ["userId": route.userId,"gms":route.gms, "status": route.status] as [String : Any]
                let ref = Firestore.firestore().collection("route").addDocument(data: routeValues as [String : Any])
                updateId = ref.documentID
                Firestore.firestore().collection("route").document(self.updateId).setData(["routeId": self.updateId], merge: true)
                for shareRouteUser in shareList {
                    Firestore.firestore().collection("shareroute").addDocument(data: ["routeId":updateId,"userId":currentUserId as Any,"sharedUserId":shareRouteUser,"status":true])
                }
                print(updateId)
                routeIdToFirestore = updateId
                isFirstRoute = false
            }
            
            // Check if CLLocation is in the route
            if (GMSGeometryIsLocationOnPathTolerance(location.coordinate, path, true, CLLocationDistance(exactly: 30)!)) {
                print("You are on the route")
                
                myPath.add(location.coordinate)
                
                } else {
//                polyline.map = nil  // Delete the old one
                // May put this into function
                
                let alert = UIAlertController(title: "You are out of route", message: "Calculating new route", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                    
                    self.drawPath(startLocation: manager.location!, endLocation: CLLocation(latitude: self.endMarker.position.latitude, longitude: self.endMarker.position.longitude)) {
                        (result) in
                        if (!result) {
                            let alert = UIAlertController(title: "No available route", message: "Please re-define your route", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                                self.locationManager.delegate = nil
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true)
                        }
                    }
                    let updateRoute = Route()
       
                    updateRoute.gms = self.polyline.path?.encodedPath()
                    let updateRouteValues = ["gms":updateRoute.gms]
                    print("updateroute",updateRoute.gms as Any)
                    print("update: ",self.updateId)
                    Firestore.firestore().collection("route").document(self.updateId).setData(updateRouteValues as [String : Any], merge: true)

//                    self.myPolyline.path = self.myPath
//                    self.myPolyline.map = self.myMapView
//                    self.myPolyline.strokeWidth = 4
//                    self.myPolyline.strokeColor = UIColor.red
                }))
                
                self.present(alert, animated: true)
                
            }
            
            
            // When stay close to the destination
            if ((locations.last?.distance(from: endPosition!).isLess(than: 10))!) {
                
                manager.delegate = nil
                
                endDate = NSDate()
//                print("Print end date")
                print("Print date")
                
//                let dateFormatter = ISO8601DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//                let date = dateFormatter.date(from:"2019-05-15 06:02:35 +0000")!
                
//                print(date)
                print("\(String(describing: endDate))")
                timeTravelled = endDate!.timeIntervalSince(startDate! as Date)
                
                let distance = Double((GMSGeometryLength(myPath)) / 1000).roundToDecimal(2)
                let endValue = ["status" : false, "endDate": endDate as Any,"distance": distance, "timeTravelled" : timeTravelled] as [String : Any]
                Firestore.firestore().collection("route").document(self.updateId).setData(endValue, merge: true)
                Firestore.firestore().collection("shareroute").whereField("routeId", isEqualTo: self.updateId).getDocuments(){
                    (querysnapshot, err) in if (err != nil){
                        print("error :",err)
                    }else{
                        for document in querysnapshot!.documents{
                           let shareRoute = document.documentID
                            Firestore.firestore().collection("shareroute").document(shareRoute).setData(["status":false], merge: true)
                        }
                    }
                }
                let popOverVC = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "sbFinishRouteID") as! FinishRouteViewController
                
                popOverVC.startMarker = (self.startMarker.copy() as! GMSMarker)
                popOverVC.endMarker = (self.endMarker.copy() as! GMSMarker)
                popOverVC.endMarker?.map = nil
                popOverVC.timeTravelled = self.timeTravelled
                //            popOverVC.myPath = self.myPath
                popOverVC.myPath = path  // Testing  // Can remove
                popOverVC.myPolyline = self.polyline
                
                self.addChild(popOverVC)
                popOverVC.view.frame = self.view.frame
                self.view.addSubview(popOverVC.view)
                popOverVC.didMove(toParent: self)
            }
        }
        
        if (isTracking) {
            let lat = (manager.location!.coordinate.latitude)
            let long = (manager.location!.coordinate.longitude)
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17)
            self.myMapView.animate(to: camera)
        }
    }

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if (gesture) {
            isTracking = false
            myLocation.isHidden = false
        }
    }
    
    @IBAction func didTapMyLocation(_ sender: UIButton) {
        enableBasicLocationServices()
        if let location = locationManager.location {
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: self.myMapView.camera.zoom)
            self.myMapView.animate(to: camera)
            isTracking = true
            myLocation.isHidden = true
        }
    }
    
    
    func drawPath(startLocation: CLLocation, endLocation: CLLocation, completion:@escaping (Bool) -> ())
    {
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyCMYfiszedRS_hcUjJUyRCx9QPsaR2zUPQ"
        
        Alamofire.request(url).responseJSON { (response) in
            
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result as Any)   // result of response serialization
            
            do {
                let json = try JSON(data: response.data!)
                let routes = json["routes"].arrayValue
                
                // print route using Polyline
                
                
//                    print(route)
                if (routes.count == 0) {
                    completion(false)
                } else {
                    let routeOverviewPolyline = routes[0]["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    //                let polyline = GMSPolyline.init(path: path)
                    
    //                    var entirePath = GMSMutablePath()
    //                    for i in 0..<self.myPath.count() {
    //                        entirePath.add(self.myPath.coordinate(at: i))
    //                    }
    //                    for i in 0..<path!.count() {
    //                        entirePath.add(path!.coordinate(at: i))
    //                    }

                    
                    self.polyline.path = path
                    self.polyline.strokeWidth = 4
                    self.polyline.strokeColor = UIColor(red:0.25, green:0.43, blue:0.57, alpha:1.0)
                    self.polyline.map = self.myMapView
                    
                    let bounds = GMSCoordinateBounds(path: path!)
                    self.myMapView.moveCamera(GMSCameraUpdate.fit(bounds))
                    completion(true)
                }
            } catch {}
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
