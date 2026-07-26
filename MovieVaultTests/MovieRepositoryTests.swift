//
//  MovieVaultTests.swift
//  MovieVaultTests
//
//  Created by Faruk on 23.07.2026.
//

import Testing
@testable import MovieVault

@MainActor
struct MovieRepositoryTests {

    @Test
    func fetchMovieDetails_WhenServiceThrows_RepositoryThrowsError() async {

        // Given
        let mockService = MockMovieService()
        mockService.shouldThrowError = true

        let repository = MovieRepository(service: mockService)

        // When / Then
        await #expect(throws: MockError.network) {
            try await repository.fetchMovieDetails(id: 1)
        }
    }
    
    @Test
    func fetchMovieCast_UsesCacheOnSecondRequest() async throws {
        
        // Given
        let mockService = MockMovieService()
        let repository = MovieRepository(service: mockService)
        
        // When
        _ = try await repository.fetchMovieCast(id: 1)
        _ = try await repository.fetchMovieCast(id: 1)
        
        // Then
        #expect(mockService.fetchMovieCastCallCount == 1)
    }
    
    @Test
    func fetchMovieVideos_UsesCacheOnSecondRequest() async throws {
        
        // Given
        let mockService = MockMovieService()
        let repository = MovieRepository(service: mockService)
        
        // When
        _ = try await repository.fetchMovieVideos(id: 1)
        _ = try await repository.fetchMovieVideos(id: 1)
        
        // Then
        #expect(mockService.fetchMovieVideosCallCount == 1)
    }
}
