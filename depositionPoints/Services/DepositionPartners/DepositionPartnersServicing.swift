//
//  DepositionPartnersServicing.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 17/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation

protocol DepositionPartnersServicing {
    var dataService: DataServicing { get }
    var depositionPartnersStorage: DepositionPartnersStorable { get }

    init(dataService: DataServicing, depositionPartnersStorage: DepositionPartnersStorable)
    
    func loadAllPartners(partners: DepositionPartnersParameters,
                       completion: @escaping (Result<DepositionPartnersJSON, Error>) -> ())
    
    
}
