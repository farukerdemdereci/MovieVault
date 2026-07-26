//
//  MovieCastCollectionViewCell.swift
//  MovieVault
//
//  Created by Faruk on 13.07.2026.
//

import UIKit
import Kingfisher

final class MovieCastCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: MovieCastCollectionViewCell.self)
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    
    private let characterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(characterLabel)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 180),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor,constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -8),
            
            characterLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: 4),
            characterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 8),
            characterLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -8),
            characterLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with cast: Cast) {
        nameLabel.text = cast.name
        characterLabel.text = cast.character
        
        guard
            let profilePath = cast.profilePath,
            let url = URL(string: "\(APIConstants.imageBaseURL)\(profilePath)")
        else {
            profileImageView.image = UIImage(systemName: "person.crop.rectangle")
            return
        }

        profileImageView.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "person.crop.rectangle"),
            options: [.transition(.fade(0.2))]
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImageView.kf.cancelDownloadTask()
        profileImageView.image = nil
        nameLabel.text = nil
        characterLabel.text = nil
    }
}
