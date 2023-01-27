//
//  UserDefaultsService.swift
//  Lime
//
//  Created by Vadim Presnov on 28.01.2023.
//

import Foundation

protocol UserDefaultsService {
    func set(to value: Any, forKey: UserDefaultsKeys)
    func get(forKey: UserDefaultsKeys) -> Any?
    func remove(forKey: UserDefaultsKeys)
}
