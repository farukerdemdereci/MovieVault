//
//  HomeViewController.swift
//  MovieVault
//
//  Created by Faruk on 30.06.2026.
//

import UIKit

final class HomeViewController: UIViewController {

    var onMovieSelected: ((Int) -> Void)?
    var onSeeAllSelected: ((MovieSection) -> Void)?
    
    private let viewModel: HomeViewModel
    private var fetchTask: Task<Void, Never>?

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createCompositionalLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    deinit {
        print("\(Self.self) deinit")
        fetchTask?.cancel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        setupNavigationTitle()
        setupHierarchy()
        setupConstraints()
        setupCollectionView()
        bindViewModel()
        fetchMovies()
    }
}

// MARK: - CollectionView
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    private func createCompositionalLayout() -> UICollectionViewLayout {

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(120),
            heightDimension: .absolute(240)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 16

        section.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 20,
            bottom: 24,
            trailing: 20
        )

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(44)
        )

        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        section.boundarySupplementaryItems = [header]

        return UICollectionViewCompositionalLayout(section: section)
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(
            MovieCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieCollectionViewCell.reuseIdentifier
        )

        collectionView.register(
            MovieSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MovieSectionHeaderView.reuseIdentifier
        )
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        MovieSection.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = MovieSection(rawValue: section) else {
            return 0
        }

        return movies(for: section).count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.reuseIdentifier, for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        
        guard let section = MovieSection(rawValue: indexPath.section) else { return UICollectionViewCell() }

        let movie = movies(for: section)[indexPath.item]
        cell.configure(with: movie)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MovieSectionHeaderView.reuseIdentifier,
                for: indexPath
            ) as? MovieSectionHeaderView,
            let section = MovieSection(rawValue: indexPath.section)
        else {
            return UICollectionReusableView()
        }

        header.configure(with: section.title)

        header.onSeeAllTapped = { [weak self] in
            self?.onSeeAllSelected?(section)
        }

        return header
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = MovieSection(rawValue: indexPath.section) else {
            return
        }

        
        let movie = movies(for: section)[indexPath.item]
        onMovieSelected?(movie.id)
    }
}

// MARK: - Setup
private extension HomeViewController {
    func setupHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func fetchMovies() {
        fetchTask?.cancel()

        fetchTask = Task { [weak self] in
            guard let self else { return }
            await self.viewModel.fetchAllMovies()
        }
    }
    
    func setupNavigationTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "MovieVault"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.sizeToFit()

        navigationItem.titleView = titleLabel
        navigationController?.navigationBar.tintColor = .white
    }
}

// MARK: - ViewModel Binding
private extension HomeViewController {
    func bindViewModel() {
        viewModel.onStateChange = { [weak self] in
            self?.render()
        }
    }

    func render() {
        switch viewModel.state {
        case .idle:
            break

        case .loading:
            showLoadingState()

        case .loaded:
            showLoadedState()

        case .error(let message):
            showErrorState(message: message)
        }
    }

    func showLoadingState() {
        activityIndicator.startAnimating()
        collectionView.isHidden = true
    }

    func showLoadedState() {
        activityIndicator.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData()
    }

    func showErrorState(message: String) {
        activityIndicator.stopAnimating()
        collectionView.isHidden = false

        showAlert(message: message) { [weak self] in
            self?.fetchMovies()
        }
    }
}

// MARK: - Helpers
private extension HomeViewController {
    func movies(for section: MovieSection) -> [Movie] {
        switch section {
        case .popular:
            return viewModel.popularMovies

        case .upcoming:
            return viewModel.upcomingMovies

        case .topRated:
            return viewModel.topRatedMovies
        }
    }
}
