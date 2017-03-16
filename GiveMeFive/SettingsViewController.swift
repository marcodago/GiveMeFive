//
//  SettingsViewController.swift
//  GiveMeFive 1.3.4
//
//  Created by Marco D'Agostino on 02/03/2017
//

import UIKit
import Foundation

class SettingsViewController: UIViewController, UITextFieldDelegate, NSURLConnectionDelegate {
    
    var esito: Bool = false
    
    //Inizializzo i parametri di indirizzo e tipologia del POST
    let servizio = "https://Gm5.mybluemix.net/client2enroll"
    let tipo = "enrollment_form_UI"
    
    var switchState: Bool = false
    var switchStateTouch: Bool = false
    var privacyvalue: String = "NO"
    
    //catturo valore campi da Interface Builder
    @IBOutlet var Field_Name: UITextField!
    @IBOutlet var Field_Surname: UITextField!
    @IBOutlet var Field_EmployeeCode: UITextField!
    @IBOutlet var Field_Company: UITextField!
    @IBOutlet var Field_Email: UITextField!
    @IBOutlet var Field_Mobile: UITextField!
    @IBOutlet var Field_EmergencyPhone: UITextField!
    @IBOutlet var Field_EmergencyContact: UITextField!
    
    @IBOutlet var TouchID_YN: UISwitch!
    @IBAction func TouchIDOnOff(_ sender: AnyObject) {
        if TouchID_YN.isOn {
            switchStateTouch = true
            UserDefaults.standard.set(switchStateTouch, forKey: "switchStateTouch")
            UserDefaults.standard.synchronize()
            print("Uso Touch ID:\(switchStateTouch)")
        } else {
            switchStateTouch = false
            UserDefaults.standard.set(switchStateTouch, forKey: "switchStateTouch")
            UserDefaults.standard.synchronize()
            print("Uso Touch ID:\(switchStateTouch)")
        }
        saveSwitchesStates()
    }
    
    @IBOutlet var Privacy_YN: UISwitch!
    @IBAction func PrivacyOnOff(_ sender: AnyObject) {
        if Privacy_YN.isOn {
            switchState = true
            UserDefaults.standard.set(switchState, forKey: "switchState")
            UserDefaults.standard.synchronize()
            privacyvalue = "YES"
            print("Privacy is:\(switchState)")
        } else {
            switchState = false
            UserDefaults.standard.set(switchState, forKey: "switchState")
            UserDefaults.standard.synchronize()
            privacyvalue = "NO"
            print("Privacy is:\(switchState)")
        }
        saveSwitchesStates()
    }
    
    @IBOutlet var privacyread: UIButton!
    @IBAction func privacypressed(_ sender: AnyObject) {
        let privacyPage = self.storyboard!.instantiateViewController(withIdentifier: "PrivacyVC")
        self.present(privacyPage, animated: true, completion: nil)
    }
    
    
    @IBAction func Register(_ sender: UIButton) {
        
        print("Name:\(Field_Name.text!)")
        print("Surname:\(Field_Surname.text!)")
        print("Email:\(Field_Email.text!)")
        print("EmpCode:\(Field_EmployeeCode.text!)")
        print("Company:\(Field_Company.text!)")
        print("EmergPhone:\(Field_EmergencyPhone.text!)")
        print("EmergContact:\(Field_EmergencyContact.text!)")
        
        //  Routine di validazione campi profilo utente (se non compilati, il modulo non si finalizza)
        let emptyfield: String = " "
        if (Field_Name.text!==emptyfield || Field_Surname.text!==emptyfield || Field_Email.text!==emptyfield || Field_EmployeeCode.text!==emptyfield || Field_Company.text!==emptyfield || Field_EmergencyPhone.text!==emptyfield || Field_EmergencyContact.text!==emptyfield || Field_Mobile.text!==emptyfield) {
            
            let alertController = UIAlertController(title: "Modulo incompleto", message: "Modulo incompleto! Si prega di compilare tutti i campi", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            
            // salvo le informazioni di profilo sul BlueMix
            let payload = "&nome=\(Field_Name.text!)&cogmone=\(Field_Surname.text!)&email=\(Field_Email.text!)&codice=\(Field_EmployeeCode.text!)&azienda=\(Field_Company.text!)&numerotelefono1=\(Field_Mobile.text!)&numtelemergenza=\(Field_EmergencyPhone.text!)&nomcognmergenza=\(Field_EmergencyContact.text!)&privacy=\(privacyvalue.lowercased())"
            
            let esito = SupportingFunctions.insertRecords(tipo , payload: payload , servizio: servizio)
            
            if esito == true {
                let alertController = UIAlertController(title: "DATA SENT", message: "Your profile has been registered", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    print("you have pressed OK button");
                }
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true, completion:nil)
            }
            
            // salvo le informazioni di profilazione sul device
            UserDefaults.standard.set(Field_Name.text!, forKey: "storedname")
            UserDefaults.standard.set(Field_Surname.text!, forKey: "storedsurname")
            UserDefaults.standard.set(Field_Email.text!, forKey: "storedemail")
            UserDefaults.standard.set(Field_EmployeeCode.text!, forKey: "storedemployeecode")
            UserDefaults.standard.set(Field_Company.text!, forKey: "storedcompany")
            UserDefaults.standard.set(Field_Mobile.text!, forKey: "storedmobile")
            UserDefaults.standard.set(Field_EmergencyPhone.text!, forKey: "storedemergencyphone")
            UserDefaults.standard.set(Field_EmergencyContact.text!, forKey: "storedemergencycontact")
            
            // Pulisco i campi della maschera di profilazione
            resetTextfieldsEntry()
        }
    }
    
