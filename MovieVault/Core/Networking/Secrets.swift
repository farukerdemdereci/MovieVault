//
//  Secrets.swift
//  MovieVault
//
//  Created by Faruk on 15.07.2026.
//

import Foundation

enum Secrets {

    static var tmdbToken: String {
        guard let token = Bundle.main.object(
            forInfoDictionaryKey: "TMDB_TOKEN"
        ) as? String else {
            fatalError("TMDB_TOKEN not found")
        }

        return "Bearer \(token)"
    }

}
