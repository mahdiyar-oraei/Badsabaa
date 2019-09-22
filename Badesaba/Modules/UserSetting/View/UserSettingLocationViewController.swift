//
//  UserSettingLocationView.swift
//  Badesaba
//
//  Created by Macintosh on 9/19/19.
//  Copyright © 2019 Moj Hamrah. All rights reserved.
//

import UIKit

class UserSettingLocationViewController: BaseViewController {
    var presenter: UserSettingLocationPresentation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}

extension UserSettingLocationViewController : UserSettingLocationView {
    func showSelectedCitiesHistory(_ cities: [CityModel]) {
    }
}
