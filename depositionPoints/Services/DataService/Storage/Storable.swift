//
//  Storable.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 14/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation
import CoreData

enum StorableError: Error {
    case modelFileNotValid
    case coordinatorHasNotCreated
    case contextNotSaved
    case entityNotConverted
    case objectNotUpdated
    case objectNotInserted
}

protocol Storable {
    init()

    func config(completion: @escaping (StorableError?)->())
    
    func getBackgroundContextForTask() -> NSManagedObjectContext
    
    func saveBackground(context: NSManagedObjectContext, completion:@escaping (NSError?)->())
    
    func insert(entityName: String,
                object: [String : Any],
                completion: @escaping (Result<NSManagedObject, StorableError>) -> ())
    
    func update(newObject: [String : Any], oldObject: NSManagedObject, completion: @escaping (StorableError?) -> ())
    
    func getCurrentThreadContext() -> NSManagedObjectContext
    
    func getObject(from entityName: String,
                   sort descriptors: [NSSortDescriptor]?,
                   predicate: NSPredicate?,
                   context: NSManagedObjectContext) -> [NSManagedObject]
}
