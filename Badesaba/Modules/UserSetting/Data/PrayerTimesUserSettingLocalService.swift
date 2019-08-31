//
//  PrayerTimesUserSettingLocalService.swift
//  Badesaba
//
//  Created by Mahdiyar Oraei on 8/31/19.
//  Copyright © 2019 Moj Hamrah. All rights reserved.
//
import Foundation

protocol IPrayerTimesUserSettingLocalService {
    func getSelectedLatLong() throws -> [Double]
    func getSelectedAlgorithm() -> String
    func saveSelectedLatLong(latLong: [Double])
    func saveSelectedAlgorithm(_ algorithm: AKPrayerTime.CalculationMethod)
}

class PrayerTimesUserSettingLocalService: IPrayerTimesUserSettingLocalService {
    func saveSelectedAlgorithm(_ algorithm: AKPrayerTime.CalculationMethod) {
        UserDefaults.standard.set(algorithm.rawValue, forKey: Constants.UserDefaults.userSelectedAlgorithm)
    }
    
    func saveSelectedLatLong(latLong: [Double]) {
        UserDefaults.standard.set(latLong, forKey: Constants.UserDefaults.userSelectedLatLong)
    }
    
    func getSelectedAlgorithm() -> String {
        return UserDefaults.standard.string(forKey: Constants.UserDefaults.userSelectedAlgorithm) ?? AKPrayerTime.CalculationMethod.Tehran.rawValue
    }
    
    func getSelectedLatLong() throws -> [Double] {
        guard let latLong = UserDefaults.standard.array(forKey: Constants.UserDefaults.userSelectedLatLong) as? [Double] else {
            throw Error.didNotSelectLatLongEver
        }
        return latLong
    }
}

extension PrayerTimesUserSettingLocalService {
    enum Error: Swift.Error, Equatable {
        case didNotSelectLatLongEver
    }
}
