//
//  ChatViewController.swift
//  GiveMeFive
//
//  Created by Marco D'Agostino on 15/03/16.
//  Copyright © 2015 MWA@IBM. All rights reserved.
//

import UIKit
import WebKit

class ChatViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet var myProgressView: UIProgressView!
    
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://Gm5.mybluemix.net/client2chat")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}
