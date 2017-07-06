//
//  HQMapViewController.swift
//  GiveMeFive 1.4.0
//
//  Created by Marco D'Agostino on 22/05/17.
//

import UIKit
import WebKit

class HQMapViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet var myProgressView: UIProgressView!
    
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "http://gm5.eu-gb.mybluemix.net/mapstations")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}
