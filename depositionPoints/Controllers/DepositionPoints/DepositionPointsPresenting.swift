//
//  DepositionPointsPresenting.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 14/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation

protocol DepositionPointsPresenting: Presenting {
    var depositionPointsService: DepositionPointsServicing { get }
    var depositionPartnersService: DepositionPartnersServicing { get }
    var depositionImagesService: DepositionImagesServicing { get }
    var imagesCache: ImagesCaching { get }

    init(depositionPointsService: DepositionPointsServicing,
         depositionPartnersService: DepositionPartnersServicing,
         depositionImagesService: DepositionImagesServicing,
         imagesCache: ImagesCaching,
         depositionPointsView: DepositionPointsViewing)

    func loadPoints(completion: @escaping () -> ())
    func loadPartners(completion: @escaping () -> ())
    func checkLocationAuthorizationStatus()
}
