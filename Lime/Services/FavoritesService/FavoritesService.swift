//
//  FavoritesService.swift
//  Lime
//
//  Created by Vadim Presnov on 28.01.2023.
//

import Foundation

protocol FavoritesService {
    func removeFavorite(_ channelID: Int)
    func isFavorite(_ channelID: Int) -> Bool
    func setFavorite(_ channelID: Int)
}
