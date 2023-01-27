//
//  ChannelsData.swift
//  Lime
//
//  Created by Vadim Presnov on 27.01.2023.
//

import Foundation

struct ChannelsData: Decodable {
    let channels: [Channel]?
    
    struct Channel: Decodable {
        let id: Int?
        let nameRu: String?
        let image: String?
        let current: Telecast?
        
        struct Telecast: Decodable {
            let title: String?
        }
    }
}
