//
//  CoreDataService.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 14/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataService: Storable {
    private var daddyMOC: NSManagedObjectContext
    private var defaultMOC: NSManagedObjectContext

    init() {
        self.daddyMOC = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
        self.defaultMOC = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        //TODO: core data file log
        print(urls[urls.count-1] as URL)
    }
    
    func config(completion: @escaping (StorableError?) -> ()) {
        let stackQueue = DispatchQueue.global(qos: .default)
        
        stackQueue.async { [weak self] in
            guard let modelURL = Bundle.main.url(forResource: "Model", withExtension: "momd"),
                let menegedObjectModel = NSManagedObjectModel.init(contentsOf: modelURL),
                let applicationDocumentDerictory = self?.applicationDocumentDirectory() else {
                    
                    completion(.modelFileNotValid)
                    
                    return
            }
            
            let persistentStoreCoordinator = NSPersistentStoreCoordinator.init(managedObjectModel: menegedObjectModel)
            let options = [NSMigratePersistentStoresAutomaticallyOption : true,
                           NSInferMappingModelAutomaticallyOption : true]
            let storeURL = applicationDocumentDerictory.appendingPathComponent("Model.sqlite")
            
            do {
                try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
                
                self?.daddyMOC.persistentStoreCoordinator = persistentStoreCoordinator
                
                DispatchQueue.main.async { [weak self] in
                    self?.defaultMOC.persistentStoreCoordinator = persistentStoreCoordinator
                    
                    print("Creating CoreData stack has successfully finished.")
                    
                    completion(nil)
                    
                    return
                }
            } catch let error as NSError {
                print("Creating Persistent store coordinator has finished with error: \(error.description)")
                
                completion(.coordinatorHasNotCreated)
                
                return
            }
        }
    }
    
    private func applicationDocumentDirectory() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    }
    
    func getBackgroundContextForTask() -> NSManagedObjectContext {
        let bgMOC = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
        bgMOC.parent = defaultMOC
        
        return bgMOC
    }
    
    func saveBackground(context: NSManagedObjectContext, completion:@escaping (NSError?)->()) {
        if (context.hasChanges) {
            context.performAndWait {
                do {
                    try context.save()
                    
                    completion(nil)
                    
                    print("Saving backround context has successfully finished")
                } catch let error as NSError {
                    print("Saving backround context has finished with error: \(error.description)")
                    completion(error)
                    
                    return
                }
            }
            saveDefaultContext(isWait: true)
            
            return
        }
        
        completion(nil)
    }
    
    private func saveDefaultContext(isWait: Bool) {
        if (defaultMOC.hasChanges) {
            defaultMOC.performAndWait {
                do {
                    try defaultMOC.save()
                    
                    print("Saving default context has successfully finished")
                } catch let error as NSError {
                    print("Saving default context has finished with error: \(error.description)")
                    
                    return
                }
            }
            
            let saveDaddyContext = { [weak self] in
                do {
                    try self?.daddyMOC.save()
                    
                    print("Saving daddy context has successfully finished")
                } catch let error as NSError {
                    print("Saving daddy context has finished with error: \(error.description)")
                    
                    return
                }
            }
            
            if isWait {
                daddyMOC.performAndWait {
                    saveDaddyContext()
                }
            } else {
                daddyMOC.perform {
                    saveDaddyContext()
                }
            }
        }
    }
    
    func getCurrentThreadContext() -> NSManagedObjectContext {
        if Thread.isMainThread {
            return defaultMOC
        }
        
        return getBackgroundContextForTask()
    }
}

