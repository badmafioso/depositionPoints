//
//  ViewController.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 12/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import UIKit
import MapKit

final class DepositionPointsViewController: UIViewController, DepositionPointsViewing {
    var viewHasLoaded: (() -> ())?
    var viewHasAppeared: (() -> ())?
    var mapViewHasChanged: (()->())?

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var zoomInButton: UIButton!
    @IBOutlet weak var zoomOutButton: UIButton!
    @IBOutlet weak var myLocationButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self

        mapView.register(MapAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)

        zoomInButton.addTarget(self, action: #selector(zoomInTapped), for: .touchUpInside)
        zoomOutButton.addTarget(self, action: #selector(zoomOutTapped), for: .touchUpInside)
        myLocationButton.addTarget(self, action: #selector(myLocationTapped), for: .touchUpInside)
        
        if let viewHasLoaded = viewHasLoaded {
            viewHasLoaded()
        }
        
        if let mapViewHasChanged = mapViewHasChanged {
            mapViewHasChanged()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        if let viewHasAppeared = viewHasAppeared {
            viewHasAppeared()
        }
    }

    func addAnnotation(annotation: MapAnnotation) {
        mapView.addAnnotation(annotation)
    }

    func centerMap(by location: CLLocation, radius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: radius, longitudinalMeters: radius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    @objc
    func zoomInTapped() {
        var region: MKCoordinateRegion = mapView.region
        region.span.latitudeDelta /= 2.0
        region.span.longitudeDelta /= 2.0
        mapView.setRegion(region, animated: true)
    }

    @objc
    func zoomOutTapped() {
        var region: MKCoordinateRegion = mapView.region
        region.span.latitudeDelta = min(region.span.latitudeDelta * 2.0, 180.0)
        region.span.longitudeDelta = min(region.span.longitudeDelta * 2.0, 180.0)
        mapView.setRegion(region, animated: true)
    }

    @objc
    func myLocationTapped() {
        if let location = mapView.userLocation.location {
            centerMap(by: location, radius: 1000)
        }
    }
}

extension DepositionPointsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if let mapViewHasChanged = mapViewHasChanged {
            mapViewHasChanged()
        }
    }
}
