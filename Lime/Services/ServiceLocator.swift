//
//  ServiceLocator.swift
//  Lime
//
//  Created by Vadim Presnov on 27.01.2023.
//

import Foundation

enum ServiceLocator {
    static let requestService: RequestService = {
        RequestServiceImplementation()
    }()
    
    static let feedService: FeedService = {
       FeedServiceImplementation(requestService: requestService)
    }()
    
    static let userDefaultsService: UserDefaultsService = {
        UserDefaultsServiceImplementation()
    }()
    
    static let favoritesService: FavoritesService = {
       FavoritesServiceImplementation(userDefaults: userDefaultsService)
    }()
}
