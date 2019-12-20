//
//  DepositionPointsService+URLParts.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 17/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation

extension DepositionPointsService {
    static let dpiPatternString = "{dpi}"
    static let depositionImagePartOfURLString = "/icons/deposition-partners-v3/" + DepositionPointsService.dpiPatternString + "/"
    
    enum DepositionURLParts: String {
        case depositionPoints   = "/v1/deposition_points"
        case depositionPartners = "/v1/deposition_partners"
    }
}
