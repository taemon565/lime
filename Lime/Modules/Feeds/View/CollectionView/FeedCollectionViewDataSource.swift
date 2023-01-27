//
//  FeedCollectionViewDataSource.swift
//  Lime
//
//  Created by Vadim Presnov on 28.01.2023.
//

import UIKit

final class FeedCollectionDataSource: NSObject {
    // MARK: - Properties
    weak var delegateDidScroll: CollectionDidScrollDelegate?
    private let feedTableViewDataSource: FeedTableViewDataSource
    
    var didSelectChannel: ((ChannelsData.Channel) -> Void)? {
        didSet {
            feedTableViewDataSource.didSelectChannel = didSelectChannel
        }
    }
    
    // MARK: - Life cycle
    init(
        feedTableViewDataSource: FeedTableViewDataSource = FeedTableViewDataSource()
    ) {
        self.feedTableViewDataSource = feedTableViewDataSource
        super.init()
    }
    
    // MARK: - Function
    func update(with models: [ChannelsData.Channel]) {
        feedTableViewDataSource.update(with: models)
    }
}

// MARK: - UICollectionViewDelegate
extension FeedCollectionDataSource: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView is FeedCollectionView {
            let ratio = scrollView.contentOffset.x.truncatingRemainder(dividingBy: scrollView.frame.width) / scrollView.frame.width
            delegateDidScroll?.collectionViewDidScroll(progress: scrollView.contentOffset.x, ratio: ratio)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView is FeedCollectionView {
            delegateDidScroll?.didEndScroll()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView is FeedCollectionView {
            if !decelerate {
                delegateDidScroll?.didEndScroll()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension FeedCollectionDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Tabs.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: FeedCollectionViewCell.self),
            for: indexPath
        ) as? FeedCollectionViewCell
        else { return UICollectionViewCell() }
        cell.configure(with: feedTableViewDataSource, index: indexPath.row)
        return cell
    }
}

// MARK: - Delegate Flow
extension FeedCollectionDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
