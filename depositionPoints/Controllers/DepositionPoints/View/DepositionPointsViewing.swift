//
//  DepositionPointsViewing.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 14/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation
import UIKit
import MapKit

protocol DepositionPointsViewing: UIViewController {
    var viewHasLoaded: (()->())? { get set }
    var viewHasAppeared: (()->())? { get set }
    
    var mapViewHasChanged: (()->())? { get set }
    var mapView: MKMapView! { get set }

    func addAnnotation(annotation: MapAnnotation)
}
