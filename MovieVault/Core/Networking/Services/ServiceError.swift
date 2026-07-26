//
//  ServiceError.swift
//  MovieVault
//
//  Created by Faruk on 15.07.2026.
//

import Foundation

enum ServiceError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case networkError(Error)
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."

        case .invalidResponse:
            return "The server response is invalid."

        case .serverError(let statusCode):
            return "Server error occurred. Status code: \(statusCode)"

        case .networkError:
            return "A network error occurred."

        case .decodingError:
            return "The response could not be processed."
        }
    }
}
