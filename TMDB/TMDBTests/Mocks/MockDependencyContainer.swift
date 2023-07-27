//
//  MockDependencyContainer.swift
//  TMDBTests
//
//  Created by Nishant Patel on 7/26/23.
//

import Foundation

@testable import TMDB

class MockDependencyContainer: MoviesProviderService {
    var moviesProviderService: MoviesProvider
    
    init(mockMoviesProvider: MoviesProvider = MockMoviesProvider()) {
        self.moviesProviderService = mockMoviesProvider
    }
}
