//
//  DepositionPartnerJSON.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 17/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation

struct DepositionPartnerJSON: Codable {
    var id: String?
    var name: String?
    var picture: String?
    var url: String?
    var hasLocations: Bool?
    var isMomentary: Bool?
    var depositionDuration: String?
    var limitations: String?
    var description: String?
}
