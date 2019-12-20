//
//  DepositionPointsService.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 14/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation

extension DepositionPointsService {
    enum ServiceError: Error {
        case parentControllerNotExist
    }
}

final class DepositionPointsService: DepositionPointsServicing {
    private static let depositionPointEntityName = "DepositionPoints"
    private static let depositionPointLocationKey = "location"
    
    private(set) var dataService: DataServicing

    init(dataService: DataServicing) {
        self.dataService = dataService
    }

    func loadAllPoints(points: DepositionPointsParameters,
                       completion: @escaping (Result<DepositionPointsJSON, Error>) -> ()) {
        
        dataService.server.request(partOfURL: DepositionURLParts.depositionPoints.rawValue,
                                   method: .GET,
                                   urlParameters: points) { [weak self] (result) in
            
            guard let strongSelf = self else {
                completion(.failure(ServiceError.parentControllerNotExist))
                
                return
            }
                            
            switch result {
            case .success(let responseData):
                let depositionPoints = try! JSONDecoder().decode(DepositionPointsJSON.self, from: responseData)
                
                for depositionPoint in depositionPoints.payload {
                    strongSelf.insertOrUpdate(depositionPoint: depositionPoint) { (error) in
                        
                    }
                }
                
                completion(.success(depositionPoints))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func insertOrUpdate(depositionPoint: DepositionPointJSON, completion: @escaping (StorableError?) -> ()) {
        guard let depositionPointDictionary = convert(depositionPoint: depositionPoint) else {
            completion(.entityNotConverted)
            
            return
        }
        
        let context = dataService.storage.getCurrentThreadContext()
        let oldObjects = dataService.storage.getObject(from: DepositionPointsService.depositionPointEntityName,
                                                       sort: nil,
                                                       predicate: getPointPredicate(location: depositionPoint.location),
                                                       context: context)
        
        if let oldObject = oldObjects.first {
            dataService.storage.update(newObject: depositionPointDictionary, oldObject: oldObject) { (error) in
                if error == nil {
                    print("Deposition point has updated in Core Data")
                    
                    completion(nil)
                } else {
                    completion(.objectNotUpdated)
                }
                
                return
            }
        } else {
            dataService.storage.insert(entityName: DepositionPointsService.depositionPointEntityName,
                                       object: depositionPointDictionary) { (result) in
                switch result {
                case .success(_):
                    print("Object has inserted")
                    
                    completion(nil)
                case .failure(let error):
                    print("Object hasn't inserted")
                    
                    completion(error)
                }
                                        
                return
            }
        }
    }
    
    func convert(depositionPoint: DepositionPointJSON) -> [String : Any]? {
        guard let dictionary = depositionPoint.dictionary,
            let location = depositionPoint.location.dictionary else {
            return nil
        }
        
        var mergedDictionary = dictionary.merging(location) { (first, _) in
            first
        }
        
        
        mergedDictionary.removeValue(forKey: DepositionPointsService.depositionPointLocationKey)

        return mergedDictionary
    }
    
    private func getPointPredicate(location: LocationJSON) -> NSPredicate {
        let latitude = NSPredicate(format: "latitude == %@", (location.latitude ?? 0.0) as NSNumber)
        let longitude = NSPredicate(format: "longitude == %@", (location.longitude ?? 0.0) as NSNumber)
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: [latitude, longitude])
    }
    
    func getPoints(completion: @escaping ([DepositionPoints]) -> ()) {
        let context = dataService.storage.getCurrentThreadContext()
        let points = dataService.storage.getObject(from: DepositionPointsService.depositionPointEntityName,
                                                   sort: nil,
                                                   predicate: nil,
                                                   context: context)
        
        if let points = points as? [DepositionPoints] {
            completion(points)
        } else {
            completion([DepositionPoints]())
        }
    }
}
