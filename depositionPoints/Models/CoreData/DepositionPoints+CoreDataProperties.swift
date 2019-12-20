//
//  DepositionPoints+CoreDataProperties.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 19/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//
//

import Foundation
import CoreData


extension DepositionPoints {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DepositionPoints> {
        return NSFetchRequest<DepositionPoints>(entityName: "DepositionPoints")
    }

    @NSManaged public var addressInfo: String?
    @NSManaged public var fullAddress: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var partnerName: String?
    @NSManaged public var phones: String?
    @NSManaged public var workHours: String?

}
