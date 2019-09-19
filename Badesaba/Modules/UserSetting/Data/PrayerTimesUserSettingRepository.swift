//
//  PrayerTimesUserSettingRepository.swift
//  Badesaba
//
//  Created by Mahdiyar Oraei on 8/31/19.
//  Copyright © 2019 Moj Hamrah. All rights reserved.
//

class PrayerTimesUserSettingRepository: PrayerTimesDataProvider {
    var localService: PrayerTimesUserSettingLocalService!
    
    func saveSetting(algorithm: String) {
        localService.saveSelectedAlgorithm(AKPrayerTime.CalculationMethod(rawValue: algorithm)!)
    }
    
    func saveSetting(latLong: [Double]) {
        localService.saveSelectedLatLong(latLong: latLong)
    }
    
    func getUserSelectedSetting() throws -> PrayerTimesSetting {
        let latLong = try localService.getSelectedLatLong()
        let algorithm = localService.getSelectedAlgorithm()
        
        return PrayerTimesSetting(latLong: latLong, algorithm: algorithm)
    }
}
