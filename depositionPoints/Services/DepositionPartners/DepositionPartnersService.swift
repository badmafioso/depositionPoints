//
//  DepositionPartnersService.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 17/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation

extension DepositionPartnersService {
    enum ServiceError: Error {
        case parentControllerNotExist
    }
}

final class DepositionPartnersService: DepositionPartnersServicing {
    var dataService: DataServicing
    var depositionPartnersStorage: DepositionPartnersStorable
    
    init(dataService: DataServicing, depositionPartnersStorage: DepositionPartnersStorable) {
        self.dataService = dataService
        self.depositionPartnersStorage = depositionPartnersStorage
    }
    
    func loadAllPartners(partners: DepositionPartnersParameters, completion: @escaping (Result<DepositionPartnersJSON, Error>) -> ()) {
        
        dataService.server.request(partOfURL: DepositionPointsService.DepositionURLParts.depositionPartners.rawValue,
                                   method: .GET,
                                   urlParameters: partners) { [weak self] (result) in
            guard let strongSelf = self else {
                completion(.failure(ServiceError.parentControllerNotExist))
                
                return
            }
                            
            switch result {
            case .success(let responseData):
                let depositionPartners = try! JSONDecoder().decode(DepositionPartnersJSON.self, from: responseData)
                
                for depositionPartner in depositionPartners.payload {
                    strongSelf.depositionPartnersStorage.insertOrUpdate(depositionPartner: depositionPartner) { (error) in
                        
                    }
                }
                
                completion(.success(depositionPartners))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
