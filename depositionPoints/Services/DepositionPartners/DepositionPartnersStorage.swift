//
//  DepositionPartnersStorage.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 17/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation
import CoreData

final class DepositionPartnersStorage: DepositionPartnersStorable {
    typealias ActionCallback = (StorableError?) -> ()
    
    static let depositionPartnersEntityName       = "DepositionPartners"
    static let depositionPartnerDescriptionKey    = "partnerDescription"
    static let depositionPartnerBadDescriptionKey = "description"
    
    var storage: Storable
    private var actionCallback: ActionCallback?
    
    init(storage: Storable) {
        self.storage = storage
    }
    
    func insertOrUpdate(depositionPartner: DepositionPartnerJSON, completion: @escaping ActionCallback) {
        actionCallback = completion
        let context = storage.getCurrentThreadContext()
        let oldObjects = storage.getObject(from: DepositionPartnersStorage.depositionPartnersEntityName,
                                           sort: nil,
                                           predicate: getPartnerPredicate(partner: depositionPartner),
                                           context: context)
        
        guard var depositionPartnerDictionary = depositionPartner.dictionary else {
            completion(.entityNotConverted)
            
            return
        }
        
        // CoreData is not supported field key name 'Description'
        if let descriptionValue = depositionPartnerDictionary[DepositionPartnersStorage.depositionPartnerBadDescriptionKey] {
            depositionPartnerDictionary.removeValue(forKey: DepositionPartnersStorage.depositionPartnerBadDescriptionKey)
            depositionPartnerDictionary[DepositionPartnersStorage.depositionPartnerDescriptionKey] = descriptionValue
        }
                
        if let oldObject = oldObjects.first {
            update(newObject: depositionPartnerDictionary, oldObject: oldObject)
        } else {
            insert(object: depositionPartnerDictionary)
        }
        
    }

    func insert(object: [String : Any]) {
        storage.insert(entityName: DepositionPartnersStorage.depositionPartnersEntityName,
                                   object: object) { [weak self] (result) in
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

    func update(newObject: [String : Any], oldObject: NSManagedObject) {
        storage.update(newObject: newObject, oldObject: oldObject) { [weak self] (error) in
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

    private func getPartnerPredicate(partner: DepositionPartnerJSON) -> NSPredicate {
        return NSPredicate(format: "name == %@", partner.name ?? "")
    }
}
