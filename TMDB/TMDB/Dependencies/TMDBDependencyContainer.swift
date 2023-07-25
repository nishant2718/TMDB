//
//  TMDBDependencyContainer.swift
//  TMDB
//
//  Created by Nishant Patel on 7/25/23.
//

import Foundation

protocol MoviesProviderService {
    var moviesProviderService: MoviesProvider { get }
}

struct TMDBDependencyContainer: MoviesProviderService {
    let moviesProviderService: MoviesProvider
    
    init(moviesProviderService: MoviesProvider = NetworkManager()) {
        self.moviesProviderService = moviesProviderService
    }
}
