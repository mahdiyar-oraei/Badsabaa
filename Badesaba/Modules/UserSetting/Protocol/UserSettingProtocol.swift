//
//  UserSettingProtocol.swift
//  Badesaba
//
//  Created by Mahdiyar Oraei on 8/31/19.
//  Copyright © 2019 Moj Hamrah. All rights reserved.
//

protocol PrayerTimesDataProvider: class {
    func getUserSelectedSetting() throws -> PrayerTimesSetting
    func saveSetting(latLong: [Double])
    func saveSetting(algorithm: String)
}

protocol LocationDataProvider {
    func getSelectedCitiesHistory() throws -> [CityModel]
}

protocol GetSelectedCitiesHistoryUseCase: class {
    func getCities()
}

protocol UserSettingInteractorOutput: class {
    func citiesDidLoad(_ models: [CityModel])
    func citiesLoadFailed(_ error: Error)
}

protocol UserSettingLocationView: class {
    func showSelectedCitiesHistory(_ cities: [CityModel])
    func showErrorAlert(message: String)
}

protocol UserSettingLocationPresentation {
    func viewDidLoad()
    func onAddCityTapped()
}
