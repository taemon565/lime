//
//  FeedViewController.swift
//  Lime
//
//  Created by Vadim Presnov on 27.01.2023.
//

import UIKit

final class FeedViewController: UIViewController {
    // MARK: - Properties
    private let customView = FeedView()
    private let feedService: FeedService
    private let favoritesService: FavoritesService
    private let feedCollectionViewDataSource: FeedCollectionDataSource
    
    private var channels: [ChannelsData.Channel] = []
    
    // MARK: - Life cycle
    init(
        feedService: FeedService = ServiceLocator.feedService,
        favoritesService: FavoritesService = ServiceLocator.favoritesService,
        feedCollectionViewDataSource: FeedCollectionDataSource = FeedCollectionDataSource()
    ) {
        self.feedService = feedService
        self.favoritesService = favoritesService
        self.feedCollectionViewDataSource = feedCollectionViewDataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupObservers()
        downloadFeeds()
    }
    
    // MARK: - Private
    private func setupDelegates() {
        customView.collectionView.delegate = feedCollectionViewDataSource
        customView.collectionView.dataSource = feedCollectionViewDataSource
        feedCollectionViewDataSource.delegateDidScroll = customView.headerView.tabsView
        customView.headerView.tabsView.tabsDelegate = self
        customView.headerView.searchBar.delegate = self
    }
    
    private func setupObservers() {
        feedCollectionViewDataSource.didSelectChannel = { [weak self] channel in
            guard let self, let channelID = channel.id else { return }
            if self.favoritesService.isFavorite(channelID) {
                self.favoritesService.removeFavorite(channelID)
            } else {
                self.favoritesService.setFavorite(channelID)
            }
            self.customView.collectionView.reloadData()
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientationDidChange(_:)),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }
    
    @objc private func orientationDidChange(_ notification: Notification) {
        customView.collectionView.reloadData()
    }
}

// MARK: - API
extension FeedViewController {
    private func downloadFeeds() {
        feedService.downloadFeeds { [weak self] channelsData, success, error in
            if success, let channels = channelsData?.channels {
                self?.channels = channels
                self?.feedCollectionViewDataSource.update(with: channels)
                self?.customView.collectionView.reloadData()
            } else {
                print("Ошибка при скачивании фидов \(error ?? "")")
            }
        }
    }
}

// MARK: - Tabs Scroll Delegate
extension FeedViewController: TabsScrollDelegate {
    func didIndexChanged(at index: Int, animated: Bool) {
        customView.collectionView.isPagingEnabled = false
        customView.collectionView.scrollToItem(at: [0, index], at: .left, animated: animated)
        customView.collectionView.isPagingEnabled = true
    }
}

// MARK: - SearchBar Delegate
extension FeedViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        term(text: searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        UIView.animate(withDuration: 0.2) {
            self.customView.layoutIfNeeded()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        UIView.animate(withDuration: 0.2) {
            self.customView.layoutIfNeeded()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        term(text: "")
        searchBar.resignFirstResponder()
    }
    
    private func term(text: String) {
        if text.isEmpty {
            feedCollectionViewDataSource.update(with: channels)
        } else {
            feedCollectionViewDataSource.update(with: channels.filter { $0.nameRu?.lowercased().contains(text.lowercased()) == true })
        }
        customView.collectionView.reloadData()
    }
}
