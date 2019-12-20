//
//  DepositionPartnersStorable.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 17/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation

protocol DepositionPartnersStorable {
    var storage: Storable { get }
    
    init(storage: Storable)
    
    func insertOrUpdate(depositionPartner: DepositionPartnerJSON, completion: @escaping (StorableError?) -> ())
}
