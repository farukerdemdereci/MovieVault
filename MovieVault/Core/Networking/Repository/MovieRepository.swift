//
//  MovieRepository.swift
//  MovieVault
//
//  Created by Faruk on 23.07.2026.
//

import Foundation

final class MovieRepository: MovieRepositoryProtocol {
    private let service: MovieServiceProtocol

    private var detailCache: [Int: MovieDetail] = [:]
    private var castCache: [Int: CastResponse] = [:]
    private var videoCache: [Int: MovieVideosResponse] = [:]

    init(service: MovieServiceProtocol) {
        self.service = service
    }
    
    func fetchMovies(_ endpoint: MovieEndpoint, page: Int) async throws -> MovieResponse {
        let movies = try await service.fetchMovies(endpoint, page: page)
        return movies
    }

    func fetchMovieDetails(id: Int) async throws -> MovieDetail {
        if let cachedMovie = detailCache[id] {
            return cachedMovie
        }

        let movie = try await service.fetchMovieDetails(id: id)
        detailCache[id] = movie

        return movie
    }

    func fetchMovieCast(id: Int) async throws -> CastResponse {
        if let cachedCast = castCache[id] {
            return cachedCast
        }

        let cast = try await service.fetchMovieCast(id: id)
        castCache[id] = cast

        return cast
    }

    func fetchMovieVideos(id: Int) async throws -> MovieVideosResponse {
        if let cachedVideos = videoCache[id] {
            return cachedVideos
        }

        let videos = try await service.fetchMovieVideos(id: id)
        videoCache[id] = videos

        return videos
    }
}
