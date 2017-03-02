//
//  MapViewController.swift
//  GiveMeFive
//
//  Created by Marco D'Agostino on 02/03/2017
//

import UIKit
import MapKit
import CoreLocation
import NetworkExtension
import SystemConfiguration.CaptiveNetwork

struct RealDevice {
    
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
}

class MapViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet weak var coordinates: UILabel!
    @IBOutlet weak var wifidata: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    
    let locationManager = CLLocationManager()
    var myLocation:CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        map.delegate = self
        map.mapType = .standard
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        
        if let coor = map.userLocation.location?.coordinate{
            map.setCenter(coor, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        map.showsUserLocation = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        map.showsUserLocation = false
    }
    
    var wifiname = String ()
    var apMACid = String ()
    
    
    // Verifico se app gira su simulatore o su device
    
    func CaptureWifiData () {
        
        if RealDevice.isSimulator {
            print ("Running on Simulator")
        } else {
            
            let interfaces:CFArray! = CNCopySupportedInterfaces()
            for i in 0..<CFArrayGetCount(interfaces){
                let interfaceName: UnsafeRawPointer
                    =  CFArrayGetValueAtIndex(interfaces, i)
                let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
                if unsafeInterfaceData != nil {
                    let interfaceData = unsafeInterfaceData! as NSDictionary!
                    wifiname = interfaceData?["SSID"] as! String
                    apMACid = interfaceData?["BSSID"] as! String
                    
                } else {
                    wifiname = "WiFi"
                    apMACid = "Not Available"
                }
            }
        }
    }
    
    func saveCurrentLocation(_ center:CLLocationCoordinate2D){
        let message = "\(center.latitude) , \(center.longitude)"
        self.coordinates.text = message
        self.wifidata.text = wifiname + " - " + apMACid
        myLocation = center
    }
    
    func centerMap(_ center:CLLocationCoordinate2D){
        self.saveCurrentLocation(center)
        
        let spanX = 0.007
        let spanY = 0.007
        
        let newRegion = MKCoordinateRegion(center:center , span: MKCoordinateSpanMake(spanX, spanY))
        map.setRegion(newRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        centerMap(locValue)
    }
    
}
