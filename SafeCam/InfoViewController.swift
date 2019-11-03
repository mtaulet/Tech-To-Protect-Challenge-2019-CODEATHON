//
//  InfoViewController.swift
//  SafeCam
//
//  Created by Jesús Aguas Acin on 03/11/2019.
//  Copyright © 2019 Jesus Aguas Acin. All rights reserved.
//

import Foundation
import UIKit
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG
import MapKit
import CoreLocation



class InfoViewController: UIViewController, CLLocationManagerDelegate {
    
    
    
    @IBOutlet weak var Titlename: UILabel!
    
    @IBOutlet weak var Photo: UIImageView!
    
    @IBOutlet weak var Date: UILabel!
    
    
    @IBOutlet weak var Location: UILabel!
    
    @IBOutlet weak var Device: UILabel!
    
    let locationManager = CLLocationManager()
    let location = CLLocationManager()
    var titlename = ""
    var date = ""
    var device = ""
    var image = UIImage()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()

            
        }
        
        Photo.image = image
        Titlename.text = titlename
        Date.text = date
        
        // Image to String
        let data = image.jpegData(compressionQuality: 1)
        let imageStr = (data?.base64EncodedString())!
        let MD5data = MD5(string: imageStr)
        let hash = (MD5data.base64EncodedString())
        print(hash)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        
        
        guard let location: CLLocation = manager.location else { return }
        fetchCityAndCountry(from: location) { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            print(city + ", " + country)
        }
            
            
            
            
        locationManager.stopUpdatingLocation()
    }
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
    func MD5(string: String) -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)

        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }
    


}
