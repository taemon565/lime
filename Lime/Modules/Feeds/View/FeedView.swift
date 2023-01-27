//
//  FeedView.swift
//  Lime
//
//  Created by Vadim Presnov on 27.01.2023.
//

import UIKit

final class FeedView: UIView {
    // MARK: - Properties
    let headerView = FeedHeaderView()
    let collectionView: UICollectionView = {
        let collectionView = FeedCollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.register(
            FeedCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: FeedCollectionViewCell.self)
        )
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        return collectionView
    }()
    
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private
    private func setupView() {
        backgroundColor = Colors.background
        [headerView, collectionView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
