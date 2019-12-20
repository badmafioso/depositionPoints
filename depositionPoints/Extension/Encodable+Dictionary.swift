//
//  Encodable+Dictionary.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 15/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation

extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}
