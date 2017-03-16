//
//  TouchIDViewController.swift
//  GiveMeFive 1.3.4
//
//  Created by Marco D'Agostino on 02/03/2017
//

import UIKit
import Foundation
import LocalAuthentication

class TouchIDViewController: UIViewController {
    
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var Message: UILabel!
    
    let kMsgShowFinger = "Show me your finger 👍"
    let kMsgShowReason = "🌛 Try to dismiss this screen 🌜"
    let kMsgFingerOK = "Login successful! ✅"
    
    var context = LAContext()
    
    deinit {
        Utils.removeObserverForNotifications(observer: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
    }
    
    private func setupController() {
        Utils.registerNotificationWillEnterForeground(observer: self, selector: #selector(TouchIDViewController.updateUI))
        
    }
    
    // Autenticazione riuscita tramite Touch ID - procedo visualizzando la pagina iniziale
    func navigateToAuthenticatedViewController(){
        
        if let loggedInVC = storyboard?.instantiateViewController(withIdentifier: "MenuVC") {
            
            DispatchQueue.main.async{ () -> Void in
            
                self.present(loggedInVC, animated: true, completion: nil)
                
            }
        }
        
    }
    
    // Autenticazione fallita tramite Touch ID - procedo richiedendo l'autenticazione social - Google
    func navigateToSocialViewController(){
        
        if let SocialVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") {
            
            DispatchQueue.main.async{ () -> Void in
                
                self.present(SocialVC, animated: true, completion: nil)
                
            }
            
        }
        
    }

    
    func updateUI() {
        var policy: LAPolicy?
        // Depending the iOS version we'll need to choose the policy we are able to use
        if #available(iOS 9.0, *) {
            // iOS 9+ users with Biometric and Passcode verification
            policy = .deviceOwnerAuthentication
        } else {
            // iOS 8+ users with Biometric and Custom (Fallback button) verification
            context.localizedFallbackTitle = "Fuu!"
            policy = .deviceOwnerAuthenticationWithBiometrics
        }
        
        var err: NSError?
        
        // Check if the user is able to use the policy we've selected previously
        guard context.canEvaluatePolicy(policy!, error: &err) else {
            Image.image = UIImage(named: "TouchID_off")
            // Print the localized message received by the system
            Message.text = err?.localizedDescription
            return
        }
        
        // Great! The user is able to use his/her Touch ID 👍
        Image.image = UIImage(named: "TouchID_on.png")
        Message.text = kMsgShowFinger
        
        loginProcess(policy: policy!)
    }
    
    private func loginProcess(policy: LAPolicy) {
        // Start evaluation process with a callback that is executed when the user ends the process successfully or not
        context.evaluatePolicy(policy, localizedReason: kMsgShowReason, reply: { (success, error) in
            DispatchQueue.main.async {
                
                guard success else {
                    guard let error = error else {
                        self.showUnexpectedErrorMessage()
                        return
                    }
                    switch(error) {
                    case LAError.authenticationFailed:
                        self.Message.text = "There was a problem verifying your identity."
                    case LAError.userCancel:
                        self.Message.text = "Authentication was canceled by user."
                        // Fallback button was pressed and an extra login step should be implemented for iOS 8 users.
                    // By the other hand, iOS 9+ users will use the pasccode verification implemented by the own system.
                    case LAError.userFallback:
                        self.Message.text = "The user tapped the fallback button."
                    case LAError.systemCancel:
                        self.Message.text = "Authentication was canceled by system."
                    case LAError.passcodeNotSet:
                        self.Message.text = "Passcode is not set on the device."
                    case LAError.touchIDNotAvailable:
                        self.Message.text = "Touch ID is not available on the device."
                    case LAError.touchIDNotEnrolled:
                        self.Message.text = "Touch ID has no enrolled fingers."
                    // iOS 9+ functions
                    case LAError.touchIDLockout:
                        self.Message.text = "There were too many failed Touch ID attempts and Touch ID is now locked."
                    case LAError.appCancel:
                        self.Message.text = "Authentication was canceled by application."
                    case LAError.invalidContext:
                        self.Message.text = "LAContext passed to this call has been previously invalidated."
                    // MARK: IMPORTANT: There are more error states, take a look into the LAError struct
                    default:
                        self.Message.text = "Touch ID may not be configured"
                        break
                    }
                    
                    self.navigateToSocialViewController()
                    return
                }
                
                // Good news! Everything went fine 👏
                self.Message.text = self.kMsgFingerOK
                self.navigateToAuthenticatedViewController()

            }
        })
    }
    
    private func showUnexpectedErrorMessage() {
        Image.image = UIImage(named: "TouchID_off")
        Message.text = "Unexpected error! 😱"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
