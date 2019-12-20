//
//  DepositionPartners+CoreDataProperties.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 19/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//
//

import Foundation
import CoreData


extension DepositionPartners {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DepositionPartners> {
        return NSFetchRequest<DepositionPartners>(entityName: "DepositionPartners")
    }

    @NSManaged public var depositionDuration: String?
    @NSManaged public var hasLocations: Bool
    @NSManaged public var id: String?
    @NSManaged public var isMomentary: Bool
    @NSManaged public var limitations: String?
    @NSManaged public var name: String?
    @NSManaged public var partnerDescription: String?
    @NSManaged public var picture: String?
    @NSManaged public var url: String?

}
