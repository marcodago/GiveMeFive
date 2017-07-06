//
//  PrivacyViewController.swift
//  GiveMeFive 1.4.0
//
//  Created by Marco D'Agostino on 02/03/2017
//

import Foundation

class PrivacyViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    @IBAction func BackToProfile(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pdf = Bundle.main.url(forResource: "PrivacyPolicy", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let req = URLRequest(url: pdf)
            let privacyView = UIWebView(frame: CGRect(x: 0,y: 0,width: self.view.frame.size.width,height: self.view.frame.size.height-40))
            privacyView.loadRequest(req)
            self.view.addSubview(privacyView)
        }
    }
}
