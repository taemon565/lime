//
//  FeedHeaderView.swift
//  Lime
//
//  Created by Vadim Presnov on 27.01.2023.
//

import UIKit

final class FeedHeaderView: UIView {
    // MARK: - Properties
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Feed.SearchBar.Placeholder".localized
        searchBar.backgroundImage = UIImage()
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField {
            let imageView = UIImageView(image: UIImage(.shape))
            textFieldInsideSearchBar.leftView = imageView
            textFieldInsideSearchBar.tintColor = Colors.searchBar
            textFieldInsideSearchBar.textColor = .white
            textFieldInsideSearchBar.attributedPlaceholder = NSAttributedString(
                string: textFieldInsideSearchBar.placeholder ?? "",
                attributes: [.foregroundColor: Colors.searchBar]
            )
        }
        return searchBar
    }()
    
    let tabsView = TabsView(
        titles: Tabs.allCases.map{ $0.description },
        textColor: UIColor(hexString: "ffffff", alpha: 0.5),
        selectedTextColor: UIColor(hexString: "ffffff"),
        bottomSelectedLineHeight: 2
    )
    private let bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.separator
        return view
    }()
    
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    private func setupView() {
        backgroundColor = Colors.feedHeader
        [searchBar, tabsView, bottomSeparatorView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            searchBar.heightAnchor.constraint(equalToConstant: 48),
            
            tabsView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            tabsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabsView.heightAnchor.constraint(equalToConstant: 56),
            
            bottomSeparatorView.topAnchor.constraint(equalTo: tabsView.bottomAnchor),
            bottomSeparatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomSeparatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomSeparatorView.heightAnchor.constraint(equalToConstant: 0.5),
            bottomSeparatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
