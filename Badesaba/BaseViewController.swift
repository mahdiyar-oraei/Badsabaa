//
//  BaseViewController.swift
//  Badesaba
//
//  Created by Macintosh on 9/22/19.
//  Copyright © 2019 Moj Hamrah. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    let theme = ThemeManager.currentTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = theme.backgroundColor
    }
    
    func showErrorAlert(message: String) {
    }
}
