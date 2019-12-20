//
//  MapAnnotation.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 20.12.2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation
import MapKit
import UIKit.UIImage

final class MapAnnotation: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    var image: UIImage?
    let coordinate: CLLocationCoordinate2D
    var subtitle: String? {
        locationName
    }

    init(title: String, locationName: String, image: UIImage?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.image = image
        self.coordinate = coordinate

        super.init()
    }

    init?(point: DepositionPoints) {
        guard point.latitude != 0,
            point.longitude != 0 else {
            return nil
        }

        self.title = point.partnerName ?? "Title not found"
        self.locationName = point.addressInfo ?? "Location name not found"
        self.coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
        self.image = nil

        super.init()
    }
}