    // routine per salvataggio dello stato degli switches
    func saveSwitchesStates () {
        // salvo le informazioni di profilazione sul device
        UserDefaults.standard.set(TouchID_YN!.isOn, forKey: "TouchID_YN");
        UserDefaults.standard.set(Privacy_YN!.isOn, forKey: "Privacy_YN");
        UserDefaults.standard.synchronize();
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let switch_positionTouch = String(UserDefaults.standard.string(forKey: "switchStateTouch")!)
        if switch_positionTouch == "1" {
            TouchID_YN.setOn(true, animated: true)
        }
        
        let switch_positionPrivacy = String(describing: UserDefaults.standard.string(forKey: "switchState"))
        if switch_positionPrivacy == "1" {
            Privacy_YN.setOn(true, animated: true)
        }
        
        
        if UserDefaults.standard.string(forKey: "storedname") != nil {
            
            Field_Name.text = String( UserDefaults.standard.string(forKey: "storedname")!)
            Field_Surname.text! = String( UserDefaults.standard.string(forKey: "storedsurname")!)
            Field_Email.text! = String( UserDefaults.standard.string(forKey: "storedemail")!)
            Field_EmployeeCode.text! = String( UserDefaults.standard.string(forKey: "storedemployeecode")!)
            Field_Company.text! = String( UserDefaults.standard.string(forKey: "storedcompany")!)
            Field_Mobile.text! = String( UserDefaults.standard.string(forKey: "storedmobile")!)
            Field_EmergencyPhone.text! = String( UserDefaults.standard.string(forKey: "storedemergencyphone")!)
            Field_EmergencyContact.text! = String( UserDefaults.standard.string(forKey: "storedemergencycontact")!)
            
            Field_Name.delegate = self
            Field_Surname.delegate = self
            Field_Email.delegate = self
            Field_EmployeeCode.delegate = self
            Field_Company.delegate = self
            Field_EmergencyPhone.delegate = self
            Field_EmergencyContact.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if UserDefaults.standard.string(forKey: "storedname") != nil {
            
            Field_Name.text = String( UserDefaults.standard.string(forKey: "storedname")!)
            Field_Surname.text! = String( UserDefaults.standard.string(forKey: "storedsurname")!)
            Field_Email.text! = String( UserDefaults.standard.string(forKey: "storedemail")!)
            Field_EmployeeCode.text! = String( UserDefaults.standard.string(forKey: "storedemployeecode")!)
            Field_Company.text! = String( UserDefaults.standard.string(forKey: "storedcompany")!)
            Field_Mobile.text! = String( UserDefaults.standard.string(forKey: "storedmobile")!)
            Field_EmergencyPhone.text! = String( UserDefaults.standard.string(forKey: "storedemergencyphone")!)
            Field_EmergencyContact.text! = String( UserDefaults.standard.string(forKey: "storedemergencycontact")!)
            
            Field_Name.delegate = self
            Field_Surname.delegate = self
            Field_Email.delegate = self
            Field_EmployeeCode.delegate = self
            Field_Company.delegate = self
            Field_EmergencyPhone.delegate = self
            Field_EmergencyContact.delegate = self
        }
    }
    
    // Funzione per far "sparire" la tastiera se utente clicca su "Return"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        Field_Name.resignFirstResponder()
        Field_Surname.resignFirstResponder()
        Field_Email.resignFirstResponder()
        Field_EmployeeCode.resignFirstResponder()
        Field_Company.resignFirstResponder()
        Field_EmergencyPhone.resignFirstResponder()
        Field_EmergencyContact.resignFirstResponder()
        return true
    }
    
    // Funzione per far "sparire" la tastiera se utente clicca su un punto dela view diverso da textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Funzione per resettare il contenuto dei textfield una volta trasmesso a BlueMix i dati in essi contenuti
    func resetTextfieldsEntry() {
        Field_Name.text = ""
        Field_Surname.text = ""
        Field_EmployeeCode.text = ""
        Field_Company.text = ""
        Field_Email.text = ""
        Field_Mobile.text = ""
        Field_EmergencyPhone.text = ""
        Field_EmergencyContact.text = ""
    }
}
