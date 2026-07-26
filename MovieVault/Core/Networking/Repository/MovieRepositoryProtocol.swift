//
//  MovieRepositoryProtocol.swift
//  MovieVault
//
//  Created by Faruk on 22.07.2026.
//

import Foundation

protocol MovieRepositoryProtocol {
    func fetchMovies(_ endpoint: MovieEndpoint, page: Int) async throws -> MovieResponse
    func fetchMovieDetails(id: Int) async throws -> MovieDetail
    func fetchMovieCast(id: Int) async throws -> CastResponse
    func fetchMovieVideos(id: Int) async throws -> MovieVideosResponse
}
