//
//  RemoteNotificationService.swift
//  GiveMeFive 1.3.5
//
//  Created by Marco D'Agostino on 22/03/17.
//


import BMSCore
import BMSPush
import CoreData
import Foundation

class RemoteNotificationService {
    
    static private let APPGUID = "86292849-18c2-437a-8746-4198ba9b46b1"         // External Bluemix instance
    static private let clientSecret = "bbd83621-0f6a-4acf-ac29-2ffdd144cccf"    // External Bluemix instance
    static private let myBMSClient = BMSClient.sharedInstance
    static private let push = BMSPushClient.sharedInstance
    
    // Initialize the Core SDK for Swift with IBM Bluemix GUID, route, and region
    
    static func initializeAPN() {
        myBMSClient.initialize(bluemixRegion: BMSClient.Region.usSouth)
    }
    
    static func registerDeviceToken(_ deviceToken: Data) {
        push.initializeWithAppGUID(appGUID: APPGUID, clientSecret: clientSecret)
        //        push.registerWithDeviceToken(deviceToken: deviceToken) { (response, statusCode, error) -> Void in
        let userID = String( UserDefaults.standard.string(forKey: "googleuserid")!)
        push.registerWithDeviceToken(deviceToken: deviceToken, WithUserId: userID) { response, statusCode, error in
            
            if error.isEmpty {
                print("Response during device registration : \(String(describing: response))")
                print("status code during device registration : \(String(describing: statusCode))")
            } else {
                print("Error during device registration \(error) ")
                print("Error during device registration \n  - status code: \(String(describing: statusCode)) \n Error :\(error) \n")
            }
        }
    }
}
