//
//  AppDelegate.swift
//  GiveMeFive
//
//  Created by Marco D'Agostino on 02/03/2017
//

import UIKit
import CoreData
import CoreLocation
import AddressBookUI
import UserNotifications

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Registro il servizio di pushnotification
        registerForRemoteNotification()
        
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("User Info = ",notification.request.content.userInfo)
        completionHandler([.alert, .badge, .sound])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("User Info = ",response.notification.request.content.userInfo)
        completionHandler()
    }
    
    
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
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
