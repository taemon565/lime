//
//  UserDefaultsServiceImplementation.swift
//  Lime
//
//  Created by Vadim Presnov on 28.01.2023.
//

import Foundation

final class UserDefaultsServiceImplementation {
    // MARK: - Properties
    private let userDefaults = UserDefaults.standard
}

// MARK: - UserDefaultService
extension UserDefaultsServiceImplementation: UserDefaultsService {
    func set<T>(to value: T, forKey: UserDefaultsKeys) {
        userDefaults.setValue(value, forKey: forKey.rawValue)
    }
    
    func get<T>(forKey: UserDefaultsKeys) -> T? {
        userDefaults.object(forKey: forKey.rawValue) as? T
    }
    
    func remove(forKey: UserDefaultsKeys) {
        userDefaults.removeObject(forKey: forKey.rawValue)
    }
}
