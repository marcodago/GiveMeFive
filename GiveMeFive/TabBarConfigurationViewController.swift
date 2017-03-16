//
//  TabBarConfigurationViewController.swift
//  GiveMeFive 1.3.4
//
//  Created by Marco D'Agostino on 02/03/2017
//

import UIKit

class TabBarConfigurationViewController: UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBar.barTintColor = .white
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
