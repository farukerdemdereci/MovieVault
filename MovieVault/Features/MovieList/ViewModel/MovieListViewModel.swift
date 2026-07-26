//
//  MovieListViewModel.swift
//  MovieVault
//
//  Created by Faruk on 16.07.2026.
//

import Foundation

@MainActor
final class MovieListViewModel {

    private let repository: MovieRepositoryProtocol
    private let section: MovieSection

    private(set) var movies: [Movie] = []

    private var currentPage = 1
    private var totalPages = 1
    private var isLoading = false

    var title: String {
        section.title
    }

    var onStateChange: (() -> Void)?
    var onPaginationError: ((String) -> Void)?

    private(set) var state: ViewState = .idle {
        didSet {
            onStateChange?()
        }
    }

    init(repository: MovieRepositoryProtocol, section: MovieSection) {
        self.repository = repository
        self.section = section
    }

    func fetchMovies() async {
        guard !isLoading else { return }

        await loadPage(
            pageToFetch: 1,
            showLoading: true
        )
    }

    func fetchNextPage() async {
        guard !isLoading, currentPage < totalPages else {
            return
        }

        let nextPage = currentPage + 1

        await loadPage(
            pageToFetch: nextPage,
            showLoading: false
        )
    }

    private func loadPage(pageToFetch: Int, showLoading: Bool) async {
        isLoading = true

        defer {
            isLoading = false
        }

        if showLoading {
            state = .loading
        }

        do {
            let response = try await repository.fetchMovies(
                section.endpoint,
                page: pageToFetch
            )

            if pageToFetch == 1 {
                movies = response.results
            } else {
                movies.append(contentsOf: response.results)
            }

            currentPage = pageToFetch
            totalPages = response.totalPages
            state = .loaded

        } catch is CancellationError {
            if showLoading {
                state = .idle
            }

        } catch {
            if showLoading {
                state = .error(error.localizedDescription)
            } else {
                onPaginationError?(error.localizedDescription)
            }
        }
    }
}
