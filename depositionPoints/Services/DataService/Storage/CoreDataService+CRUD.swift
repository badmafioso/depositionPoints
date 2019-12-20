//
//  CoreDataService+CRUD.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 15/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation
import CoreData

extension CoreDataService {
    func insert(entityName: String, object: [String : Any], completion: @escaping (Result<NSManagedObject, StorableError>) -> ()) {
        let context = getBackgroundContextForTask()
        let entity  = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)

        for (key, value) in object {
            entity.setValue(value, forKey: key)
        }
        
        saveBackground(context: context) { (error) in
            if let error = error {
                print("Saving element in CoreData has finished with error: \(error.description)")
                completion(.failure(.contextNotSaved))
                
                return
            }
            
            completion(.success(entity))
        }
    }
    
    func update(newObject: [String : Any], oldObject: NSManagedObject, completion: @escaping (StorableError?) -> ()) {
        let context              = getBackgroundContextForTask()
        let oldObjectFromContext = context.object(with: oldObject.objectID)
        
        for (key, value) in newObject {
            oldObjectFromContext.setValue(value, forKey: key)
        }
        
        saveBackground(context: context) { (error) in
            if let error = error {
                print("Updating object in CoreData has finished with error: \(error.description)")
                completion(.objectNotUpdated)
                
                return
            }
            
            completion(nil)
        }
    }
    
    private func getFetchRequest(from entityName: String,
                         sort descriptors: [NSSortDescriptor]?,
                         predicate: NSPredicate?,
                         in context: NSManagedObjectContext) -> NSFetchRequest<NSFetchRequestResult> {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.sortDescriptors = descriptors
        fetchRequest.predicate = predicate
        
        return fetchRequest
    }
    
    func getObject(from entityName: String,
                   sort descriptors: [NSSortDescriptor]?,
                   predicate: NSPredicate?,
                   context: NSManagedObjectContext) -> [NSManagedObject] {
        
        let fetchRequest = getFetchRequest(from: entityName, sort: descriptors, predicate: predicate, in: context)
        
        do {
            let result = try context.fetch(fetchRequest)
            
            return result as! [NSManagedObject]
        } catch let error as NSError {
            print("Execute request has finished with error: \(error.description)")
            
            return [NSManagedObject]()
        }
    }
}
