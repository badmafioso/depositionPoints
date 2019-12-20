//
//  Serverable.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 14/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case HEAD
}

enum HTTPScheme: String {
    case http, https
}

enum NetworkServiceError: Error {
    case invalidURL, responseDataNotValid, lastModifiedDateNotConverted
}

protocol Serverable {
    var urlComponents: URLComponents { get }
    
    init(baseURL: String, httpScheme: HTTPScheme)
    
    func request(partOfURL: String,
                 method: HTTPMethod,
                 urlParameters: URLParameterizable?,
                 completion: @escaping (Result<Data, NetworkServiceError>) -> ())
    
    func requestLastModified(partOfURL: String,
                             urlParameters: URLParameterizable?,
                             completion: @escaping (Result<Date, NetworkServiceError>) -> ())
}
