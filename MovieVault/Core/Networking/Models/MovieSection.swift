//
//  MovieSection.swift
//  MovieVault
//
//  Created by Faruk on 16.07.2026.
//

import Foundation

enum MovieSection: Int, CaseIterable {
    case popular
    case upcoming
    case topRated

    var title: String {
        switch self {
        case .popular:
            return "Popular"
        case .upcoming:
            return "Upcoming"
        case .topRated:
            return "Top Rated"
        }
    }
    
    var endpoint: MovieEndpoint {
        switch self {
        case .popular:
            return .popular
        case .upcoming:
            return .upcoming
        case .topRated:
            return .topRated
        }
    }
}
