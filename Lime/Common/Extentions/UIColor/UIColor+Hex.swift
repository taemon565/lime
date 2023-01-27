//
//  UIColor+Hex.swift
//  Lime
//
//  Created by Vadim Presnov on 27.01.2023.
//

import UIKit

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1) {
        guard hexString.count == 6, let hex = Int(hexString, radix: 16) else {
            self.init(white: 1, alpha: 1)
            return
        }
        self.init(hex: hex, alpha: alpha)
    }
    
    convenience init(hex: Int, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((hex >> 16) & 0xff) / 255.0,
            green: CGFloat((hex >> 8) & 0xff) / 255.0,
            blue: CGFloat(hex & 0xff) / 255.0,
            alpha: alpha
        )
    }
}
