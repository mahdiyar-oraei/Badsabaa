//
//  UserSettingPresenter.swift
//  Badesaba
//
//  Created by Macintosh on 9/19/19.
//  Copyright © 2019 Moj Hamrah. All rights reserved.
//

class UserSettingPresenter {
    weak var view: UserSettingLocationView?
    var interactor: UserSettingInteractorType!
}

extension UserSettingPresenter: UserSettingInteractorOutput {
    
    func citiesDidLoad(_ models: [CityModel]) {
        self.view?.showSelectedCitiesHistory(models)
    }
    
    func citiesLoadFailed(_ error: Error) {
        self.view?.showErrorAlert(message: error.localizedDescription)
    }
}

extension UserSettingPresenter: UserSettingLocationPresentation {
    func viewDidLoad() {
        self.interactor.getCities()
    }
}
