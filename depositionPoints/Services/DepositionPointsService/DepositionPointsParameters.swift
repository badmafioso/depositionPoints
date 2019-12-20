//
//  DepositionPointsParameters.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 14/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation

struct DepositionPointsParameters: URLParameterizable {
    let latitude: Double
    let longitude: Double
    let radius: Int
    let partners: String?
}
