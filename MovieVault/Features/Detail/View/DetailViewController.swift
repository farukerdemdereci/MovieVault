//
//  DetailViewController.swift
//  MovieVault
//
//  Created by Faruk on 8.07.2026.
//

import UIKit
import Kingfisher

final class DetailViewController: UIViewController {
    
    private let viewModel: DetailViewModel
    private var fetchTask: Task<Void, Never>?
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.bounces = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let posterGradientLayer = CAGradientLayer()
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32, weight: .black)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let ratingView = RatingView(
        font: .systemFont(ofSize: 22, weight: .semibold),
        starSize: 20
    )
    
    private let voteCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }()

    private let movieInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let genresLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let trailerButton: UIButton = {
        var config = UIButton.Configuration.plain()

        config.image = UIImage(systemName: "play.fill")
        config.imagePlacement = .leading
        config.imagePadding = 6
        config.baseForegroundColor = .white
        
        var title = AttributedString("Watch Trailer")
        title.font = .systemFont(ofSize: 16, weight: .bold)
        title.foregroundColor = .white

        config.attributedTitle = title
        config.background.backgroundColor = .secondaryLabel
        config.background.cornerRadius = 16

        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    private let castTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .left
        label.text = "Cast"
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: 120, height: 240)
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var ratingStackView = UIStackView(
        arrangedSubviews: [ratingView, voteCountLabel],
        axis: .vertical,
        spacing: 6,
        alignment: .center
    )
    
    private lazy var movieHeaderStackView = UIStackView(
        arrangedSubviews: [movieTitleLabel, ratingStackView],
        axis: .horizontal,
        spacing: 12,
        alignment: .top,
        distribution: .equalSpacing
    )
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            movieHeaderStackView,
            movieInfoLabel,
            genresLabel,
            overviewLabel,
            trailerButton
        ])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill

        stackView.setCustomSpacing(0, after: movieHeaderStackView)
        stackView.setCustomSpacing(10, after: movieInfoLabel)
        stackView.setCustomSpacing(20, after: genresLabel)
        stackView.setCustomSpacing(20, after: overviewLabel)

        return stackView
    }()
    
    deinit {
        print("\(Self.self) deinit")
        fetchTask?.cancel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        setupPosterGradient()
        setupHierarchy()
        setupConstraints()
        setupActions()
        setupCollectionView()
        bindViewModel()
        fetchDetails()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        posterGradientLayer.frame = posterImageView.bounds
    }
}

// MARK: - Collection View
extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(MovieCastCollectionViewCell.self, forCellWithReuseIdentifier: MovieCastCollectionViewCell.reuseIdentifier)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.cast.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCastCollectionViewCell.reuseIdentifier, for: indexPath) as? MovieCastCollectionViewCell else {
            return UICollectionViewCell()
        }

        let cast = viewModel.cast[indexPath.item]
        cell.configure(with: cast)
        return cell
    }
}

// MARK: - Setup
private extension DetailViewController {
    func setupAppearance() {
        view.backgroundColor = .black
    }
    
    func setupPosterGradient() {
        posterGradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.4).cgColor,
            UIColor.black.cgColor
        ]
        posterGradientLayer.locations = [0.0, 0.5, 1.0]
        
        posterImageView.layer.addSublayer(posterGradientLayer)
    }
    
    func setupHierarchy() {
        view.addSubview(activityIndicator)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(mainStackView)
        contentView.addSubview(castTitleLabel)
        contentView.addSubview(collectionView)
    }
        
    func setupConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.5),

            mainStackView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: -180),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            ratingView.widthAnchor.constraint(equalToConstant: 72),
            
            trailerButton.heightAnchor.constraint(equalToConstant: 52),
            
            castTitleLabel.topAnchor.constraint(equalTo: mainStackView.bottomAnchor,constant: 20),
            castTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            castTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),

            collectionView.topAnchor.constraint(equalTo: castTitleLabel.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 240),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
        ])
    }
    
    func setupActions() {
        trailerButton.addTarget(self, action: #selector(didTapTrailerButton), for: .touchUpInside)
    }
    
    @objc func didTapTrailerButton() {
        guard let url = viewModel.trailer?.url else {
            return
        }
        UIApplication.shared.open(url)
    }

    func fetchDetails() {
        fetchTask?.cancel()

        fetchTask = Task { [weak self] in
            guard let self else { return }
            await viewModel.fetchAllDetails()
        }
    }
}

// MARK: - ViewModel Binding
private extension DetailViewController {
    func bindViewModel() {
        viewModel.onStateChange = { [weak self] in
            self?.render()
        }
    }

    func render() {
        switch viewModel.state {
        case .idle:
            showIdleState()

        case .loading:
            showLoadingState()

        case .loaded:
            showLoadedState()

        case .error(let message):
            showErrorState(message: message)
        }
    }
    
    func showIdleState() {
        activityIndicator.stopAnimating()
    }

    func showLoadingState() {
        activityIndicator.startAnimating()
        scrollView.isHidden = true
    }

    func showLoadedState() {
        activityIndicator.stopAnimating()
        scrollView.isHidden = false

        configureMovie()
        configurePoster()
        collectionView.reloadData()
    }

    func showErrorState(message: String) {
        activityIndicator.stopAnimating()
        scrollView.isHidden = true

        showAlert(message: message) { [weak self] in
            self?.fetchDetails()
        }
    }
    
    func configureMovie() {
        guard let movie = viewModel.movie else {
            return
        }
        
        let hasTrailer = viewModel.trailer?.url != nil
        trailerButton.isEnabled = hasTrailer
        trailerButton.alpha = hasTrailer ? 1.0 : 0.5
        
        movieTitleLabel.text = movie.title
        ratingView.configure(rating: movie.voteAverage)
        
        voteCountLabel.text = viewModel.formattedVoteCount
        movieInfoLabel.text = viewModel.formattedMovieInfo
        genresLabel.text = viewModel.formattedGenres

        overviewLabel.text = movie.overview
    }
    
    func configurePoster() {
        guard let movie = viewModel.movie else {
            return
        }
        
        posterImageView.kf.cancelDownloadTask()
        posterImageView.image = UIImage(named: "posterPlaceholder")
        
        guard let posterPath = movie.posterPath,
              let url = URL(
                string: "\(APIConstants.imageBaseURL)\(posterPath)"
              ) else {
            return
        }
        
        posterImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "posterPlaceholder")
        )
    }
}
