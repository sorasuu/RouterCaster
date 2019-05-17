//
//  FinishRouteViewController.swift
//  UITest
//
//  Created by tang quang an on 4/30/19.
//  Copyright © 2019 tang quang an. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FBSDKLoginKit
import FBSDKShareKit

class FinishRouteViewController: UIViewController, UIScrollViewDelegate, GMSMapViewDelegate {
//    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
////        var fbURL = URL(string: "fb://")
////        if let fbURL = fbURL {
////            if !UIApplication.shared.canOpenURL(fbURL) {
////                if (results["postId"] != nil) {
////                    print("Sweet, they shared, and Facebook isn't installed.")
////                } else {
////                    print("The post didn't complete, they probably switched back to the app")
////                }
////            }
////        } else {
////            print("Sweet, they shared, and Facebook is installed.")
////        }
//        print("The result is: \(results)")
//
//    }
//
//    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
//    }
//
//    func sharerDidCancel(_ sharer: Sharing) {
//    }
    
    
    @IBOutlet weak var routeImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var routeDistanceLb: UILabel!
    @IBOutlet weak var timeTravelledLb: UILabel!
    
    var myPath: GMSPath?
    var myPolyline: GMSPolyline = GMSPolyline()
    var startMarker: GMSMarker?
    var endMarker: GMSMarker?
    var timeTravelled: TimeInterval?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
        
//        // Rm
//        print("Changed mode..........................")
//        print(self.routeImage.bounds.size.width)
//        print(self.routeImage.bounds.size.height)
        
//        routeDistanceLb.text = "350"
//        timeTravelledLb.text = "00:00:36"
//
//        // OK version
//        var staticMapUrl: String = "https://maps.googleapis.com/maps/api/staticmap?size=\(Int(routeImage.bounds.width))x\(Int(routeImage.bounds.height))&markers=color:green|label:S|37.785836,-122.406417&markers=color:red|label:E|37.7886412,-122.407071&path=weight:4|color:0x3f6e91|enc:s`seFdnbjVZEAQAa@De@DQX_@vBqClA{AFKTNnAbBbDnExAtBrCxDlEbG_DfEoAnBOj@WTgBPq@JkEh@yDd@uKpAyC\\WsDs@qKG_Ba@eG&key=AIzaSyCMYfiszedRS_hcUjJUyRCx9QPsaR2zUPQ"
        
        
        
        let staticMapUrl: String = "https://maps.googleapis.com/maps/api/staticmap?size=\(Int(routeImage.bounds.width))x\(Int(routeImage.bounds.height))&markers=color:green|label:S|\(Double((startMarker?.position.latitude)!)),\(Double((startMarker?.position.longitude)!))&markers=color:read|label:E|\(Double((endMarker?.position.latitude)!)),\(Double((endMarker?.position.longitude)!))&path=weight:4|color:0x3f6e91|enc:\(self.myPath!.encodedPath())&key=AIzaSyCMYfiszedRS_hcUjJUyRCx9QPsaR2zUPQ"
        
        //        print(self.myPolyline.path?.encodedPath())
        //        print(routeImage.frame.width)
        
        let imageSession = URLSession(configuration: .ephemeral)
        if let url = NSURL(string: (staticMapUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed))!) {
            
            print("Yessssssssssss")
            let task = imageSession.dataTask(with: url as URL) { (imageData, _, _) in
                guard let imageData = imageData, let image = UIImage(data: imageData) else {return}
                
                DispatchQueue.main.async {
                    
                    let newImage = self.textToImage(drawText: "Route distance: \(self.routeDistanceLb.text!)\nTime Travelled: \(self.timeTravelledLb.text!)", inImage: image, atPoint: CGPoint(x: 0, y: 0))
                    
                    
                    self.routeImage.image = newImage
                    print(newImage)
                    //                routeImage.frame = CGRect(x: 0, y: 50, width: 200, height: 200)
                    //                    self.routeImage.contentMode = UIView.ContentMode.scaleAspectFit
                    //                    imageView.sizeToFit()
                }
            }
            task.resume()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        self.view.backgroundColor = UIColor.init(displayP3Red: 0, green: 0, blue: 0, alpha: 0.1)
        self.view.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.7)
//        routeImage.clipsToBounds = true
        
        // Display data
        routeDistanceLb.text = String((Double((GMSGeometryLength(myPath!)) / 1000) / (UserSetting.isMetric ? 1 : 1.609)).roundToDecimal(2))
        routeDistanceLb.text?.append(" \(UserSetting.isMetric ? "km" : "mi")")
        timeTravelledLb.text = timeTravelled!.stringFromTimeInterval()
        
