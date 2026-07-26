//
//  ViewState.swift
//  MovieVault
//
//  Created by Faruk on 9.07.2026.
//

import Foundation

enum ViewState: Equatable {
    case idle
    case loading
    case loaded
    case error(String)
}
