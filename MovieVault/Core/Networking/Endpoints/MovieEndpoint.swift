//
//  MovieEndpoint.swift
//  MovieVault
//
//  Created by Faruk on 15.07.2026.
//

import Foundation

enum MovieEndpoint {
    case popular
    case upcoming
    case topRated
    case details(id: Int)
    case credits(id: Int)
    case videos(id: Int)

    var path: String {
        switch self {
        case .popular:
            return "popular"
        case .upcoming:
            return "upcoming"
        case .topRated:
            return "top_rated"
        case .details(let id):
            return "\(id)"
        case .credits(let id):
            return "\(id)/credits"
        case .videos(let id):
            return "\(id)/videos"
        }
    }
}
