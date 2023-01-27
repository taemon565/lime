//
//  FeedTableViewDataSource.swift
//  Lime
//
//  Created by Vadim Presnov on 27.01.2023.
//

import UIKit

final class FeedTableViewDataSource: NSObject {
    // MARK: - Properties
    private var models: [ChannelsData.Channel] = []
    
    var didSelectChannel: ((ChannelsData.Channel) -> Void)?
    
    // MARK: - Functions
    func update(with models: [ChannelsData.Channel]) {
        self.models = models
    }
    
    // MARK: - Private
    private func models(for tab: Tabs) -> [ChannelsData.Channel] {
        switch tab {
        case .all:
            return models
        case .favorites:
            return models.filter{ ServiceLocator.favoritesService.isFavorite($0.id ?? 0) }
        }
    }
}

// MARK: - UITableViewDelegate
extension FeedTableViewDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tab = Tabs(rawValue: tableView.tag) else { return }
        didSelectChannel?(models(for: tab)[indexPath.row])
    }
}

// MARK: - UITableViewDataSource
extension FeedTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tab = Tabs(rawValue: tableView.tag) else { return 0 }
        return models(for: tab).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: ChannelCell.self)
            ) as? ChannelCell,
            let tab = Tabs(rawValue: tableView.tag)
        else { return UITableViewCell() }
        cell.configure(with: models(for: tab)[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        84
    }
}
