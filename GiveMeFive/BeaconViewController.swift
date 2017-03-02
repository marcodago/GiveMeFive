//
//  BeaconViewController.swift
//  GiveMeFive
//
//  Created by Marco D'Agostino on 01/03/17.
//  Copyright © 2017 Marco D'Agostino. All rights reserved.
//

import UIKit
import CoreLocation

class BeaconViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!

    @IBOutlet weak var distanceReading: UILabel!

    func startScanning() {

        let uuid = UUID(uuidString: "13CDC31D-9234-468F-8829-3B63985B2411")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 17, minor: 72, identifier: "MyBeacon")
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
        locationManager!.startUpdatingLocation()
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
                self.view.backgroundColor = UIColor.lightGray
                self.distanceReading.text = "UNKNOWN"
                
            case .far:
                self.view.backgroundColor = UIColor.red
                self.distanceReading.text = "FAR"
                
            case .near:
                self.view.backgroundColor = UIColor.yellow
                self.distanceReading.text = "NEAR"
                
            case .immediate:
                self.view.backgroundColor = UIColor.green
                self.distanceReading.text = "RIGHT HERE"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        view.backgroundColor = UIColor.lightGray
        startScanning()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
