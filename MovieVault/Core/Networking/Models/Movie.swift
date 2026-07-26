//
//  Model.swift
//  MovieVault
//
//  Created by Faruk on 1.07.2026.
//

import Foundation

struct MovieResponse: Decodable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Decodable {
    let id: Int
    let title: String
    let posterPath: String?
    let voteAverage: Double
    let voteCount: Int
    let releaseDate: String

    enum CodingKeys: String, CodingKey {
        case id, title
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case releaseDate = "release_date"
    }
}
