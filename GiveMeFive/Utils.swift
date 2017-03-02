//
//  Utils.swift
//  GiveMeFive
//
//  Created by Marco D'Agostino on 30/01/17.
//  Copyright © 2017 MWA@IBM. All rights reserved.
//

import UIKit

class Utils {
    // MARK: NSNotificationCenter Management
    
    class func registerNotificationWillEnterForeground(observer: AnyObject, selector: Selector) {
        // Handle when the app becomes active, going from the background to the foreground
        NotificationCenter.default.addObserver(observer, selector: selector, name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    class func removeObserverForNotifications(observer: AnyObject) {
        NotificationCenter.default.removeObserver(observer)
    }
}
