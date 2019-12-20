//
//  DepositionImagesServicing.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 18/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation
import UIKit.UIImage

protocol DepositionImagesServicing {
    var server: Serverable { get }
    var storage: DepositionImagesStorable { get }
    var imagesCache: ImagesCaching { get }

    init(server: Serverable,
         depositionImagesStorage: DepositionImagesStorable,
         imagesCache: ImagesCaching)
    
    func loadPartnerImage(imageName: String,
                          partnerName: String,
                          dpi: String,
                          completion: @escaping (Result<UIImage, Error>) -> ())
    
    func loadAllIcons(partners: [DepositionPartnerJSON], completion: @escaping (Error?) -> ())
    
}
