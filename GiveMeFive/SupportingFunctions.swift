//
//  SupportingFunctions.swift
//  GiveMeFive
//
//  Created by Marco D'Agostino on 02/03/2017
//

import Foundation
import NetworkExtension
import SystemConfiguration.CaptiveNetwork

class SupportingFunctions {
    
    class func insertRecords(_ tipo:String , payload:String , servizio:String) -> Bool {
        
        var esito: String = ""
        
        // recupero lo username dell'utente connesso, il suo device ID e genero il timestamp
        let userid = String( describing: UserDefaults.standard.object(forKey: "googlemail")! )
        let deviceID = String(describing: UserDefaults.standard.object(forKey: "AppUUID")! )
        var timestamp: String { return "\(Date().timeIntervalSince1970 * 1000)" }
        
        // imposto le informazioni relative alla versione applicative, alla firma del developer e al SO usato
        var version = String()
        version = "100"
        var signature = String()
        signature = "mdago_v01_iOS"
        
        //Importo i parametri di costruzione della POST
        let url:URL = URL(string: servizio)!
        let keyValues = "signature=\(signature)&ver=\(version)&type=\(tipo)&deviceid=\(deviceID)&userid=\(userid)&timestamp=\(timestamp)" + payload
        
        let session = URLSession.shared
        var request = URLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString = keyValues
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            guard let _:Data = data as Data?, let _:URLResponse = response  , error == nil else {
                
                //Oops! Error occured.
                esito = "NO"
                print("error")
                return
            }
            
            //Get the raw response string
            let dataString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            
            //Print the response
            print(dataString!)
            
        }
        
        //resume the task
        task.resume()
        if esito == "NO" {
            return false
        } else {
            return true
        }
    }
}
