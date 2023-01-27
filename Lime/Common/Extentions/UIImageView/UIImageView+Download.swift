//
//  UIImageView+Download.swift
//  Lime
//
//  Created by Vadim Presnov on 27.01.2023.
//

import UIKit

extension UIImageView {
    func downloadImage(url: String?, completion: @escaping ((UIImage?) -> Void)) {
        guard let url else {
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        ServiceLocator.requestService.performRequest(url: url, method: .get) { data, response, error in
            if let data {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
