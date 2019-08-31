//
//  PrayerTimesUserSettingRepository.swift
//  Badesaba
//
//  Created by Mahdiyar Oraei on 8/31/19.
//  Copyright © 2019 Moj Hamrah. All rights reserved.
//

class PrayerTimesUserSettingRepository: PrayerTimesDataProvider {
    var localService: IPrayerTimesUserSettingLocalService!
    
    func getUserSelectedSetting() throws {
        let _ = try localService.getSelectedLatLong()
        let _ = localService.getSelectedAlgorithm()
    }
}
