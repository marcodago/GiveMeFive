//
//  SubscriptionViewController.swift
//  GiveMeFive 1.3.5
//
//  Created by Marco D'Agostino on 02/03/2017
//


import UIKit
import Foundation

class SubscriptionsViewController: UIViewController, UITextFieldDelegate, NSURLConnectionDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var esito: Bool = false
    
    // dichiaro array dei servizi disponibili alla sottoscrizione
    var services = [String] ()
    
    // dichiaro variabile per la verifica della posizione dello switch
    var switchState01: Bool = false
    var switchState02: Bool = false
    var switchState03: Bool = false
    var switchState04: Bool = false
    var switchState05: Bool = false
    var switchState06: Bool = false
    
    @IBOutlet var Role_Field: UITextField!
    
    func manageArray () {
        
        let array = services
        
        UserDefaults.standard.set(array, forKey : "services" )
        UserDefaults.standard.synchronize()
        
        if let services = UserDefaults.standard.array(forKey: "services") {
            print( "We saved this data: \( services )")
        }
    }
    
    @IBOutlet weak var sottoscrivi: UIButton!
    @IBAction func subscribe_clicked(_ sender: UIButton) {
        
        //Inizializzo i parametri di indirizzo e tipologia del POST
        let servizio = "https://Gm5.mybluemix.net/client2subscription"
        let tipo = "subscription_form_UI"
        
        manageArray()
        UserDefaults.standard.set(services, forKey: "services")
        UserDefaults.standard.synchronize()
        print("Switches values have been saved")
        print("I servizi sottoscritti sono: \(services)")
        
        let payload = "&role=\(Role_Field.text!)&actionrequired=\(services)"
        let esito = SupportingFunctions.insertRecords(tipo , payload: payload , servizio: servizio)
        
        if esito == true {
            let alertController = UIAlertController(title: "DATA SENT", message: "Your subscriptions have been registered", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                print("you have pressed OK button");
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
        }
        
    }
    
    // routine per gestire aggiunta e rimozione dei servizi dall'array
    func arrayRemovingObject<U: Equatable>(_ object: U, fromArray:[U]) -> [U] {
        return fromArray.filter { return $0 != object }
    }
    
    // imposto variabili da UI per ogni singolo switch
    @IBOutlet var service01: UISwitch!
    @IBAction func service01OnOff(_ sender: AnyObject) {
        
        if service01.isOn {
            switchState01 = true
            UserDefaults.standard.set(switchState01, forKey: "switchState01")
            UserDefaults.standard.synchronize()
            print("SWITCH1:\(switchState01)")
            services.append("accompagnamento")
            print("Hai sottoscritto i seguenti servizi:\(services)")
        } else {
            switchState01 = false
            UserDefaults.standard.set(switchState01, forKey: "switchState01")
            UserDefaults.standard.synchronize()
            print("SWITCH1:\(switchState01)")
            services = arrayRemovingObject("accompagnamento", fromArray:services)
            print("Hai de-sottoscritto i seguenti servizi:\(services)")
        }
    }
    
    @IBOutlet var service02: UISwitch!
    @IBAction func service02OnOff(_ sender: AnyObject) {
        if service02.isOn {
            switchState02 = true
            UserDefaults.standard.set(switchState02, forKey: "switchState02")
            UserDefaults.standard.synchronize()
            print("SWITCH2:\(switchState02)")
            services.append("servizi")
            print("Hai sottoscritto i seguenti servizi:\(services)")
        } else {
            switchState02 = false
            UserDefaults.standard.set(switchState02, forKey: "switchState02")
            UserDefaults.standard.synchronize()
            print("SWITCH2:\(switchState02)")
            services = arrayRemovingObject("servizi", fromArray:services)
            print("Hai de-sottoscritto i seguenti servizi:\(services)")
        }
    }
    
    @IBOutlet var service03: UISwitch!
    @IBAction func service03OnOff(_ sender: AnyObject) {
        if service03.isOn {
            switchState03 = true
            UserDefaults.standard.set(switchState03, forKey: "switchState03")
            UserDefaults.standard.synchronize()
            print("SWITCH3:\(switchState03)")
            services.append("mensa")
            print("Hai sottoscritto i seguenti servizi:\(services)")
        } else {
            switchState03 = false
            UserDefaults.standard.set(switchState03, forKey: "switchState03")
            UserDefaults.standard.synchronize()
            print("SWITCH3:\(switchState03)")
            services = arrayRemovingObject("mensa", fromArray:services)
            print("Hai de-sottoscritto i seguenti servizi:\(services)")
        }
    }
    
    @IBOutlet var service04: UISwitch!
    @IBAction func service04OnOff(_ sender: AnyObject) {
        if service04.isOn {
            switchState04 = true
            UserDefaults.standard.set(switchState04, forKey: "switchState04")
            UserDefaults.standard.synchronize()
            print("SWITCH4:\(switchState04)")
            services.append("bar")
            print("Hai sottoscritto i seguenti servizi:\(services)")
        } else {
            switchState04 = false
            UserDefaults.standard.set(switchState04, forKey: "switchState04")
            UserDefaults.standard.synchronize()
            print("SWITCH4:\(switchState04)")
            services = arrayRemovingObject("bar", fromArray:services)
            print("Hai de-sottoscritto i seguenti servizi:\(services)")
        }
    }
    
    @IBOutlet var service05: UISwitch!
    @IBAction func service05OnOff(_ sender: AnyObject) {
        if service05.isOn {
            switchState05 = true
            UserDefaults.standard.set(switchState05, forKey: "switchState05")
            UserDefaults.standard.synchronize()
            print("SWITCH5:\(switchState05)")
            services.append("emergenza")
            print("Hai sottoscritto i seguenti servizi:\(services)")
        } else {
            switchState05 = false
            UserDefaults.standard.set(switchState05, forKey: "switchState05")
            UserDefaults.standard.synchronize()
            print("SWITCH5:\(switchState05)")
            services = arrayRemovingObject("emergenza", fromArray:services)
            print("Hai de-sottoscritto i seguenti servizi:\(services)")
        }
    }
    
    @IBOutlet var service06: UISwitch!
    @IBAction func service06OnOff(_ sender: AnyObject) {
        if service06.isOn {
            switchState06 = true
            UserDefaults.standard.set(switchState06, forKey: "switchState06")
            UserDefaults.standard.synchronize()
            print("SWITCH6:\(switchState06)")
            services.append("cercamici")
            print("Hai sottoscritto i seguenti servizi:\(services)")
        } else {
            switchState06 = false
            UserDefaults.standard.set(switchState06, forKey: "switchState06")
            UserDefaults.standard.synchronize()
            print("SWITCH6:\(switchState06)")
            services = arrayRemovingObject("cercamici", fromArray:services)
            print("Hai de-sottoscritto i seguenti servizi:\(services)")
        }
    }
    
    // Ricarico da memoria i valori degli switches salvati in precedenza
    func switchPreloadValues () {
        
        if UserDefaults.standard.string(forKey: "switchState01") != nil {
            
            let switch01 = String(UserDefaults.standard.string(forKey: "switchState01")!)
            if switch01 == "1" {
                service01.setOn(true, animated: true)
                services.append("accompagnamento")
            } else {
                service01.setOn(false, animated: true)
                services = arrayRemovingObject("accompagnamento", fromArray:services)
                
            }
        }
        
        if UserDefaults.standard.string(forKey: "switchState02") != nil {
            
            let switch02 = String(UserDefaults.standard.string(forKey: "switchState02")!)
            if switch02 == "1" {
                service02.setOn(true, animated: true)
                services.append("servizi")
            } else {
                service02.setOn(false, animated: true)
                services = arrayRemovingObject("servizi", fromArray:services)
                
            }
        }
        
        if UserDefaults.standard.string(forKey: "switchState03") != nil {
            
            let switch03 = String(UserDefaults.standard.string(forKey: "switchState03")!)
            if switch03 == "1" {
                service03.setOn(true, animated: true)
                services.append("mensa")
            } else {
                service03.setOn(false, animated: true)
                services = arrayRemovingObject("mensa", fromArray:services)
                
            }
        }
        
        if UserDefaults.standard.string(forKey: "switchState04") != nil {
            
            let switch04 = String(UserDefaults.standard.string(forKey: "switchState04")!)
            if switch04 == "1" {
                service04.setOn(true, animated: true)
                services.append("bar")
            } else {
                service04.setOn(false, animated: true)
                services = arrayRemovingObject("bar", fromArray:services)
            }
        }
        
        if UserDefaults.standard.string(forKey: "switchState05") != nil {
            
            let switch05 = String(UserDefaults.standard.string(forKey: "switchState05")!)
            if switch05 == "1" {
                service05.setOn(true, animated: true)
                services.append("emergenza")
            } else {
                service05.setOn(false, animated: true)
                services = arrayRemovingObject("emergenza", fromArray:services)
                
            }
        }
        
        if UserDefaults.standard.string(forKey: "switchState06") != nil {
            
            let switch06 = String(UserDefaults.standard.string(forKey: "switchState06")!)
            if switch06 == "1" {
                service06.setOn(true, animated: true)
                services.append("cercamici")
            } else {
                service06.setOn(false, animated: true)
                services = arrayRemovingObject("cercamici", fromArray:services)
            }
        }
        
    }
    
    //Definisco l'array contenente i valori possibili della variabile RUOLO
    var pickerValues = ["", "PWD", "TUTOR", "GUEST", "HOST"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sottoscrivi.layer.cornerRadius = 15.0
        sottoscrivi.layer.shadowColor = UIColor.black.cgColor
        sottoscrivi.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        sottoscrivi.layer.shadowRadius = 10.0
        sottoscrivi.layer.shadowOpacity = 0.8

        
        switchPreloadValues()
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        Role_Field.inputView = pickerView
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, pickerView)
        
        if UserDefaults.standard.string(forKey: "storedrole") != nil {
            
            Role_Field.text = String( UserDefaults.standard.string(forKey: "storedrole")!)
        }
        
    }
    
    // Definisco le labels dei valori della pickerView per utilizzo accessibile (Voice Over)
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickLabel = view as! UILabel!
        if view == nil {
            pickLabel = UILabel()
        }
        let titleData = pickerValues[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Arial", size: 18.0)!,NSForegroundColorAttributeName:UIColor.black])
        pickLabel!.attributedText = myTitle
        pickLabel!.textAlignment = .center
        return pickLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, accessibilityLabelForComponent component: String) -> String {
        
        var label: String = ""
        
        switch label {
        case "":
            label = ""
        case "PWD":
            label = "PWD"
        case "TUTOR":
            label = "TUTOR"
        case "GUEST":
            label = "GUEST"
        case "HOST":
            label = "HOST"
        default:
            label = ""
        }
        return label
    }
    
    // Definisco il numero di colonne del pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Definisco il numero di valori contenuti nel pickerview (conto gli ingressi dell'array sopra defintio)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValues.count
    }
    
    // Registro la scelta dell'utente
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Role_Field.text = pickerValues[row]
        UserDefaults.standard.set(Role_Field.text!, forKey: "storedrole")
        self.view.endEditing(true)
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, service01)
    }
    
    // Funzione per far "sparire" la tastiera se utente clicca su un punto dela view diverso da textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
