//
//  MapViewController.swift
//  GiveMeFive
//
//  Created by Marco D'Agostino on 02/03/2017
//

import UIKit
import MapKit
import Foundation
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

        CaptureWifiData()
        view.backgroundColor = UIColor.white
        startScanning()

        
        self.locationManager.requestAlwaysAuthorization()         // Ask for Authorisation from the User.
        self.locationManager.requestWhenInUseAuthorization()      // For use in foreground
        
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
        CaptureWifiData()
        startScanning()
        map.showsUserLocation = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        map.showsUserLocation = false
    }
    
    var wifiname = String ()
    var apMACid = String ()
    var esito = String ()
    var LBLwifidata = String ()
   
    @IBOutlet weak var distanceReading: UILabel!
    
    func startScanning() {
        
        let uuid = UUID(uuidString: "13CDC31D-9234-468F-8829-3B63985B2411")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 17, minor: 72, identifier: "MyBeacon")
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
        locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            let beacon = beacons[0]
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
    
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 0.8) { [unowned self] in
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.white
                self.distanceReading.text = "Too far from signal"
                
            case .far:
                self.view.backgroundColor = UIColor.red
                self.distanceReading.text = "Still far from signal"
                
            case .near:
                self.view.backgroundColor = UIColor.yellow
                self.distanceReading.text = "Near the signal"
                
            case .immediate:
                self.view.backgroundColor = UIColor.green
                self.distanceReading.text = "Close to signal"
            }
        }
    }
    
    
    func CaptureWifiData () {
        
        if RealDevice.isSimulator {    // Verifico se app gira su simulatore o su device
            
            print ("Running on Simulator")
            wifiname = "WiFi"
            apMACid = "Not Available"
            
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
        
        let x = center.latitude
        let y = center.longitude
        let xLat = Double(round(10000 * x) / 10000)
        let xLon = Double(round(10000 * y) / 10000)
        
        if wifiname == "IBM" {
            
            let esito = translateMACtoLocation(mac: apMACid)    // to be used to pass AP location
            LBLwifidata = "\(esito!)"
           
        } else {
            
            LBLwifidata = "\(wifiname) , \(apMACid)"      // to be used in passing SSID & MAC address (BSSID)
 
        }
        
        let lblcoordinates = "\(xLat) , \(xLon)"
        self.coordinates.text = lblcoordinates
        self.wifidata.text = LBLwifidata
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
    
    
    func translateMACtoLocation(mac: String) -> (String?) {
        
        do {
            if let file = Bundle.main.url(forResource: "gm5-ap-seg", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let jsonArray = try JSONSerialization.jsonObject(with: data, options: [])
                let object = jsonArray as? [String: Any]
                if let wifilocation = object?[apMACid] as? [String: AnyObject],
                    let value = wifilocation["APLocation"] as? String {
                    return value
                    
                } else {
                    
                    return nil
                }
                
            } else {
                
                return nil
            }
            
        } catch {
            
            return nil
        }
    }
}
