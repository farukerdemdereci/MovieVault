//
//  MovieListViewController.swift
//  MovieVault
//
//  Created by Faruk on 16.07.2026.
//

import UIKit

final class MovieListViewController: UIViewController {
    
    private let viewModel: MovieListViewModel
    private var fetchTask: Task<Void, Never>?
    
    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var onMovieSelected: ((Int) -> Void)?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 12
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
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
        fetchTask?.cancel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationTitle()
        setupHierarchy()
        setupConstraints()
        setupCollectionView()
        bindViewModel()
        fetchMovies()
    }
}

    // MARK: - UICollectionViewDataSource
    extension MovieListViewController: UICollectionViewDataSource {

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            viewModel.movies.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.reuseIdentifier, for: indexPath) as? MovieCollectionViewCell else {
                return UICollectionViewCell()
            }

            let movie = viewModel.movies[indexPath.item]
            cell.configure(with: movie)

            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            let loadMoreIndex = viewModel.movies.count - 4

            guard indexPath.item >= loadMoreIndex else {
                return
            }

            Task {
                await viewModel.fetchNextPage()
            }
        }
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    extension MovieListViewController: UICollectionViewDelegateFlowLayout {

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            let spaceBetweenCells: CGFloat = 16
            let availableWidth = collectionView.bounds.width - spaceBetweenCells
            let itemWidth = availableWidth / 2
            
            let posterHeight = itemWidth * 1.5
            let textAreaHeight: CGFloat = 60

            return CGSize(
                width: itemWidth,
                height: posterHeight + textAreaHeight
            )
        }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let movie = viewModel.movies[indexPath.item]
            onMovieSelected?(movie.id)
        }
    }

    // MARK: - Setup
    private extension MovieListViewController {
        func setupHierarchy() {
            view.addSubview(collectionView)
            view.addSubview(activityIndicator)
        }

        func setupConstraints() {
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }

        func setupCollectionView() {
            collectionView.dataSource = self
            collectionView.delegate = self

            collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.reuseIdentifier)
        }

        func fetchMovies() {
            fetchTask?.cancel()

            fetchTask = Task { [weak self] in
                guard let self else { return }
                await viewModel.fetchMovies()
            }
        }
        
        func setupNavigationTitle() {
            let titleLabel = UILabel()
            titleLabel.text = viewModel.title
            titleLabel.textColor = .white
            titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
            titleLabel.sizeToFit()

            navigationItem.titleView = titleLabel
            navigationController?.navigationBar.tintColor = .white
        }
    }

    // MARK: - ViewModel Binding
private extension MovieListViewController {
    func bindViewModel() {
        viewModel.onStateChange = { [weak self] in
            self?.render()
        }

        viewModel.onPaginationError = { [weak self] message in
            self?.showAlert(message: message)
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
