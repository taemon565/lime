//
//  FeedService.swift
//  Lime
//
//  Created by Vadim Presnov on 27.01.2023.
//

import Foundation

protocol FeedService {
    func downloadFeeds(completion: @escaping (ChannelsData?, Bool, String?) -> Void)
}
