//
//  MockMovieService.swift
//  MovieVaultTests
//
//  Created by Faruk on 23.07.2026.
//

import Foundation
@testable import MovieVault

final class MockMovieService: MovieServiceProtocol {
    var shouldThrowError = false
    
    var fetchMovieDetailsCallCount = 0
    var fetchMovieCastCallCount = 0
    var fetchMovieVideosCallCount = 0

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
    
    let mockVideos = MovieVideosResponse(
        results: [MovieVideo(
            key: "Test Key",
            site: "Test Site",
            type: "Test Type"
        )]
    )

    func fetchMovies(_ endpoint: MovieEndpoint, page: Int) async throws -> MovieResponse {
        fatalError("fetchMovies bu testte kullanılmamalı")
    }

    func fetchMovieDetails(id: Int) async throws -> MovieDetail {
        fetchMovieDetailsCallCount += 1

        if shouldThrowError {
            throw MockError.network
        }

        return mockMovie
    }

    func fetchMovieCast(id: Int) async throws -> CastResponse {
        fetchMovieCastCallCount += 1
        return mockCast
    }

    func fetchMovieVideos(id: Int) async throws -> MovieVideosResponse {
        fetchMovieVideosCallCount += 1
        return mockVideos
    }
}
