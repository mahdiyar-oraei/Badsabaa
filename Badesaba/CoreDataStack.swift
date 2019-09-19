//
//  CoreDataStack.swift
//  Badesaba
//
//  Created by Macintosh on 9/19/19.
//  Copyright © 2019 Moj Hamrah. All rights reserved.
//

import CoreData

class CoreDataStack {
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BadesabaDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                print(error)
            }
        })
        
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        return storeContainer.viewContext
    }()
    
    func saveContext() throws {
        guard managedContext.hasChanges else {
            return
        }
        
        try managedContext.save()
    }
}
