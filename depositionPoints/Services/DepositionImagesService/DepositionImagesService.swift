//
//  DepositionImagesService.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 18/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation
import UIKit.UIImage

extension DepositionImagesService {
    enum ServiceError: Error {
        case parentControllerNotExist
        case imageHasNotConvertedFromData
        case localImageNotFound
        case localImageNotCorrected
    }
}

final class DepositionImagesService: DepositionImagesServicing {
    var server: Serverable
    var storage: DepositionImagesStorable
    var imagesCache: ImagesCaching
    var loadIconsQueue = DispatchQueue.global(qos: .utility)
    
    init(server: Serverable,
         depositionImagesStorage: DepositionImagesStorable,
         imagesCache: ImagesCaching) {
        self.server      = server
        self.storage     = depositionImagesStorage
        self.imagesCache = imagesCache
    }
    
    func loadPartnerImage(imageName: String,
                          partnerName: String,
                          dpi: String,
                          completion: @escaping (Result<UIImage, Error>) -> ()) {

        let partOfURL   = DepositionPointsService.depositionImagePartOfURLString
        let partWithDPI = partOfURL.replacingOccurrences(of: DepositionPointsService.dpiPatternString, with: dpi)
        let imagePath   = partWithDPI + imageName
        
        checkLocalImage(partnerName: partnerName, imagePath: imagePath) { [weak self] (result) in
            switch result {
            case .success(let image):
                completion(.success(image))
            case .failure(_):
                self?.loadImage(imagePath: imagePath,
                                partnerName: partnerName,
                                imageName: imageName,
                                completion: { (result) in
                                    switch result {
                                    case .success(let image):
                                        completion(.success(image))
                                    case .failure(let error):
                                        completion(.failure(error))
                                    }
                })
            }
        }
    }
    
    private func checkLocalImage(partnerName: String,
                                 imagePath: String,
                                 completion: @escaping (Result<UIImage, Error>) -> ()) {
        
        guard let partnerImage = storage.getImage(partnerName: partnerName) else {
            completion(.failure(ServiceError.localImageNotFound))
            
            return
        }
        
        server.requestLastModified(partOfURL: imagePath, urlParameters: nil) { (result) in
            switch result {
            case .success(let remoteImageDate):
                guard let localImageDate = partnerImage.lastModifiedDate,
                    localImageDate > remoteImageDate,
                    let imageData = partnerImage.image,
                    let image = UIImage(data: imageData) else {
                
                        completion(.failure(ServiceError.localImageNotCorrected))
                        
                    return
                }
                
                print("Image loaded from cache")
                
                completion(.success(image))
                
                return
            case .failure(let error):
                print("\(error)")
                
                guard let imageData = partnerImage.image,
                    let image = UIImage(data: imageData) else {
                    
                    completion(.failure(ServiceError.localImageNotCorrected))
                    
                    return
                }

                completion(.success(image))
            }
        }
    }
    
    private func loadImage(imagePath: String,
                           partnerName: String,
                           imageName: String,
                           completion: @escaping (Result<UIImage, Error>) -> ()) {

        server.request(partOfURL: imagePath,
                       method: .GET,
                       urlParameters: nil) { [weak self] (result) in
            guard let strongSelf = self else {
                completion(.failure(ServiceError.parentControllerNotExist))
                
                return
            }
                            
            switch result {
            case .success(let responseData):
                guard let image = UIImage(data: responseData) else {
                    completion(.failure(ServiceError.imageHasNotConvertedFromData))
                    
                    return
                }

                let localModifiedDate = Date()
                let depositionImage = DepositionImage(partnerName: partnerName,
                                                      imageName: imageName,
                                                      lastModifiedDate: localModifiedDate,
                                                      image:responseData)
                
                strongSelf.storage.insertOrUpdate(depositionImage: depositionImage) { (error) in
                    
                }
                
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadAllIcons(partners: [DepositionPartnerJSON], completion: @escaping (Error?) -> ()) {
        let iconsGroup = DispatchGroup()
        for partner in partners {
            iconsGroup.enter()
            loadIconsQueue.async { [weak self] in
                guard let imageName = partner.picture,
                    let partnerName = partner.id else {
                        
                        iconsGroup.leave()
                        
                    return
                }

                let dpi = UIDevice().getHDPISize()
                self?.loadPartnerImage(imageName: imageName,
                                 partnerName: partnerName,
                                 dpi: dpi,
                                 completion: { (result) in
                    switch result {
                    case .success(let image):
                        self?.imagesCache.cache(name: partnerName, image: image)
                        print("image loaded \(partnerName)")
                    case .failure(let error):
                        print(error)
                    }
                    
                    iconsGroup.leave()
                })
            }
        }
        
        iconsGroup.notify(queue: DispatchQueue.main) {
            completion(nil)
        }
    }
}
