//
//  HomeViewModel.swift
//  MovieVault
//
//  Created by Faruk on 1.07.2026.
//

import Foundation

@MainActor
final class HomeViewModel {

    private let repository: MovieRepositoryProtocol

    private(set) var popularMovies: [Movie] = []
    private(set) var upcomingMovies: [Movie] = []
    private(set) var topRatedMovies: [Movie] = []

    var onStateChange: (() -> Void)?

    private(set) var state: ViewState = .idle {
        didSet {
            onStateChange?()
        }
    }

    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }

    func fetchAllMovies() async {
        state = .loading

        do {
            async let popularResponse = repository.fetchMovies(.popular, page: 1)
            async let upcomingResponse = repository.fetchMovies(.upcoming, page: 1)
            async let topRatedResponse = repository.fetchMovies(.topRated, page: 1)

            let (popular, upcoming, topRated) = try await (
                popularResponse,
                upcomingResponse,
                topRatedResponse
            )

            popularMovies = popular.results
            upcomingMovies = upcoming.results
            topRatedMovies = topRated.results

            state = .loaded

        } catch is CancellationError {
            state = .idle

        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
