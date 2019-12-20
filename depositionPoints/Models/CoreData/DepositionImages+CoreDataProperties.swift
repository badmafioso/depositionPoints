//
//  DepositionImages+CoreDataProperties.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 19/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//
//

import Foundation
import CoreData


extension DepositionImages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DepositionImages> {
        return NSFetchRequest<DepositionImages>(entityName: "DepositionImages")
    }

    @NSManaged public var imageName: String?
    @NSManaged public var lastModifiedDate: Date?
    @NSManaged public var partnerName: String?
    @NSManaged public var image: Data?

}
