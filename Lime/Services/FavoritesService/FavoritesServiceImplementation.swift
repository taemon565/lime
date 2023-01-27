//
//  FavoritesServiceImplementation.swift
//  Lime
//
//  Created by Vadim Presnov on 28.01.2023.
//

import Foundation

final class FavoritesServiceImplementation {
    // MARK: - Properties
    private let userDefaults: UserDefaultsService
    private var favorites: Set<Int> = []
    
    // MARK: - Life cycle
    init(userDefaults: UserDefaultsService) {
        self.userDefaults = userDefaults
        getSavedFavorites()
    }
    
    // MARK: - Functions
    
    // MARK: - Helpers
    private func getSavedFavorites() {
        if let favorites = userDefaults.get(forKey: .allFavoritesChannel) as? [Int] {
            self.favorites = Set(favorites)
        }
    }
}

extension FavoritesServiceImplementation: FavoritesService {
    func removeFavorite(_ channelID: Int) {
        favorites.remove(channelID)
        userDefaults.set(to: Array(favorites), forKey: .allFavoritesChannel)
    }
    
    func isFavorite(_ channelID: Int) -> Bool {
        favorites.contains(channelID)
    }
    
    func setFavorite(_ channelID: Int) {
        favorites.insert(channelID)
        userDefaults.set(to: Array(favorites), forKey: .allFavoritesChannel)
    }
}
