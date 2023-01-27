//
//  APIConfiguration.swift
//  Lime
//
//  Created by Vadim Presnov on 27.01.2023.
//

import Foundation

protocol APIConfiguration {
    typealias HTTPHeaders = [String: String]
    
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: RequestParams { get }
    var headers: HTTPHeaders { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}

enum RequestParams {
    typealias Parameters = [String: Any]
    
    case body(Parameters)
    case url(Parameters)
}

enum Network {
    static let baseURL = "http://limehd.online"
}
