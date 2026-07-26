//
//  HomeViewModelTests.swift
//  MovieVaultTests
//
//  Created by Faruk on 24.07.2026.
//

import Foundation
import Testing
@testable import MovieVault

@MainActor
struct HomeViewModelTests {

    @Test
    func fetchAllMovies_WhenServiceReturnsData_LoadsAllSections() async {
        // Given
        let repository = MockMovieRepository()
        let viewModel = HomeViewModel(repository: repository)

        // When
        await viewModel.fetchAllMovies()

        // Then
        #expect(viewModel.popularMovies.count == 1)
        #expect(viewModel.upcomingMovies.count == 1)
        #expect(viewModel.topRatedMovies.count == 1)
        #expect(viewModel.state == .loaded)
    }
    
    @Test
    func fetchAllMovies_WhenRepositoryThrows_SetsErrorState() async {
        // Given
        let repository = MockMovieRepository()
        repository.fetchMoviesError = MockError.network

        let viewModel = HomeViewModel(repository: repository)

        // When
        await viewModel.fetchAllMovies()

        // Then
        #expect(viewModel.state == .error(MockError.network.localizedDescription))
        #expect(viewModel.popularMovies.isEmpty)
        #expect(viewModel.upcomingMovies.isEmpty)
        #expect(viewModel.topRatedMovies.isEmpty)
    }
    
    @Test
    func fetchAllMovies_WhenSuccessful_AssignsMoviesToAllSections() async {
        // Given
        let repository = MockMovieRepository()
        let viewModel = HomeViewModel(repository: repository)

        // When
        await viewModel.fetchAllMovies()

        // Then
        #expect(viewModel.popularMovies.first?.title == "Test Movie")
        #expect(viewModel.upcomingMovies.first?.title == "Test Movie")
        #expect(viewModel.topRatedMovies.first?.title == "Test Movie")
    }
}
