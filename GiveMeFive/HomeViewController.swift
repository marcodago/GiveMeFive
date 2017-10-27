//
//  HomeViewController.swift
//  GiveMeFive 1.4.0
//
//  Created by Marco D'Agostino on 02/03/2017
//

import UIKit
import MapKit
import Foundation
import CoreLocation
import UserNotifications
import NetworkExtension
import SystemConfiguration.CaptiveNetwork

struct Platform {
    
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
}

class HomeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate, NSURLConnectionDelegate {
    
    var infraOK: Bool = true
    var esito: Bool = false
    
    // Check infrastructure availability
    @IBOutlet weak var availableBmix: UILabel!
    
    @IBOutlet weak var role: UILabel!
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var DNDlabel: UILabel!
    
    @IBOutlet weak var need_help: UIButton!
    @IBAction func need_help_click(_ sender: UIButton) {
        
        //Inizializzo i parametri di indirizzo e tipologia del POST
        let servizio = "https://Gm5.mybluemix.net/client2usercall"
        let tipo = "usercall_form_UI"
        
        let payload = "&ruoli=\(nome.text!.lowercased())&actionrequired=\("cerca tutor")"
        let esito = SupportingFunctions.insertRecords(tipo , payload: payload , servizio: servizio)
        
        if esito == true {
            let alertController = UIAlertController(title: "DATA SENT", message: "Your request has been xmitted", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                print("you have pressed OK button");
            }
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
        }
    }
    var answer: String = ""
    // dichiaro variabile per la verifica della posizione dello switch
    var switchState: Bool = false
    
    //Inizializzo i parametri di indirizzo e tipologia del POST
    let servizio = "https://Gm5.mybluemix.net/client2userstatus"
    let tipo = "userstatus_form_UI"
    
    @IBOutlet var donotdisturb: UISwitch!
    @IBAction func donotdisturbOnOff(_ sender: AnyObject) {
        
        if donotdisturb.isOn {
            switchState = true
            answer = "unavailable"
            let payload = "&forcestatus=\(answer)"
            let esito = SupportingFunctions.insertRecords(tipo , payload: payload , servizio: servizio)
            
            if esito == true {
                let alertController = UIAlertController(title: "DATA SENT", message: "Your unavailability has been registered", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    print("you have pressed OK button");
                }
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true, completion:nil)
            }
            print("Il Do Not Disturb è impostato")
        } else {
            switchState = false
            answer = "available"
            let payload = "&forcestatus=\(answer)"
            let esito = SupportingFunctions.insertRecords(tipo , payload: payload , servizio: servizio)
            
            if esito == true {
                let alertController = UIAlertController(title: "DATA SENT", message: "Your availability has been registered", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    print("you have pressed OK button");
                }
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true, completion:nil)
            }
            
            print("Il Do Not Disturb non è più impostato")
        }
    }
    
    func invokeinsertRecords() {
        
        //Inizializzo i parametri di indirizzo e tipologia del POST
        let servizio = "https://Gm5.mybluemix.net/client2geolocalit"
        let tipo = "map_form_UI"
        
        // recupero le informazioni della rete wi-fi (SSID - BSSID)
        var wifiname: String = "N.D."
        var apMACid: String = "N.D."
        
        // Verifico se app gira su simulatore o su device
        if Platform.isSimulator {
            
            print("Running on Simulator")
            
        }
            
        else
            
        {
            
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
                    print(wifiname)
                    print(apMACid)
                } else {
                    wifiname = "N.D."
                    apMACid = "N.D."
                }
            }
        }
        
        let payload = "&longitude=\(myLocation.longitude)&latitude=\(myLocation.latitude)&ssidconn=\(wifiname)&apaddrconn=\(apMACid)"
        
        _ = SupportingFunctions.insertRecords(tipo , payload: payload , servizio: servizio)
        
    }
    
    
    let locationManager = CLLocationManager()
    var myLocation: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.alert, .sound]) { (granted, error) in }
            UIApplication.shared.registerForRemoteNotifications()
        }

        super.viewDidLoad()
      
      UIApplication.shared.applicationIconBadgeNumber = 0
      
        if infraOK == true {
            
            availableBmix.text = "Infrastruttura Bluemix operativa"
            availableBmix.textColor = UIColor(ciColor: .blue() )
            
        } else {
            
            availableBmix.text = "Infrastruttura Bluemix non disponibile"
            availableBmix.textColor = UIColor(ciColor: .red() )
 
        }

        
        nome.text = "Ciao " + String( describing: UserDefaults.standard.object(forKey: "googlename")! )
        
        if UserDefaults.standard.string(forKey: "storedrole") != nil {
            role.text = "sei registrato come " + String( UserDefaults.standard.string(forKey: "storedrole")!)
        } else {
            role.text = "registra il tuo ruolo"
        }
        
        
        self.navigationController?.navigationBar.isHidden = true
        
        // imposto un timer per inviare dati a BlueMix a cadenza fissa
        var timer = Timer()
        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(HomeViewController.invokeinsertRecords), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
        
        self.locationManager.requestAlwaysAuthorization()        // Ask for Authorisation from the User.
        self.locationManager.requestWhenInUseAuthorization()     // For use in foreground

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            let userlocation = MKUserLocation.self()
            myLocation = userlocation.coordinate
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        nome.text = "Ciao " + String( describing: UserDefaults.standard.object(forKey: "googlename")! )
        
        if UserDefaults.standard.string(forKey: "storedrole") != nil {
            role.text = "sei registrato come " + String( UserDefaults.standard.string(forKey: "storedrole")!)
        } else {
            role.text = "registra il tuo ruolo"
        }
                
    }
    
    func saveCurrentLocation(_ center:CLLocationCoordinate2D){
        myLocation = center
    }
    
    func centerMap(_ center:CLLocationCoordinate2D){
        self.saveCurrentLocation(center)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        centerMap(locValue)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
