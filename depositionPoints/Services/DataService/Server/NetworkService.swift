//
//  NetworkService.swift
//  depositionPoints
//
//  Created by Sergey Frolov on 14/12/2019.
//  Copyright © 2019 SmartCapitan. All rights reserved.
//

import Foundation

final class NetworkService: Serverable {
    private(set) var urlComponents: URLComponents
    private var urlSession = URLSession.shared
    
    init(baseURL: String, httpScheme: HTTPScheme) {
        urlComponents = URLComponents()
        urlComponents.host   = baseURL
        urlComponents.scheme = httpScheme.rawValue
    }
    
    func request(partOfURL: String,
                 method: HTTPMethod,
                 urlParameters: URLParameterizable?,
                 completion: @escaping (Result<Data, NetworkServiceError>) -> ()) {
        
        if let urlParameters = urlParameters {
            urlComponents.queryItems = urlParameters.getParameters()
        }
        urlComponents.path = partOfURL
        
        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL))
            
            return
        }
        
        urlSession.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                (200 ..< 300) ~= response.statusCode,
                error == nil else {
                    completion(.failure(.responseDataNotValid))
                    
                    return
            }
            
            completion(.success(data))
        }).resume()
    }
    
    func requestLastModified(partOfURL: String,
                             urlParameters: URLParameterizable?,
                             completion: @escaping (Result<Date, NetworkServiceError>) -> ()) {
        
        if let urlParameters = urlParameters {
            urlComponents.queryItems = urlParameters.getParameters()
        }
        urlComponents.path = partOfURL
        
        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL))
            
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.HEAD.rawValue
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard data != nil,
                let response = response as? HTTPURLResponse,
                (200 ..< 300) ~= response.statusCode,
                error == nil else {
                    completion(.failure(.responseDataNotValid))
                    
                    return
            }
            
            let lastModifiedDate = response.allHeaderFields["Last-Modified"] as! String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EE, dd LLL yyyy HH:mm:ss zzz"
            dateFormatter.locale = Locale(identifier: "en")
            let serverDate = dateFormatter.date(from: lastModifiedDate) as NSDate?
            
            if let serverDate = serverDate {
                completion(.success(serverDate as Date))
                
                return
            }
            
            completion(.failure(.lastModifiedDateNotConverted))
            
            return
        }
        
        task.resume()
    }
}
