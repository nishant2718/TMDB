//
//  MovieListViewModel.swift
//  TMDB
//
//  Created by Nishant Patel on 7/25/23.
//

import Foundation

class MovieListViewModel {
    typealias Dependencies = MoviesProviderService

    private let moviesProvider: MoviesProvider
    
    var coordinator: MovieListCoordinator?
    var movies: [Movie] = []
    var page: Int = 1
    
    init(with dependencies: Dependencies) {
        self.moviesProvider = dependencies.moviesProviderService
    }
    
    func viewDidLoad() {
        // TODO: This is temporary. When you finish using this data to make your UI, then load movies properly.
        Task {
            movies = try await moviesProvider.getMoviesFor("hitman", and: page, using: .shared)
            print(movies)
        }
    }
    
    func viewDidDisappear() {
        // no-op
    }
    
    // MARK: Routing
    
    func handleMovieTappedFor(_ movie: Movie) {
        // TODO: Navigate to the details page
        // no-op
    }
    
}
