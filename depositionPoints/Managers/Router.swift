//
//  Router.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 12/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation
import UIKit

class Router {
    var navigationController: UINavigationController!
    private var dataService: DataServicing
    private var presenter: Presenting!
    
    init() {
        let imagesCache = ImageCache()
        let coreData    = CoreDataService()
        let server      = NetworkService(baseURL: "api.tinkoff.ru",
                                      httpScheme: .https)
        dataService     = DataService(storage: coreData, server: server)
    }

    func startApp(navigationController: UINavigationController) {
        self.navigationController = navigationController
        let view = ViewControllerFactory.depositionPoints.getViewController() as! DepositionPointsViewing
        
        dataService.config { [weak self] (error) in
            
            guard let strongSelf = self,
                error == nil else {
                    return
            }

            let imagesCache = ImageCache()

            let depositionPointsService   = DepositionPointsService(dataService: strongSelf.dataService)
            let depositionPartnersStorage = DepositionPartnersStorage(storage: strongSelf.dataService.storage)
            let depositionPartnersService = DepositionPartnersService(dataService: strongSelf.dataService,
                                                                      depositionPartnersStorage: depositionPartnersStorage)
            
            let server                  = NetworkService(baseURL: "static.tinkoff.ru", httpScheme: .https)
            let depositionImagesStorage = DepositionImagesStorage(storage: strongSelf.dataService.storage)

            let depositionImagesService = DepositionImagesService(server: server,
                                                                  depositionImagesStorage: depositionImagesStorage,
                                                                  imagesCache: imagesCache)
            
            strongSelf.presenter = DepositionPointsPresenter(depositionPointsService: depositionPointsService,
                                                             depositionPartnersService: depositionPartnersService,
                                                             depositionImagesService: depositionImagesService, imagesCache: imagesCache,
                                                             depositionPointsView: view)
            
            strongSelf.push(view: view)
        }
    }

    func push(view: UIViewController) {
        navigationController.pushViewController(view, animated: true)
    }
}

extension Router {
    enum ViewControllerFactory: String {
        case undefined = ""
        case depositionPoints = "DepositionPoints"
        
        func getViewController() -> UIViewController {
            let viewControllerStoryboard = UIStoryboard(name: self.rawValue, bundle: nil)
            return viewControllerStoryboard.instantiateViewController(withIdentifier: self.rawValue)
        }
    }
}
