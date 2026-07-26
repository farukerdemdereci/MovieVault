//
//  MockMovieRepository.swift
//  MovieVaultTests
//
//  Created by Faruk on 24.07.2026.
//

import Foundation
@testable import MovieVault

final class MockMovieRepository: MovieRepositoryProtocol {
    
    var fetchMoviesError: Error?
    var movieDetailsError: Error?
    var castError: Error?
    var videosError: Error?

    let mockMovie = MovieDetail(
        id: 1,
        title: "Test Movie",
        overview: "Test Overview",
        genres: [],
        runtime: 120,
        posterPath: nil,
        voteAverage: 8.5,
        voteCount: 100,
        releaseDate: "2026-01-01"
    )

    let mockCast = CastResponse(
        cast: [Cast(
            id: 1,
            name: "Test Name",
            knownForDepartment: "Test Department",
            character: "Test Character",
            profilePath: "Test Url"
        )]
    )
    
    var mockVideos = MovieVideosResponse(
        results: [
            MovieVideo(
                key: "teaser_key",
                site: "Youtube",
                type: "Teaser"
            ),
            
            MovieVideo(
                key: "trailer_key",
                site: "YouTube",
                type: "Trailer"
            )
        ]
    )
    
    let mockMovies = MovieResponse(
        page: 1,
        results: [
            Movie(
                id: 1,
                title: "Test Movie",
                posterPath: nil,
                voteAverage: 8.5,
                voteCount: 100,
                releaseDate: "2026-01-01"
            )
        ],
        totalPages: 1,
        totalResults: 1
    )
    
    func fetchMovies(_ endpoint: MovieEndpoint, page: Int) async throws -> MovieResponse {
        if let fetchMoviesError {
            throw fetchMoviesError
        }

        return mockMovies
    }

    func fetchMovieDetails(id: Int) async throws -> MovieDetail {
        if let movieDetailsError {
            throw movieDetailsError
        }

        return mockMovie
    }

    func fetchMovieCast(id: Int) async throws -> CastResponse {
        if let castError {
            throw castError
        }

        return mockCast
    }

    func fetchMovieVideos(id: Int) async throws -> MovieVideosResponse {
        if let videosError {
            throw videosError
        }

        return mockVideos
    }
}
