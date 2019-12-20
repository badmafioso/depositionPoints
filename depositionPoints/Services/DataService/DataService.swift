//
//  DataService.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 14/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation

final class DataService: DataServicing {
    var storage: Storable
    var server: Serverable
    
    init(storage: Storable, server: Serverable) {
        self.storage = storage
        self.server  = server
    }
    
    func config(completion: @escaping (Error?) -> ()) {
        storage.config { (error) in
            completion(error)
        }
    }
}
