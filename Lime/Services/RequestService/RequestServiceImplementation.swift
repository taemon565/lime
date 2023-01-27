//
//  RequestServiceImplementation.swift
//  Lime
//
//  Created by Vadim Presnov on 27.01.2023.
//

import Foundation

final class RequestServiceImplementation {}

// MARK: - Request Service
extension RequestServiceImplementation: RequestService {
    func performRequest(_ route: EndPoints, completion: @escaping Response) {
        guard let request = route.asURLRequest() else { return }
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
    
    func performRequest(url: String, method: HTTPMethod, completion: @escaping Response) {
        guard let url = URL(string: url) else {
            completion(nil, nil, nil)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
}
