//
//  DataServicing.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 14/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation

protocol DataServicing {
    var storage: Storable { get }
    var server: Serverable { get }
    
    init(storage: Storable, server: Serverable)
    
    func config(completion: @escaping (Error?) -> ())
}
