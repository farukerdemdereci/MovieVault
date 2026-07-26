//
//  DetailViewModel.swift
//  MovieVault
//
//  Created by Faruk on 8.07.2026.
//

import Foundation

@MainActor
final class DetailViewModel {

    private let repository: MovieRepositoryProtocol
    private let movieID: Int

    private(set) var movie: MovieDetail?
    private(set) var cast: [Cast] = []
    private(set) var trailer: MovieVideo?

    var onStateChange: (() -> Void)?

    private(set) var state: ViewState = .idle {
        didSet {
            onStateChange?()
        }
    }

    init(repository: MovieRepositoryProtocol, movieID: Int) {
        self.repository = repository
        self.movieID = movieID
    }

    func fetchAllDetails() async {
        state = .loading

        do {
            let movie = try await repository.fetchMovieDetails(id: movieID)
            self.movie = movie

            await fetchCast()
            await fetchTrailer()

            state = .loaded
        } catch is CancellationError {
            state = .idle

        } catch {
            state = .error(error.localizedDescription)
        }
    }

    private func fetchCast() async {
        do {
            let response = try await repository.fetchMovieCast(id: movieID)
            cast = response.cast

        } catch is CancellationError {
            return
        } catch {
            cast = []
        }
    }

    private func fetchTrailer() async {
        do {
            let response = try await repository.fetchMovieVideos(id: movieID)

            trailer = response.results.first {
                $0.site == "YouTube" &&
                $0.type == "Trailer"
            }
            
        } catch is CancellationError {
            return
        } catch {
            trailer = nil
        }
    }
    
    var formattedVoteCount: String {
        guard let movie else { return "" }

        if movie.voteCount >= 1000 {
            return String(
                format: "%.1fK votes",
                Double(movie.voteCount) / 1000
            )
        }

        return "\(movie.voteCount) votes"
    }

    var formattedMovieInfo: String {
        guard let movie else { return "" }

        var parts: [String] = []

        if !movie.releaseDate.isEmpty {
            parts.append(String(movie.releaseDate.prefix(4)))
        }

        if let runtime = movie.runtime, runtime > 0 {
            let hours = runtime / 60
            let minutes = runtime % 60
            parts.append("\(hours)h \(minutes)m")
        }

        return parts.joined(separator: "  •  ")
    }

    var formattedGenres: String {
        movie?.genres
            .map(\.name)
            .joined(separator: "  •  ") ?? ""
    }
}
