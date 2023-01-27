//
//  FeedCollectionViewCell.swift
//  Lime
//
//  Created by Vadim Presnov on 28.01.2023.
//

import UIKit

final class FeedCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        tableView.register(
            ChannelCell.self,
            forCellReuseIdentifier: String(describing: ChannelCell.self)
        )
        return tableView
    }()
    
    // MARK: - Life  cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    func configure(
        with dataSource: UITableViewDelegate & UITableViewDataSource,
        index: Int
    ) {
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.tag = index
        tableView.reloadData()
    }
    
    // MARK: - Private
    private func setupView() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
