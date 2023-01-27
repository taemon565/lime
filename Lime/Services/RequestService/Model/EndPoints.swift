//
//  EndPoints.swift
//  Lime
//
//  Created by Vadim Presnov on 27.01.2023.
//

import Foundation

enum EndPoints: APIConfiguration {
    case feed
    
    var method: HTTPMethod {
        switch self {
        case .feed:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .feed:
            return "/playlist/channels.json"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .feed:
            return .url([:])
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .feed:
            return [:]
        }
    }
    
    func asURLRequest() -> URLRequest? {
        guard let url = URL(string: Network.baseURL) else {
            print("### ERROR: invalid base url")
            return nil
        }
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        /// Parameters
        switch parameters {
        case .body(let params):
            guard
                let httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            else {
                print("### ERROR: invalid http body for \(urlRequest.url?.absoluteString ?? "")")
                return nil
            }
            urlRequest.httpBody = httpBody
        case .url(let params):
            let queryParams = params.map { pair  in
                return URLQueryItem(name: pair.key, value: "\(pair.value)")
            }
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            urlRequest.url = components?.url
        }
        
        /// Headers
        headers.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        return urlRequest
    }
}
