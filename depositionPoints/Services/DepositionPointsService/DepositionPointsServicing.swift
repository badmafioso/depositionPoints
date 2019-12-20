//
//  DepositionPointsServicing.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 14/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation

protocol DepositionPointsServicing {
    var dataService: DataServicing { get }

    init(dataService: DataServicing)

    func loadAllPoints(points: DepositionPointsParameters,
                       completion: @escaping (Result<DepositionPointsJSON, Error>) -> ())
    
    func insertOrUpdate(depositionPoint: DepositionPointJSON, completion: @escaping (StorableError?) -> ())
    
    func getPoints(completion: @escaping ([DepositionPoints]) -> ())
}
