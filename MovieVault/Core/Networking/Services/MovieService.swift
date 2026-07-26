//
//  Service.swift
//  MovieVault
//
//  Created by Faruk on 1.07.2026.
//

import Foundation

final class MovieService: MovieServiceProtocol {

    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    func fetchMovies(_ endpoint: MovieEndpoint, page: Int) async throws -> MovieResponse {
        try await request(endpoint: endpoint, page: page)
    }

    func fetchMovieDetails(id: Int) async throws -> MovieDetail {
        try await request(endpoint: .details(id: id))
    }

    func fetchMovieCast(id: Int) async throws -> CastResponse {
        try await request(endpoint: .credits(id: id))
    }

    func fetchMovieVideos(id: Int) async throws -> MovieVideosResponse {
        try await request(endpoint: .videos(id: id))
    }

    private func request<T: Decodable>(
        endpoint: MovieEndpoint,
        page: Int? = nil
    ) async throws -> T {
        guard let baseURL = URL(string: APIConstants.baseURL) else {
            throw ServiceError.invalidURL
        }

        let endpointURL = baseURL.appending(path: endpoint.path)

        guard var components = URLComponents(
            url: endpointURL,
            resolvingAgainstBaseURL: false
        ) else {
            throw ServiceError.invalidURL
        }

        if let page {
            components.queryItems = [
                URLQueryItem(name: "page", value: String(page))
            ]
        }

        guard let url = components.url else {
            throw ServiceError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue(
            "application/json",
            forHTTPHeaderField: "Accept"
        )
        urlRequest.setValue(
            Secrets.tmdbToken,
            forHTTPHeaderField: "Authorization"
        )

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch is CancellationError {
            throw CancellationError()
        } catch {
            throw ServiceError.networkError(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ServiceError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw ServiceError.serverError(
                statusCode: httpResponse.statusCode
            )
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw ServiceError.decodingError(error)
        }
    }
}
