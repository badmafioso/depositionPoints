//
//  DepositionImage.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 18/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation
import CoreData.NSManagedObjectID

struct DepositionImage {
    var partnerName: String?
    var imageName: String?
    var lastModifiedDate: Date?
    var image: Data?
    var managedObjectId: NSManagedObjectID?
}
