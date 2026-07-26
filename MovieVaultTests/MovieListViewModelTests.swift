//
//  MovieListViewModelTests.swift
//  MovieVaultTests
//
//  Created by Faruk on 24.07.2026.
//

import Foundation
import Testing
@testable import MovieVault

@MainActor

struct MovieListViewModelTests {
    
    @Test
    func fetchMovies_WhenRepositoryReturnsData_LoadsFirstPage() async {
        // Given
        let repository = MockMovieRepository()
        let viewModel = MovieListViewModel(
            repository: repository,
            section: .popular
        )
        
        // When
        await viewModel.fetchMovies()
        
        // Then
        #expect(viewModel.movies.count == 1)
        #expect(viewModel.movies.first?.title == "Test Movie")
        #expect(viewModel.state == .loaded)
        
    }
    
    @Test
    func fetchMovies_WhenRepositoryThrows_SetsErrorState() async {
        // Given
        let repository = MockMovieRepository()
        repository.fetchMoviesError = MockError.network
        let viewModel = MovieListViewModel(
            repository: repository,
            section: .popular
        )
        
        // When
        await viewModel.fetchMovies()
        
        // Then
        #expect(viewModel.movies.isEmpty)
        #expect(viewModel.state == .error(MockError.network.localizedDescription))
    }
}