//        // For on-barding
//        routeDistanceLb.text = "1.3 mi"
//        timeTravelledLb.text = "00:12:33"

//        // OK version
//        var staticMapUrl: String = "https://maps.googleapis.com/maps/api/staticmap?size=358x381&path=weight:3|color:red|enc:s`seFdnbjVZEAQAa@De@DQX_@vBqClA{AFKTNnAbBbDnExAtBqD~EiBbCe@l@IDKBMCoBR}@Ha@Lm@RgBPWwDk@cJ[{E&key=AIzaSyCMYfiszedRS_hcUjJUyRCx9QPsaR2zUPQ"
//
////        let staticMapUrl: String = "https://maps.googleapis.com/maps/api/staticmap?size=\(Int(routeImage.frame.width))x\(Int(routeImage.frame.height))&markers=color:green|label:S|\(Double((startMarker?.position.latitude)!)),\(Double((startMarker?.position.longitude)!))&markers=color:red|label:E|\(Double((endMarker?.position.latitude)!)),\(Double((endMarker?.position.longitude)!))&path=weight:3|color:red|enc:\(self.myPath!.encodedPath())&key=AIzaSyCMYfiszedRS_hcUjJUyRCx9QPsaR2zUPQ"
//
////        print(self.myPolyline.path?.encodedPath())
////        print(routeImage.frame.width)
//
//        let imageSession = URLSession(configuration: .ephemeral)
//        if let url = NSURL(string: (staticMapUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed))!) {
//
//            print("Yessssssssssss")
//            let task = imageSession.dataTask(with: url as URL) { (imageData, _, _) in
//                guard let imageData = imageData, let image = UIImage(data: imageData) else {return}
//
//                DispatchQueue.main.async {
//
//                    let newImage = self.textToImage(drawText: "Route distance: \(self.routeDistanceLb.text!)\nTime Travelled: \(self.timeTravelledLb.text!)", inImage: image, atPoint: CGPoint(x: 0, y: 0))
//
//
//                    self.routeImage.image = newImage
//    //                routeImage.frame = CGRect(x: 0, y: 50, width: 200, height: 200)
////                    self.routeImage.contentMode = UIView.ContentMode.scaleAspectFit
//                    //                    imageView.sizeToFit()
//                }
//            }
//            task.resume()
//        }
        
        self.showAnimate()
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        self.view.frame.origin.x += self.view.frame.size.width
//    }
    
    @IBAction func didCloseView(_ sender: Any) {
        
        weak var pvc = (self.parent as! TrackRouteViewController)
        self.dismiss(animated: true) {
            pvc?.dismiss(animated: true, completion: {
                
            })
        }
        
    }
    @IBAction func didPressShare(_ sender: Any) {
        var content = FBSDKShareLinkContent()
        content.contentURL = URL(string: "https://www.google.com")!
        
        let photo = FBSDKSharePhoto()
        photo.image = routeImage.image
        photo.isUserGenerated = true
        
        var dialog = FBSDKShareDialog()
        
        let newContent = FBSDKSharePhotoContent()
        
        //        newContent.contentURL =  URL(string: "https://www.google.com")
        //        newContent.contentURL = URL(string: "https://www.google.com")
        newContent.photos = [photo]
        dialog.fromViewController = self
        dialog.shareContent = newContent
        dialog.mode = .native
//        dialog.delegate = self
        dialog.show()
    }
    
    
    
    @IBAction func didSaveRoute(_ sender: Any) {
        print("Yes")
        scrollView.setContentOffset(CGPoint(x: 374, y: 0), animated: true)
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    
    @IBAction func didNotSaveRoute(_ sender: UIButton) {
        scrollView.setContentOffset(CGPoint(x: 374, y: 0), animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
//    func getRouteImage() {
//
//        let myMapView = GMSMapView()
//        myMapView.delegate = self
//
//        let myView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        myView.backgroundColor = .black
//        self.routeImage.image = myView.asImage()
//        self.routeImage.sizeToFit()
//    }
    
    func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        // New
        let textColor = UIColor.black
        let textFont = UIFont(name: "Avenir-Medium", size: 12)!
        let imageSize = image.size
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
        
        image.draw(at: CGPoint.zero)
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            ] as [NSAttributedString.Key : Any]
        
        let rectangle = CGRect(x: point.x, y: point.y, width: NSString(string: text).size(withAttributes: textFontAttributes).width, height: NSString(string: text).size(withAttributes: textFontAttributes).height)
        UIColor.white.setFill()
        UIRectFill(rectangle)
        
        text.draw(in: rectangle, withAttributes: textFontAttributes)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

}

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}

extension TimeInterval{
    
    func stringFromTimeInterval() -> String {
        
        let time = NSInteger(self)
        
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }
}

