//
//  LocationUserSettingRepository.swift
//  Badesaba
//
//  Created by Macintosh on 9/19/19.
//  Copyright © 2019 Moj Hamrah. All rights reserved.
//

class LocationUserSettingRepository: LocationDataProvider {
    var localService: LocationUserSettingLocalService!
    
    func getSelectedCitiesHistory() throws -> [CityModel] {
        
        return try localService.getSelectedCitiesHistory().map({ (city) -> CityModel in
            guard let name = city.name else {
                throw GeneralError.notNil
            }
            guard let timezone = city.timezone else {
                throw GeneralError.notNil
            }
                
            return CityModel(
                name: name, latitude: city.latitude, longitude: city.longitude, timezone: timezone
            )
        })
    }
}
