//
//  CastModel.swift
//  MovieVault
//
//  Created by Faruk on 13.07.2026.
//

import Foundation

struct CastResponse: Decodable {
    let cast: [Cast]
}

struct Cast: Decodable {
    let id: Int
    let name: String
    let knownForDepartment: String
    let character: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, character
        case knownForDepartment = "known_for_department"
        case profilePath = "profile_path"
    }
}
