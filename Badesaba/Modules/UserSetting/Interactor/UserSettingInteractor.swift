//
//  UserSettingInteractor.swift
//  Badesaba
//
//  Created by Macintosh on 9/19/19.
//  Copyright © 2019 Moj Hamrah. All rights reserved.
//

class UserSettingInteractor {
    var locationRepository: LocationDataProvider!
    var output: UserSettingInteractorOutput!
}

extension UserSettingInteractor: GetSelectedCitiesHistoryUseCase {
    func getCities() {
        do {
            self.output.citiesDidLoad(try locationRepository.getSelectedCitiesHistory())
        } catch {
            self.output.citiesLoadFailed(error)
        }
    }
}
