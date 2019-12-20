//
//  DepositionImagesStorable.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 18/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation
import CoreData.NSManagedObject

protocol DepositionImagesStorable {
    var storage: Storable { get }
    
    init(storage: Storable)
    
    func insertOrUpdate(depositionImage: DepositionImage, completion: @escaping (StorableError?) -> ())
    func getImage(partnerName: String) -> DepositionImage?
}
