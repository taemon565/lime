//
//  String+Localized.swift
//  Lime
//
//  Created by Vadim Presnov on 27.01.2023.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
