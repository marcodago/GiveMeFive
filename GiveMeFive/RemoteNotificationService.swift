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
    
    static private let APPGUID = "50f67e2d-952b-41ea-83a6-ef0af87b2c3e"         // Internal CIO Bluemix instance
    static private let clientSecret = "fb50af74-50fd-4a50-9cab-f18072206644"    // Internal CIO Bluemix instance
    static private let myBMSClient = BMSClient.sharedInstance
    static private let push = BMSPushClient.sharedInstance
    
    // Initialize the Core SDK for Swift with IBM Bluemix GUID, route, and region
    
    static func initializeAPN() {
        myBMSClient.initialize(bluemixRegion: BMSClient.Region.usSouth)
    }
    
    static func registerDeviceToken(_ deviceToken: Data) {
        push.initializeWithAppGUID(appGUID: APPGUID, clientSecret: clientSecret)
        push.registerWithDeviceToken(deviceToken: deviceToken) { (response, statusCode, error) -> Void in
            
            if error.isEmpty {
                print("Response during device registration : \(response)")
                print("status code during device registration : \(statusCode)")
            } else {
                print("Error during device registration \(error) ")
                print("Error during device registration \n  - status code: \(statusCode) \n Error :\(error) \n")
            }
        }
    }
}
