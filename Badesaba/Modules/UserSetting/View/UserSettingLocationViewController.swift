//
//  UserSettingLocationView.swift
//  Badesaba
//
//  Created by Macintosh on 9/19/19.
//  Copyright © 2019 Moj Hamrah. All rights reserved.
//

import UIKit
import SnapKit

class UserSettingLocationViewController: BaseViewController {
    var presenter: UserSettingLocationPresentation!
    
    override var title: String? { get { return Strings.selectCity } set {} }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Strings.add, style: .plain, target: self, action: #selector(onAddTapped))
    }
    
    @objc func onAddTapped() {
        
    }
    
    override func addViews() {
        self.view.addSubview(self.tableView)
    }
    
    override func setupConstraints() {
        self.tableView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(self.view)
        }
    }
    
    // MARK: - Views defenition
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
}

extension UserSettingLocationViewController : UserSettingLocationView {
    func showSelectedCitiesHistory(_ cities: [CityModel]) {
    }
}
