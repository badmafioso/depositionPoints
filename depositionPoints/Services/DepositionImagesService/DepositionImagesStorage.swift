//
//  DepositionImagesStorage.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 19/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation
import CoreData

final class DepositionImagesStorage: DepositionImagesStorable {
    typealias ActionCallback = (StorableError?) -> ()
    
    static let depositionImagesEntityName       = "DepositionImages"
    static let depositionPartnerDescriptionKey    = "partnerDescription"
    static let depositionPartnerBadDescriptionKey = "description"
    
    var storage: Storable
    private var actionCallback: ActionCallback?
    
    init(storage: Storable) {
        self.storage = storage
    }
    
    func insertOrUpdate(depositionImage: DepositionImage, completion: @escaping ActionCallback) {
        actionCallback = completion
        
        if let oldObject = getImage(partnerName: depositionImage.partnerName ?? "") {
            update(newObject: depositionImage, oldObject: oldObject)
        } else {
            insert(object: depositionImage)
        }
    }

    func insert(object: DepositionImage) {
        insert(depositionImage: object) { [weak self] (result) in
            switch result {
            case .success(_):
                print("Object has inserted")
                
                if let actionCallback = self?.actionCallback {
                    actionCallback(nil)
                }
            case .failure(let error):
                print("Object hasn't inserted")
                
                if let actionCallback = self?.actionCallback {
                    actionCallback(error)
                }
            }
                                    
            return
        }
    }

    func update(newObject: DepositionImage, oldObject: DepositionImage) {
        guard let managedObjectId = oldObject.managedObjectId else {
            if let actionCallback = actionCallback {
                actionCallback(.objectNotUpdated)
            }
            
            return
        }
        
        update(depositionImage: newObject, oldObjectId: managedObjectId) { [weak self] (error) in
            if error == nil {
                print("Deposition partner has updated in Core Data")
                
                if let actionCallback = self?.actionCallback {
                    actionCallback(nil)
                }
            } else {
                if let actionCallback = self?.actionCallback {
                    actionCallback(.objectNotUpdated)
                }
            }
            
            return
        }
    }
    
    func getImage(partnerName: String) -> DepositionImage? {
        let context = storage.getCurrentThreadContext()
        let managedObjects = storage.getObject(from: DepositionImagesStorage.depositionImagesEntityName,
                                               sort: nil,
                                               predicate: getImagePredicate(partnerName: partnerName),
                                               context: context)
        
        if let managedObject = managedObjects.first as? DepositionImages {
            let depositionImage = DepositionImage(partnerName: managedObject.partnerName,
                                                  imageName: managedObject.imageName,
                                                  lastModifiedDate: managedObject.lastModifiedDate,
                                                  image: managedObject.image,
                                                  managedObjectId: managedObject.objectID)
            
            return depositionImage
        }
        
        return nil
    }

    private func getImagePredicate(partnerName: String) -> NSPredicate {
        return NSPredicate(format: "partnerName == %@", partnerName)
    }
    
    func insert(depositionImage: DepositionImage, completion: @escaping (Result<DepositionImages, StorableError>) -> ()) {
        let context = storage.getBackgroundContextForTask()
        let entity  = NSEntityDescription.insertNewObject(forEntityName: DepositionImagesStorage.depositionImagesEntityName,
                                                          into: context)
        
        guard let depositionImages = entity as? DepositionImages else {
            completion(.failure(.entityNotConverted))
            
            return
        }

        depositionImages.partnerName      = depositionImage.partnerName
        depositionImages.imageName        = depositionImage.imageName
        depositionImages.lastModifiedDate = depositionImage.lastModifiedDate
        depositionImages.image            = depositionImage.image
        
        storage.saveBackground(context: context) { (error) in
            if let error = error {
                print("Saving image in CoreData has finished with error: \(error.description)")
                completion(.failure(.contextNotSaved))
                
                return
            }
            
            completion(.success(depositionImages))
        }
    }
    
    func update(depositionImage: DepositionImage, oldObjectId: NSManagedObjectID, completion: @escaping (StorableError?) -> ()) {
        let context              = storage.getBackgroundContextForTask()
        let oldObjectFromContext = context.object(with: oldObjectId)
        
        guard let depositionImages = oldObjectFromContext as? DepositionImages else {
            completion(.entityNotConverted)
            
            return
        }

        depositionImages.partnerName      = depositionImage.partnerName
        depositionImages.imageName        = depositionImage.imageName
        depositionImages.lastModifiedDate = depositionImage.lastModifiedDate
        depositionImages.image            = depositionImage.image
        
        storage.saveBackground(context: context) { (error) in
            if let error = error {
                print("Updating object in CoreData has finished with error: \(error.description)")
                completion(.objectNotUpdated)
                
                return
            }
            
            completion(nil)
        }
    }
}
