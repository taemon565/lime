//
//  RequestService.swift
//  Lime
//
//  Created by Vadim Presnov on 27.01.2023.
//

import Foundation

protocol RequestService {
    typealias Response = ((_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void)
    
    func performRequest(_ route: EndPoints, completion: @escaping Response)
    func performRequest(url: String, method: HTTPMethod, completion: @escaping Response)
}
