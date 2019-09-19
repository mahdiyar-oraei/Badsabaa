//
//  ILocationUserSettingRepository.swift
//  Badesaba
//
//  Created by Macintosh on 9/19/19.
//  Copyright © 2019 Moj Hamrah. All rights reserved.
//

import CoreData

protocol LocationUserSettingLocalService {
    func getSelectedCitiesHistory() throws -> [City]
}

class ILocationUserSettingLocalService: LocationUserSettingLocalService {
    var coreDataStack: CoreDataStack!
    
    func getSelectedCitiesHistory() throws -> [City] {
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(City.name), ascending: false)]
        return try coreDataStack.managedContext.fetch(fetchRequest)
    }
}
