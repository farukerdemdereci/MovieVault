//
//  MovieVideoModel.swift
//  MovieVault
//
//  Created by Faruk on 14.07.2026.
//

import Foundation

struct MovieVideosResponse: Decodable {
    let results: [MovieVideo]
}

struct MovieVideo: Decodable {
    let key: String
    let site: String
    let type: String

    var url: URL? {
        guard site == "YouTube" else {
            return nil
        }

        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }
}
