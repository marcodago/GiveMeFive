//
//  AppDelegate.swift
//  GiveMeFive 1.3.4
//
//  Created by Marco D'Agostino on 02/03/2017
//

import UIKit
import BMSCore
import BMSPush
import CoreData
import CoreLocation
import AddressBookUI
import UserNotifications

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Inizializza l'SDK Core for Swift con l'area, la rotta e la GUID IBM Bluemix
        let myBMSClient = BMSClient.sharedInstance
        myBMSClient.initialize(bluemixAppRoute: "http://imfpush.ng.bluemix.net/imfpush/v1/apps/8a74c0e6-2f76-496e-ba57-159a3aab4229", bluemixAppGUID: "8a74c0e6-2f76-496e-ba57-159a3aab4229", bluemixRegion: "BMSClient.REGION_US_SOUTH")
        
        let push = BMSPushClient.sharedInstance
        push.initializeWithAppGUID(appGUID: "8a74c0e6-2f76-496e-ba57-159a3aab4229", clientSecret: "732a9030-9f9f-44b4-a1e4-c0a85c6a7e00")

        // Memorizzo il primo UUID generato e lo riutilizzo per fornire indicazione univoca del device connesso
        let userDefaults = UserDefaults.standard
        var usaTouch: String = "0"
        
        if userDefaults.object(forKey: "AppUUID") == nil {
            let UUID = Foundation.UUID().uuidString
            userDefaults.set(UUID, forKey: "AppUUID")
            userDefaults.set(false, forKey: "switchStateTouch")
            userDefaults.synchronize()
            
        }
        
        usaTouch = String(userDefaults.string(forKey: "switchStateTouch")!)
        
        if usaTouch == "1" {
            
            let myStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let protectedPage = myStoryBoard.instantiateViewController(withIdentifier: "TouchVC")
            let protectedPageNav = UINavigationController(rootViewController: protectedPage)
            
            self.window?.rootViewController = protectedPageNav
            
        } else {
            
            let myStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let protectedPage = myStoryBoard.instantiateViewController(withIdentifier: "LoginVC")
            let protectedPageNav = UINavigationController(rootViewController: protectedPage)
            
            self.window?.rootViewController = protectedPageNav
        }
        
        // Inizializzo il servizio di Google sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }
    
    func application (_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        
        let push =  BMSPushClient.sharedInstance
        push.registerWithDeviceToken(deviceToken: deviceToken) { (response, statusCode, error) -> Void in
            if error.isEmpty {
                print( "Response during device registration : \(response)")
                print( "status code during device registration : \(statusCode)")
            } else{
                print( "Error during device registration \(error) ")
                print( "Error during device registration \n  - status code: \(statusCode) \n Error :\(error) \n")
            }
        }
    }
    

    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        //Il dizionario UserInfo conterrà i dati inviati dal server
    }

    
    //questa funzione gestisce il collegamento dell'app all'URL di Google Sign-In
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    //questa funzione gestisce le informazioni che possiamo estrarre dal profilo Google a cui l'utente si sta loggando
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            _ = user.userID                  // For client-side use only!
            _ = user.authentication.idToken // Safe to send to the server
            _ = user.profile.name
            _ = user.profile.email
            
            
            UserDefaults.standard.set(user.userID, forKey: "googleuserid")
            UserDefaults.standard.set(user.profile.name, forKey: "googlename")
            UserDefaults.standard.set(user.profile.email, forKey: "googlemail")
            
            let myStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let protectedPage = myStoryBoard.instantiateViewController(withIdentifier: "MenuVC")
            let protectedPageNav = UINavigationController(rootViewController: protectedPage)
            
            self.window?.rootViewController = protectedPageNav
            
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
}
