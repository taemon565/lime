//
//  Tab.swift
//  Lime
//
//  Created by Vadim Presnov on 27.01.2023.
//

import Foundation

enum Tabs: Int, CaseIterable {
    case all
    case favorites
    
    var description: String {
        switch self {
        case .all: return "Tab.All".localized
        case .favorites: return "Tab.Favorites".localized
        }
    }
}
