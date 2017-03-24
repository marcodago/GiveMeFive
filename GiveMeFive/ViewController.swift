//
//  ViewController.swift
//  GiveMeFive 1.3.4
//
//  Created by Marco D'Agostino on 02/03/2017
//

import UIKit

class ViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    var DisclaimerRead:Bool = Bool(UserDefaults.standard.bool(forKey: "read"))
    
    override func viewDidLoad() {
        if DisclaimerRead == false {
            UserDefaults.standard.set(true, forKey: "read")
            let message = "GiveMeFive is a mobile solution made by MWA@IBM team, having focus on support people with disabilities either within office location and approaching IBM location. It is based on a mix of BlueMix services whose guarantee infrastructure boundaries and iOS frameworks whose guarantee the necessary user interface. All credits go to MWA@IBM"
            
            let alertController = UIAlertController(title: "PLEASE READ!", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    // Gestisce la chiusura della view di Google Sign-In
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    //questa funzione gestisce le informazioni che possiamo estrarre dal profilo Google a cui l'utente si sta loggando
    func sign(_ signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            _ = user.userID                  // For client-side use only!
            _ = user.authentication.idToken // Safe to send to the server
            _ = user.profile.name
            _ = user.profile.email
            
            let signInPage = self.storyboard!.instantiateViewController(withIdentifier: "MenuVC")
            self.present(signInPage, animated: true, completion: nil)
            
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    //questa funzione gestisce la disconnessione dell'utente dal suo profilo Google
    func sign(_ signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}
