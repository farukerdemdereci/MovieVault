//
//  MovieSectionHeaderView.swift
//  MovieVault
//
//  Created by Faruk on 14.07.2026.
//

import UIKit

final class MovieSectionHeaderView: UICollectionReusableView {

    static let reuseIdentifier = String(describing: MovieSectionHeaderView.self)

    var onSeeAllTapped: (() -> Void)?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        return label
    }()

    private let seeAllButton: UIButton = {
        var config = UIButton.Configuration.plain()

        config.image = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 10, weight: .bold))
        config.imagePlacement = .trailing
        config.imagePadding = 4
        config.baseForegroundColor = .systemYellow

        var title = AttributedString("See All")
        title.font = .systemFont(ofSize: 16, weight: .bold)
        title.foregroundColor = .systemYellow
        config.attributedTitle = title

        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear

        setupHierarchy()
        setupConstraints()
        setupActions()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        onSeeAllTapped = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with title: String) {
        titleLabel.text = title
    }
}

private extension MovieSectionHeaderView {
    
    func setupHierarchy() {
        addSubview(titleLabel)
        addSubview(seeAllButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: seeAllButton.leadingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

            seeAllButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            seeAllButton.topAnchor.constraint(equalTo: topAnchor),
            seeAllButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setupActions() {
        seeAllButton.addTarget(
            self,
            action: #selector(seeAllTapped),
            for: .touchUpInside
        )
    }

    @objc func seeAllTapped() {
        onSeeAllTapped?()
    }
}
