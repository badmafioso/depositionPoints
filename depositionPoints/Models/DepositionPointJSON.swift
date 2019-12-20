//
//  DepositionPoint.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 14/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation

struct DepositionPointJSON: Codable {
    var partnerName: String?
    var location: LocationJSON
    var workHours: String?
    var phones: String?
    var addressInfo: String?
    var fullAddress: String?
}
