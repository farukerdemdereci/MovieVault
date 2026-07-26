//
//  MovieCollectionViewCell.swift
//  MovieVault
//
//  Created by Faruk on 1.07.2026.
//

import Foundation
import UIKit
import Kingfisher

final class MovieCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: MovieCollectionViewCell.self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let ratingView: RatingView = {
        let view = RatingView(
            font: .systemFont(ofSize: 14, weight: .bold),
            starSize: 14
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
   private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        contentView.addSubview(ratingView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.5),

            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            ratingView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 2),
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ratingView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with movie: Movie) {
        label.text = movie.title
        ratingView.configure(rating: movie.voteAverage)

        guard
            let posterPath = movie.posterPath,
            let url = URL(string: "\(APIConstants.imageBaseURL)\(posterPath)")
        else {
            imageView.image = UIImage(systemName: "photo")
            return
        }

        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "person.crop.rectangle"),
            options: [.transition(.fade(0.2))]
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.kf.cancelDownloadTask()
        imageView.image = nil
        label.text = nil
        ratingView.reset()
    }
}
