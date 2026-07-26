//
//  MovieDetail.swift
//  MovieVault
//
//  Created by Faruk on 9.07.2026.
//

import Foundation

struct MovieDetail: Decodable {
    let id: Int
    let title: String
    let overview: String
    let genres: [Genre]
    let runtime: Int?
    let posterPath: String?
    let voteAverage: Double
    let voteCount: Int
    let releaseDate: String

    enum CodingKeys: String, CodingKey {
        case id, title, overview, genres, runtime
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case releaseDate = "release_date"
    }
}

struct Genre: Decodable {
    let id: Int
    let name: String
}
