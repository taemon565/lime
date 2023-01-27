//
//  ChannelCell.swift
//  Lime
//
//  Created by Vadim Presnov on 27.01.2023.
//

import UIKit

final class ChannelCell: UITableViewCell {
    // MARK: - Properties
    private let fonView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.channelBackground
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let channelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.channelSubtitleText
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private let favouritesImageView = UIImageView(image: UIImage(.star))
    private let favoriteService: FavoritesService
    
    // MARK: - Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.favoriteService = ServiceLocator.favoritesService
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    func configure(with model: ChannelsData.Channel) {
        titleLabel.text = model.nameRu
        subtitleLabel.text = model.current?.title
        
        channelImageView.downloadImage(url: model.image) { [weak self] image in
            self?.channelImageView.image = image
        }
        
        favouritesImageView.image = favoriteService.isFavorite(model.id ?? 0) ? UIImage(.activeStar) : UIImage(.star)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        channelImageView.image = nil
    }
    
    // MARK: - Private
    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(fonView)
        fonView.translatesAutoresizingMaskIntoConstraints = false
        
        [
            channelImageView,
            titleLabel,
            subtitleLabel,
            favouritesImageView
        ].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            fonView.addSubview(view)
        }
        
        NSLayoutConstraint.activate([
            fonView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            fonView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            fonView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            fonView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            
            channelImageView.widthAnchor.constraint(equalTo: channelImageView.heightAnchor),
            channelImageView.heightAnchor.constraint(equalToConstant: 60),
            channelImageView.leadingAnchor.constraint(equalTo: fonView.leadingAnchor, constant: 8),
            channelImageView.centerYAnchor.constraint(equalTo: fonView.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: fonView.topAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: channelImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: fonView.trailingAnchor, constant: -60),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: fonView.bottomAnchor, constant: -14),
            
            favouritesImageView.widthAnchor.constraint(equalTo: favouritesImageView.heightAnchor),
            favouritesImageView.heightAnchor.constraint(equalToConstant: 32),
            favouritesImageView.centerYAnchor.constraint(equalTo: fonView.centerYAnchor),
            favouritesImageView.trailingAnchor.constraint(equalTo: fonView.trailingAnchor, constant: -12)
        ])
    }
    
}
