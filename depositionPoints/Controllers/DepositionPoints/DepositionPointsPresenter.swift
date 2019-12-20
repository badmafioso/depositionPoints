//
//  DepositionPointsPresenter.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 14/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation
import MapKit

final class DepositionPointsPresenter: DepositionPointsPresenting {
    private(set) var depositionPointsService: DepositionPointsServicing
    private(set) var depositionPartnersService: DepositionPartnersServicing
    private(set) var depositionImagesService: DepositionImagesServicing
    private(set) var imagesCache: ImagesCaching
    var depositionPointsView: DepositionPointsViewing

    private var locationManager = CLLocationManager()

    init(depositionPointsService: DepositionPointsServicing,
         depositionPartnersService: DepositionPartnersServicing,
         depositionImagesService: DepositionImagesServicing,
         imagesCache: ImagesCaching,
         depositionPointsView: DepositionPointsViewing) {
        self.depositionPointsService   = depositionPointsService
        self.depositionPartnersService = depositionPartnersService
        self.depositionImagesService   = depositionImagesService
        self.imagesCache               = imagesCache
        self.depositionPointsView      = depositionPointsView

        depositionPointsView.viewHasLoaded = { [weak self] in
            self?.loadPartners {
                self?.loadPointsByMapCoordinates {
                    
                }
            }
        }

        depositionPointsView.viewHasAppeared = { [weak self] in
            self?.checkLocationAuthorizationStatus()
        }
        
        depositionPointsView.mapViewHasChanged = { [weak self] in
            self?.loadPointsByMapCoordinates {
                
            }
        }
        
        depositionPointsView.view.backgroundColor = .white
    }
    
    func loadPointsByMapCoordinates(completion: @escaping () -> ()) {
        loadPoints { [weak self] in
            self?.depositionPointsService.getPoints(completion: { (points) in
                for point in points {
                    let partnerName = point.partnerName ?? "No_name"
                    print(partnerName)

                    if let annotation = MapAnnotation(point: point) {
                        annotation.image = self?.imagesCache.get(imageName: partnerName)
                        self?.depositionPointsView.addAnnotation(annotation: annotation)
                    }
                }
                
                print("New points has loaded")
            })
        }
    }

    func loadPoints(completion: @escaping () -> ()) {
        let coordinate = depositionPointsView.mapView.centerCoordinate
        let depositionPoints = DepositionPointsParameters(latitude: coordinate.latitude,
                                                      longitude: coordinate.longitude,
                                                      radius: 1000,
                                                      partners: nil)


        depositionPointsService.loadAllPoints(points: depositionPoints) { (result) in
            switch result {
            case .success(_):
                completion()
            case .failure(let error):
                print(error)
                completion()
            }
        }
    }
    
    func loadPartners(completion: @escaping () -> ()) {
        let depositionPartners = DepositionPartnersParameters(accountType: "Credit")
        depositionPartnersService.loadAllPartners(partners: depositionPartners) { [weak self] (result) in
            switch result {
            case .success(let partners):
                print("Partners has loaded")
                
                self?.depositionImagesService.loadAllIcons(partners: partners.payload, completion: { (error) in
                    completion()
                })
            case .failure(let error):
                print(error)
                
                completion()
            }
        }
    }

    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            depositionPointsView.mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}
