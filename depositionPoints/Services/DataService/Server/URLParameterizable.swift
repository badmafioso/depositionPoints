//
//  URLParametrable.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 14/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation

protocol URLParameterizable {
    func getParameters() -> [URLQueryItem]
}

extension URLParameterizable {
    func getParameters() -> [URLQueryItem] {
        let parameters = Mirror(reflecting: self)
        var urlQueryItems = [URLQueryItem]()
        for (name, value) in parameters.children {
            guard let name = name,
                let value = getString(from: value) else {
                continue
            }
            
            
            let queryItem = URLQueryItem(name: name, value: value)
            
            urlQueryItems.append(queryItem)
        }
        
        return urlQueryItems
    }
    
    private func getString<Value>(from value: Value) -> String? {
        if let value = value as? String {
            return value
        } else if let value = value as? Int {
            return String(value)
        } else if let value = value as? Double {
            return String(value)
        }
        
        return nil
    }
}
