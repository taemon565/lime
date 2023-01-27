//
//  UIImage+Assets.swift
//  Lime
//
//  Created by Vadim Presnov on 27.01.2023.
//

import UIKit

enum Asset {
    case shape
    case star
    case activeStar
    
    var imageName: String {
        switch self {
        case .shape: return "shape"
        case .star: return "star"
        case .activeStar: return "activeStar"
        }
    }
}

extension UIImage {
    convenience init?(_ asset: Asset) {
        self.init(named: asset.imageName)
    }
}

extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }

        do {
            self.init(data: try Data(contentsOf: url))
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}
