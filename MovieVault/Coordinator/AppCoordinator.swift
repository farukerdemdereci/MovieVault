//
//  AppCoordinator.swift
//  MovieVault
//
//  Created by Faruk on 19.07.2026.
//

import UIKit

final class AppCoordinator: Coordinator {

    let navigationController: UINavigationController
    private let movieRepository: MovieRepositoryProtocol

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController

        let movieService = MovieService()
        self.movieRepository = MovieRepository(service: movieService)
    }

    func start() {
        showHome()
    }
}

private extension AppCoordinator {

    func showHome() {
        let viewModel = HomeViewModel(
            repository: movieRepository
        )

        let viewController = HomeViewController(
            viewModel: viewModel
        )

        viewController.onMovieSelected = { [weak self] movieID in
            self?.showDetail(movieID: movieID)
        }

        viewController.onSeeAllSelected = { [weak self] section in
            self?.showMovieList(section: section)
        }

        navigationController.setViewControllers(
            [viewController],
            animated: false
        )
    }

    func showMovieList(section: MovieSection) {
        let viewModel = MovieListViewModel(
            repository: movieRepository,
            section: section
        )

        let viewController = MovieListViewController(
            viewModel: viewModel
        )

        viewController.onMovieSelected = { [weak self] movieID in
            self?.showDetail(movieID: movieID)
        }

        navigationController.pushViewController(
            viewController,
            animated: true
        )
    }

    func showDetail(movieID: Int) {
        let viewModel = DetailViewModel(
            repository: movieRepository,
            movieID: movieID
        )

        let viewController = DetailViewController(
            viewModel: viewModel
        )

        navigationController.pushViewController(
            viewController,
            animated: true
        )
    }
}
