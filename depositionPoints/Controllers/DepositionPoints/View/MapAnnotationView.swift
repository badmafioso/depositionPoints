//
//  MapAnnotationView.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 20.12.2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation
import MapKit

class MapAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let mapAnnotation = newValue as? MapAnnotation else {
                return
            }
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

            image = mapAnnotation.image?.resizeImage(size: CGSize(width: 50.0, height: 50.0))
        }
    }
}
