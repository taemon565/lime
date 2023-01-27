//
//  FeedServiceImplementation.swift
//  Lime
//
//  Created by Vadim Presnov on 27.01.2023.
//

import Foundation

final class FeedServiceImplementation {
    // MARK: - Properties
    private let requestService: RequestService
    
    // MARK: - Life cycle
    init(requestService: RequestService) {
        self.requestService = requestService
    }
}

// MARK: - Feed Service
extension FeedServiceImplementation: FeedService {
    func downloadFeeds(completion: @escaping (ChannelsData?, Bool, String?) -> Void) {
        requestService.performRequest(.feed) { data, response, error in
            if error == nil {
                if let data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let channels = try decoder.decode(ChannelsData.self, from: data)
                        DispatchQueue.main.async {
                            completion(channels, true, nil)
                        }
                    } catch let error {
                        DispatchQueue.main.async {
                            completion(nil, false, error.localizedDescription)
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil, false, error?.localizedDescription)
                }
            }
        }
    }
}
