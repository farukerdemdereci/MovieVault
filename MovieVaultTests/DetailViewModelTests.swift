//
//  DetailViewModelTests.swift
//  MovieVaultTests
//
//  Created by Faruk on 24.07.2026.
//

import Foundation
import Testing
@testable import MovieVault

@MainActor
struct DetailViewModelTests {
    
    @Test
    func fetchAllDetails_WhenMovieDetailsThrows_SetsErrorState() async {
        // Given
        let repository = MockMovieRepository()
        repository.movieDetailsError = MockError.network
        
        let viewModel = DetailViewModel(
            repository: repository,
            movieID: 1
        )
        
        // When
        await viewModel.fetchAllDetails()
        
        // Then
        #expect(viewModel.movie == nil)
        #expect(viewModel.state == .error(MockError.network.localizedDescription))
    }
    
    @Test
    func fetchAllDetails_WhenMovieCastThrows_SetsEmptyCastAndLoadedState() async {
        // Given
        let repository = MockMovieRepository()
        repository.castError = MockError.network
        
        let viewModel = DetailViewModel(
            repository: repository,
            movieID: 1
        )
        
        // When
        await viewModel.fetchAllDetails()
        
        // Then
        #expect(viewModel.movie != nil)
        #expect(viewModel.cast.isEmpty)
        #expect(viewModel.state == .loaded)
    }
    
    @Test
    func fetchAllDetails_WhenMovieTrailerThrows_SetsNilTrailerAndLoadedState() async {
        // Given
        let repository = MockMovieRepository()
        repository.videosError = MockError.network

        let viewModel = DetailViewModel(
            repository: repository,
            movieID: 1
        )

        // When
        await viewModel.fetchAllDetails()

        // Then
        #expect(viewModel.movie != nil)
        #expect(viewModel.trailer == nil)
        #expect(viewModel.state == .loaded)
    }
    
    @Test
    func fetchAllDetails_WhenVideosContainDifferentTypes_SelectsYouTubeTrailer() async {
        // Given
        let repository = MockMovieRepository()
        
        let viewModel = DetailViewModel(
            repository: repository,
            movieID: 1
        )
        
        // When
        await viewModel.fetchAllDetails()
        
        // Then
        #expect(viewModel.movie != nil)
        #expect(viewModel.trailer?.key == "trailer_key")
        #expect(viewModel.state == .loaded)
    }
    
    @Test
    func fetchAllDetails_WhenEverythingSucceeds_LoadsAllData() async {
        // Given
        let repository = MockMovieRepository()
        
        let viewModel = DetailViewModel(
            repository: repository,
            movieID: 1
        )
        
        // When
        await viewModel.fetchAllDetails()
        
        // Then
        #expect(viewModel.movie != nil)
        #expect(viewModel.cast.count == 1)
        #expect(viewModel.trailer != nil)
        #expect(viewModel.state == .loaded)
    }
}
