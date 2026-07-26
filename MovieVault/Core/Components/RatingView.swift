//
//  RatingView.swift
//  MovieVault
//
//  Created by Faruk on 14.07.2026.
//

import UIKit

final class RatingView: UIView {

    private let starImageView: UIImageView = {
        let imageView = UIImageView(
            image: UIImage(systemName: "star.fill")
        )
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemYellow
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [starImageView, ratingLabel]
        )
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()

    init(font: UIFont = .systemFont(ofSize: 22, weight: .semibold), starSize: CGFloat = 20) {
        super.init(frame: .zero)
        ratingLabel.font = font
        setupLayout(starSize: starSize)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(rating: Double) {
        ratingLabel.text = String(format: "%.1f", rating)
    }

    func reset() {
        ratingLabel.text = nil
    }

    private func setupLayout(starSize: CGFloat) {
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            starImageView.widthAnchor.constraint(equalToConstant: starSize),
            starImageView.heightAnchor.constraint(equalToConstant: starSize)
        ])
    }
}
